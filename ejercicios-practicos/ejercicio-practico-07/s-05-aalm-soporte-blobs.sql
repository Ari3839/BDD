--@Autor: Ariadna Lázaro
--@Fecha creación: 15/11/2023
--@Descripción: Creación de vistas con manejo de blobs

Prompt connectando a aalmbdd_s2
connect  editorial_bdd/editorial_bdd@aalmbdd_s2

prompt ---
Prompt Paso 1. creando vistas con columnas blob locales.

create or replace view articulo as
  select a1.articulo_id,a1.pdf,a2.titulo,a2.resumen,a2.texto 
  from articulo_1 a1 join articulo_2 a2
  on a1.articulo_id=a2.articulo_id;


prompt ---
Prompt Paso 2 creando objetos type para vistas que involucran blobs remotos


create type recibo_type as object(
  num_pago number(10,0),
  suscriptor_id number(10,0),
  fecha_pago date,
  importe number(8,2),
  recibo_pago blob
);
/
show errors;

prompt ---
Prompt Paso 3 creando objetos table para vistas que involucran blobs remotos

create or replace type recibo_table as table of recibo_type;
/
show errors;


prompt ---
Prompt Paso 4 creando tablas temporales para vistas que involucran blobs remotos

create global temporary table t_aalm_pago_suscriptor_1(
  num_pago number(10,0) not null,
  suscriptor_id number(10,0) not null,
  fecha_pago date not null,
  importe number(8,2) not null,
  recibo_pago blob not null,
  constraint t_aalm_pago_suscriptor_1_pk primary key(num_pago,suscriptor_id)
) on commit preserve rows;


prompt ---
Prompt Paso 5 Creando funcion con estrategia 1 para vistas que involucran blobs remotos

create or replace function get_remote_recibo return recibo_table pipelined is
  pragma autonomous_transaction;
  v_temp_recibo blob;
begin
  --Inicia txn autónoma 1.
  --asegura que no haya registros
  delete from t_aalm_pago_suscriptor_1;
  --Inserta los datos obtenidos del fragmento remoto a la tabla temporal.
  insert into t_aalm_pago_suscriptor_1 
    select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago
    from pago_suscriptor_1;
  --termina txn autónoma 1 antes de iniciar con la construcción
  --del objeto pdf_table
  commit;
  --obtiene los registros de la tabla temporal y los regresa como
  --objetos tipo pdf_type
  for cur in (select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago 
    from t_aalm_pago_suscriptor_1)
  loop
    pipe row(recibo_type(cur.num_pago,cur.suscriptor_id,cur.fecha_pago,
      cur.importe,cur.recibo_pago));
  end loop;
  --Inicia txn autónoma 2 para limpiar la tabla
  --elimina los registros de la tabla temporal una vez que han sido obtenidos.
  delete from t_aalm_pago_suscriptor_1;
  --termina txn autónoma 2
  commit;
  return;
exception
  when others then
    rollback;
    --relanza el error para que sea propagado a quien invoque a esta función
  end;
  /
show errors;


prompt ---
Prompt Paso 6 Creando funcion con estrategia 2 para vistas que involucran blobs remotos

create or replace function get_remote_recibo_by_id(v_num_pago in number) return blob is
  pragma autonomous_transaction;
  v_temp_recibo blob;
begin
  --Inicia txn autónoma 1.
  --asegura que no haya registros
  delete from t_aalm_pago_suscriptor_1;
  --Inserta los datos obtenidos del fragmento remoto a la tabla temporal.
  insert into t_aalm_pago_suscriptor_1 
    select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago 
    from pago_suscriptor_1 where num_pago=v_num_pago;
  --obtiene el registro de la tabla temporal y lo regresa como blob
  select recibo_pago into v_temp_recibo from t_aalm_pago_suscriptor_1 
    where num_pago = v_num_pago;
  --termina txn autónoma 1 antes de iniciar con la construcción
  --elimina los registros de la tabla temporal una vez que han sido obtenidos.
  delete from t_aalm_pago_suscriptor_1;
  commit;
  return v_temp_recibo;
exception
  when others then
    rollback;
    raise;
  end;
/

