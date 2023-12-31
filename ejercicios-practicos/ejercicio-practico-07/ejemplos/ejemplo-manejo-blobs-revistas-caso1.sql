clear screen
--Habilitar esta instruccion si se desea salir de sqlplus al obtener un error
whenever sqlerror exit rollback;

--copia un PDF de muestra (modificar segun corresponda)
!rm -rf  /tmp/bdd/sample.pdf
!mkdir -p /tmp/bdd
!cp  sample.pdf /tmp/bdd/
!chmod 755 /tmp/bdd/sample.pdf

--Cambiar la ruta segun corresponda (ruta donde esta el script para cargar Blobs)
define blob_script = 's-00-carga-blob-en-bd.sql';

--Usuarios
connect sys/system@jrcbdd_s1 as sysdba
drop user ejemplo_revistas cascade;
create user ejemplo_revistas identified by ejemplo_revistas quota unlimited on users; 
grant create session, create view, create procedure, create trigger to ejemplo_revistas;
grant create synonym, create type, create table,create database link to ejemplo_revistas;
grant read on directory tmp_dir to ejemplo_revistas;
--modificar el directorio segun corresponda
create or replace directory tmp_dir as '/tmp/bdd'; 

connect sys/system@jrcbdd_s2 as sysdba
drop user ejemplo_revistas cascade;
create user ejemplo_revistas identified by ejemplo_revistas quota unlimited on users; 
grant create session, create view, create procedure, create trigger to ejemplo_revistas;
grant create synonym, create type, create table,create database link to ejemplo_revistas;
grant read on directory tmp_dir to ejemplo_revistas;
--modificar el directorio segun corresponda  
create or replace directory tmp_dir as '/tmp/bdd'; 


connect ejemplo_revistas/ejemplo_revistas@jrcbdd_s1
Prompt creando ligas y procedimiento para cargar BLOBs en S1
create database link jrcbdd_s2.fi.unam using 'jrcbdd_s2';
--crea procedimiento para cargar BLOBs (modificar la ruta segun corresponda)
@ &blob_script;
Prompt creando fragmentos en S1
create table f_jrc_revista_1(
	revista_id number(10,0) constraint revista_pk1 primary key,
	tipo  char(1) not null,
	nombre varchar2(40) not null
);

connect ejemplo_revistas/ejemplo_revistas@jrcbdd_s2
Prompt creando ligas y procedimiento para cargar BLOBs en S2
create database link jrcbdd_s1.fi.unam using 'jrcbdd_s1';
--crea procedimiento para cargar BLOBs (modificar la ruta segun corresponda)
@ &blob_script;

Prompt creando fragmentos en S2
create table f_jrc_revista_2(
	revista_id number(10,0) constraint revista_pk2 primary key,
	tipo  char(1) not null,
	nombre varchar2(40) not null
);

create table f_jrc_revista_3(
	revista_id number(10,0) constraint revista_pk3 primary key,
	pdf blob not null
);


Prompt creando sinonimos para  S1
connect ejemplo_revistas/ejemplo_revistas@jrcbdd_s1
create or replace synonym revista_1 for f_jrc_revista_1;
create or replace synonym revista_2 for f_jrc_revista_2@jrcbdd_s2;
create or replace synonym revista_3 for f_jrc_revista_3@jrcbdd_s2;

Prompt creando sinonimos para  S2
connect ejemplo_revistas/ejemplo_revistas@jrcbdd_s2
create or replace synonym revista_1 for f_jrc_revista_1@jrcbdd_s1;
create or replace synonym revista_2 for f_jrc_revista_2;
create or replace synonym revista_3 for f_jrc_revista_3;

--En S2 se crea la vista que no requiere manejo especial de
--BLOBs
Prompt creando vistas en S2
connect ejemplo_revistas/ejemplo_revistas@jrcbdd_s2
create or replace view revista as
	select q1.revista_id,q1.tipo,q1.nombre,q2.pdf
    from (
		select revista_id,tipo,nombre from revista_1
		union
	    select revista_id,tipo,nombre from revista_2
	 ) q1
    join (select revista_id, pdf from revista_3)  q2
    on q1.revista_id = q2.revista_id;

------
--En S1 se requiere manejo especial para BLOBs ya que
--el fragmento con columnas BLOB esta en S2 (sitio remoto)
------
Prompt creando objetos para manejo de blob en s1 
connect ejemplo_revistas/ejemplo_revistas@jrcbdd_s1
create type pdf_type as object (
	revista_id number(10,0),
	pdf blob
);
/
show errors;

create or replace type pdf_table as table of pdf_type;
/
show errors;

--tabla temporal para manejar blobs - transparencia para select
create global temporary table t_select_revista_3(
	revista_id number(10,0) constraint t_select_revista_3_pk  primary key,
	pdf blob not null
) on commit preserve rows;

--funcion para implementar la estrategia 1
create or replace function get_remote_pdf return pdf_table pipelined is
	pragma autonomous_transaction;
	v_temp_pdf blob;
	begin
    	--asegura que no haya registros
    	delete from t_select_revista_3;
    	--inserta los datos obtenidos del fragmento remoto a la tabla temporal.
    	insert into t_select_revista_3 select revista_id,pdf from revista_3;
    	commit;
    	--obtiene los registros de la tabla temporal y los regresa como objetos tipo pdf_type
    	for cur in (select revista_id,pdf from t_select_revista_3) 
    	loop
    		pipe row(pdf_type(cur.revista_id,cur.pdf));
    	end loop;
    	--elimina los registros de la tabla temporal una vez que han sido obtenidos.
    	delete from t_select_revista_3;
    	commit;
   		return;
  end;
  /