prompt ---
Prompt Paso 7 Crear las vistas con datos blob remotos empleando estrategia 1

create or replace view pago_suscriptor_e1 as 
  select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago 
  from table(get_remote_recibo)
  union all
  select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago 
  from pago_suscriptor_2;


prompt ---
Prompt Paso 8 Crear las vistas con datos blob remotos empleando estrategia 2

create or replace view pago_suscriptor_e2 as
  select num_pago,suscriptor_id,fecha_pago,importe,
  get_remote_recibo_by_id(num_pago) as recibo_pago
  from pago_suscriptor_1
  union all
  select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago 
  from pago_suscriptor_2;

prompt ---
Prompt Paso 9 Crear un sinonimo con el nombre global del fragmento que apunte a la estrategia 2.

create or replace synonym pago_suscriptor for pago_suscriptor_e2;

Prompt Listo!


























Prompt connectando a aalmbdd_s1
connect  editorial_bdd/editorial_bdd@aalmbdd_s1

prompt ---
Prompt Paso 2 creando objetos type para vistas que involucran blobs remotos

create type pdf_type as object(
  articulo_id number(10,0),
  pdf blob
);
/
show errors;

create type recibo_type as object(
  num_pago number(10,0),
  suscriptor_id number(10,0),
  fecha_pago date,
  importe number(8,2),
  recibo_pago blob
);
/
show errors;


prompt ---
Prompt Paso 3 creando objetos table para vistas que involucran blobs remotos

create or replace type pdf_table as table of pdf_type;
/
show errors;

create or replace type recibo_table as table of recibo_type;
/
show errors;



prompt ---
Prompt Paso 4 creando tablas temporales para vistas que involucran blobs remotos

create global temporary table t_aalm_articulo_1(
  articulo_id number(10,0) constraint t_aalm_articulo_1_pk primary key,
  pdf blob not null
) on commit preserve rows;

create global temporary table t_aalm_pago_suscriptor_2(
  num_pago number(10,0) not null,
  suscriptor_id number(10,0) not null,
  fecha_pago date not null,
  importe number(8,2) not null,
  recibo_pago blob not null,
  constraint t_aalm_pago_suscriptor_2_pk primary key(num_pago,suscriptor_id)
) on commit preserve rows;



prompt ---
Prompt Paso 5 Creando funcion con estrategia 1 para vistas que involucran blobs remotos

create or replace function get_remote_pdf return pdf_table pipelined is
pragma autonomous_transaction;
  v_temp_pdf blob;
begin
  --Inicia txn autónoma 1.
  --asegura que no haya registros
  delete from t_aalm_articulo_1;
  --Inserta los datos obtenidos del fragmento remoto a la tabla temporal.
  insert into t_aalm_articulo_1 select articulo_id,pdf from articulo_1;
  --termina txn autónoma 1 antes de iniciar con la construcción
  --del objeto pdf_table
  commit;
  --obtiene los registros de la tabla temporal y los regresa como
  --objetos tipo pdf_type
  for cur in (select articulo_id,pdf from t_aalm_articulo_1)
  loop
    pipe row(pdf_type(cur.articulo_id,cur.pdf));
  end loop;
  --Inicia txn autónoma 2 para limpiar la tabla
  --elimina los registros de la tabla temporal una vez que han sido obtenidos.
  delete from t_aalm_articulo_1;
  --termina txn autónoma 2
  commit;
  return;
exception
  when others then
    rollback;
    --relanza el error para que sea propagado a quien invoque a esta función
  end;
  /
show errors;


create or replace function get_remote_recibo return recibo_table pipelined is
  pragma autonomous_transaction;
  v_temp_recibo blob;