--funcion empleada para la estrategia 2
create or replace function get_remote_pdf_by_id(v_revista_id in number ) return blob is
	pragma autonomous_transaction;
	v_temp_pdf blob;
	begin
      --dbms_output.put_line('invocando fx '||v_revista_id);
    	--asegura que no haya registros
    	delete from t_select_revista_3;
    	--inserta los datos obtenidos del fragmento remoto a la tabla temporal.
    	insert into t_select_revista_3 select revista_id,pdf 
    		from revista_3 where revista_id = v_revista_id;
    	--obtiene el registro de la tabla temporal y lo regresa como blob
    	select pdf into v_temp_pdf from t_select_revista_3 where revista_id = v_revista_id;
    	--elimina los registros de la tabla temporal una vez que han sido obtenidos.
    	delete from t_select_revista_3;
    	commit;
   		return v_temp_pdf;
   	exception
   		when others then
   			rollback;
   			raise;
  end;
  /

-- Se crea la vista en S1 con los objetos creados anteriormente
-- con la estrategia 1
create or replace view revista_e1 as
	select q1.revista_id,q1.tipo,q1.nombre, q2.pdf as pdf
    from (
		select revista_id,tipo,nombre from revista_1
		union
	    select revista_id,tipo,nombre from revista_2
	 ) q1 join (
	 	select * from table (get_remote_pdf) 
	 ) q2 on q1.revista_id = q2.revista_id;

-- Se crea la vista en S1 con los objetos creados anteriormente
-- con la estrategia 2
create or replace view revista_e2 as
	select q1.revista_id,q1.tipo,q1.nombre, get_remote_pdf_by_id(revista_id) as pdf
    from (
		select revista_id,tipo,nombre from revista_1
		union
	    select revista_id,tipo,nombre from revista_2
	 ) q1;

----
--- Las siguientes instrucciones se emplean para probar el ejemplo
----
connect ejemplo_revistas/ejemplo_revistas@jrcbdd_s1
prompt  poblando revista en jrcbdd_s1
insert into revista_1 values(1,'A','Revista 1');
insert into revista_1 values(2,'A','Revista 2');
insert into revista_1 values(3,'A','Revista 3');
insert into revista_1 values(4,'A','Revista 4');
insert into revista_1 values(5,'A','Revista 5');
commit;

connect ejemplo_revistas/ejemplo_revistas@jrcbdd_s2
prompt  poblando revista en jrcbdd_s2
insert into revista_2 values(6,'B','Revista 6');
insert into revista_2 values(7,'B','Revista 7');
insert into revista_2 values(8,'B','Revista 8');
insert into revista_2 values(9,'B','Revista 9');
insert into revista_2 values(10,'B','Revista 10');
--insertando en el fragmento 3 (PDFs vacios)
insert into revista_3 values(1,empty_blob());
insert into revista_3 values(2,empty_blob());
insert into revista_3 values(3,empty_blob());
insert into revista_3 values(4,empty_blob());
insert into revista_3 values(5,empty_blob());
insert into revista_3 values(6,empty_blob());
insert into revista_3 values(7,empty_blob());
insert into revista_3 values(8,empty_blob());
insert into revista_3 values(9,empty_blob());
insert into revista_3 values(10,empty_blob());

Prompt cargando BLOBs
exec carga_blob_en_bd('TMP_DIR','sample.pdf','f_jrc_revista_3','pdf','revista_id','1',null,null);
exec carga_blob_en_bd('TMP_DIR','sample.pdf','f_jrc_revista_3','pdf','revista_id','2',null,null);
exec carga_blob_en_bd('TMP_DIR','sample.pdf','f_jrc_revista_3','pdf','revista_id','3',null,null);
exec carga_blob_en_bd('TMP_DIR','sample.pdf','f_jrc_revista_3','pdf','revista_id','4',null,null);
exec carga_blob_en_bd('TMP_DIR','sample.pdf','f_jrc_revista_3','pdf','revista_id','5',null,null);
exec carga_blob_en_bd('TMP_DIR','sample.pdf','f_jrc_revista_3','pdf','revista_id','6',null,null);
exec carga_blob_en_bd('TMP_DIR','sample.pdf','f_jrc_revista_3','pdf','revista_id','7',null,null);
exec carga_blob_en_bd('TMP_DIR','sample.pdf','f_jrc_revista_3','pdf','revista_id','8',null,null);
exec carga_blob_en_bd('TMP_DIR','sample.pdf','f_jrc_revista_3','pdf','revista_id','9',null,null);
exec carga_blob_en_bd('TMP_DIR','sample.pdf','f_jrc_revista_3','pdf','revista_id','10',null,null);
commit;

Prompt verificando resultados:
connect ejemplo_revistas/ejemplo_revistas@jrcbdd_s1;
-- Aqui se distuingue entre las 2 vistas para poder probar ambas estrategias: revista_e1 y revista_e2
Prompt probando  con estrategia 1 en sitio 1
select revista_id,tipo,nombre,dbms_lob.getlength(pdf) as longitud from revista_e1;
Prompt Probando con estrategia 2 en sitio 1
select revista_id,tipo,nombre,dbms_lob.getlength(pdf) as longitud from revista_e2;

connect ejemplo_revistas/ejemplo_revistas@jrcbdd_s2;
--aqui no se requiere acceso especial
Prompt probando en el sitio 2 - acceso local
select revista_id,tipo,nombre,dbms_lob.getlength(pdf) from revista;

Prompt Listo!
exit