begin
  --Inicia txn autónoma 1.
  --asegura que no haya registros
  delete from t_aalm_pago_suscriptor_2;
  --Inserta los datos obtenidos del fragmento remoto a la tabla temporal.
  insert into t_aalm_pago_suscriptor_2 
    select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago
    from pago_suscriptor_2;
  --termina txn autónoma 1 antes de iniciar con la construcción
  --del objeto pdf_table
  commit;
  --obtiene los registros de la tabla temporal y los regresa como
  --objetos tipo pdf_type
  for cur in (select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago 
    from t_aalm_pago_suscriptor_2)
  loop
    pipe row(recibo_type(cur.num_pago,cur.suscriptor_id,cur.fecha_pago,
      cur.importe,cur.recibo_pago));
  end loop;
  --Inicia txn autónoma 2 para limpiar la tabla
  --elimina los registros de la tabla temporal una vez que han sido obtenidos.
  delete from t_aalm_pago_suscriptor_2;
  --termina txn autónoma 2
  commit;
  return;
exception
  when others then
    rollback;
    --relanza el error para que sea propagado a quien invoque a esta función
  end;
  /
show errors;



prompt ---
Prompt Paso 6 Creando funcion con estrategia 2 para vistas que involucran blobs remotos

create or replace function get_remote_pdf_by_id(v_articulo_id in number) return blob is
  pragma autonomous_transaction;
  v_temp_pdf blob;
begin
  --Inicia txn autónoma 1.
  --asegura que no haya registros
  delete from t_aalm_articulo_1;
  --Inserta los datos obtenidos del fragmento remoto a la tabla temporal.
  insert into t_aalm_articulo_1 select articulo_id,pdf 
    from articulo_1 where articulo_id=v_articulo_id;
  --obtiene el registro de la tabla temporal y lo regresa como blob
  select pdf into v_temp_pdf from t_aalm_articulo_1 where articulo_id = v_articulo_id;
  --termina txn autónoma 1 antes de iniciar con la construcción
  --elimina los registros de la tabla temporal una vez que han sido obtenidos.
  delete from t_aalm_articulo_1;
  commit;
  return v_temp_pdf;
exception
  when others then
    rollback;
    raise;
  end;
/

create or replace function get_remote_recibo_by_id(v_num_pago in number) return blob is
  pragma autonomous_transaction;
  v_temp_recibo blob;
begin
  --Inicia txn autónoma 1.
  --asegura que no haya registros
  delete from t_aalm_pago_suscriptor_2;
  --Inserta los datos obtenidos del fragmento remoto a la tabla temporal.
  insert into t_aalm_pago_suscriptor_2 
    select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago 
    from pago_suscriptor_2 where num_pago=v_num_pago;
  --obtiene el registro de la tabla temporal y lo regresa como blob
  select recibo_pago into v_temp_recibo from t_aalm_pago_suscriptor_2
    where num_pago = v_num_pago;
  --termina txn autónoma 1 antes de iniciar con la construcción
  --elimina los registros de la tabla temporal una vez que han sido obtenidos.
  delete from t_aalm_pago_suscriptor_2;
  commit;
  return v_temp_recibo;
exception
  when others then
    rollback;
    raise;
  end;
/


prompt ---
Prompt Paso 7 Crear las vistas con datos blob remotos empleando estrategia 1

create or replace view articulo_e1 as 
  select t.articulo_id,a2.titulo,a2.resumen,a2.texto,t.pdf 
  from table(get_remote_pdf) t join articulo_2 a2
  on t.articulo_id=a2.articulo_id;

create or replace view pago_suscriptor_e1 as 
  select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago 
  from pago_suscriptor_1
  union all
  select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago 
  from table(get_remote_recibo);


prompt ---
Prompt Paso 8 Crear las vistas con datos blob remotos empleando estrategia 2

create or replace view articulo_e2 as
  select a2.articulo_id,a2.titulo,a2.resumen,
  a2.texto,get_remote_pdf_by_id(a2.articulo_id) as pdf 
  from articulo_2 a2;

create or replace view pago_suscriptor_e2 as
  select num_pago,suscriptor_id,fecha_pago,importe,recibo_pago
  from pago_suscriptor_1
  union all
  select num_pago,suscriptor_id,fecha_pago,importe,
  get_remote_recibo_by_id(num_pago) as recibo_pago
  from pago_suscriptor_2;

prompt ---
Prompt Paso 9 Crear un sinonimo con el nombre global del fragmento que apunte a la estrategia 2.

create or replace synonym articulo for articulo_e2;

create or replace synonym pago_suscriptor for pago_suscriptor_e2;

Prompt Listo!

--exit