-- @Autor:  Ariadna Lázaro
-- @Fecha:  12/11/2023
-- @Descripcion: Procedimientos op con BLOB

whenever sqlerror exit rollback;

--ruta donde se ubicarán los archivos PDFs
define p_pdf_path='/unam-bdd/ejercicios-practicos/ep-06/pdf'
set verify off

Prompt Limpiando y creando directorio en &p_pdf_path
!rm -rf &p_pdf_path
!mkdir -p &p_pdf_path
!chmod 777 &p_pdf_path

-- Se asume que los PDFs se encuentran en el mismo directorio donde se
-- ejecuta este script, es decir en /unam-bdd/ejercicios-practicos/ep-06, se realiza la copia
-- de los PDFs y se cambian los permisos
!cp m_archivo_*.pdf &p_pdf_path
!chmod 755 &p_pdf_path/m_archivo_*.pdf

--bdd_s1
Prompt conectando a aalmbdd_s1 como SYS para crear objetos tipo directory
accept p_sys_password default 'system' prompt 'Password de sys [system]: ' hide
connect sys@aalmbdd_s1/&p_sys_password as sysdba
Prompt creando un objeto DIRECTORY para acceder al directorio &p_pdf_path
create or replace directory tmp_dir as '&p_pdf_path';
grant read,write on directory tmp_dir to editorial_bdd;

--bdd_s2
--Seguir el mismo procedimiento para bdd_s2
Prompt conectando a aalmbdd_s2 como SYS para crear objetos tipo directory
accept p_sys_password default 'system' prompt 'Password de sys [system]: ' hide
connect sys@aalmbdd_s2/&p_sys_password as sysdba
Prompt creando un objeto DIRECTORY para acceder al directorio &p_pdf_path
create or replace directory tmp_dir as '&p_pdf_path';
grant read,write on directory tmp_dir to editorial_bdd;


------------------ Cargando datos en bdd_s1 ----------------------
Prompt conectando a aalmbdd_s1 con usuario editorial_bdd para cargar datos binarios
connect editorial_bdd/editorial_bdd@aalmbdd_s1

Prompt ejecutando procedimientos para hacer import/export de datos BLOB
@s-00-carga-blob-en-bd.sql
@s-00-guarda-blob-en-archivo.sql

Prompt cargando datos binarios en aalmbdd_s1
begin
  carga_blob_en_bd('TMP_DIR','m_archivo_3.pdf','f_aalm_pago_suscriptor_1',
  'recibo_pago','num_pago','1','suscriptor_id','1');
end;
/

Prompt mostrando el tamaño de los objetos BLOB en BD.

Prompt para f_aalm_pago_suscriptor_1:
select num_pago,suscriptor_id,dbms_lob.getlength(recibo_pago) as longitud
from f_aalm_pago_suscriptor_1;

Prompt salvando datos BLOB en directorio TMP_DIR
begin
  guarda_blob_en_archivo('TMP_DIR','m_export_archivo_3.pdf',
  'f_aalm_pago_suscriptor_1','recibo_pago','num_pago','1','suscriptor_id','1');
end;
/


Prompt mostrando el contenido del directorio para validar la existencia del archivo.
!ls -l &p_pdf_path/m_export_archivo_*.pdf



------------------ Cargando datos en bdd_s2 ----------------------
--Seguir el mismo procedimiento para bdd_s2

connect editorial_bdd/editorial_bdd@aalmbdd_s2

Prompt ejecutando procedimientos para hacer import/export de datos BLOB
@s-00-carga-blob-en-bd.sql
@s-00-guarda-blob-en-archivo.sql

Prompt cargando datos binarios en aalmbdd_s2
begin
  carga_blob_en_bd('TMP_DIR','m_archivo_4.pdf','f_aalm_pago_suscriptor_2',
  'recibo_pago','num_pago','70','suscriptor_id','2');
end;
/
begin
  carga_blob_en_bd('TMP_DIR','m_archivo_1.pdf','f_aalm_articulo_1',
  'pdf','articulo_id',1,null,null);
end;
/
begin
  carga_blob_en_bd('TMP_DIR','m_archivo_2.pdf','f_aalm_articulo_1',
  'pdf','articulo_id',2,null,null);
end;
/

Prompt mostrando el tamaño de los objetos BLOB en BD.

Prompt para f_aalm_pago_suscriptor_2:
select num_pago,suscriptor_id,dbms_lob.getlength(recibo_pago) as longitud
from f_aalm_pago_suscriptor_2;

Prompt para f_aalm_articulo_1:
select articulo_id,dbms_lob.getlength(pdf) as longitud
from f_aalm_articulo_1;

Prompt salvando datos BLOB en directorio TMP_DIR

begin
  guarda_blob_en_archivo('TMP_DIR','m_export_archivo_1.pdf',
  'f_aalm_articulo_1','pdf','articulo_id','1',null,null);
end;
/

begin
  guarda_blob_en_archivo('TMP_DIR','m_export_archivo_4.pdf',
  'f_aalm_pago_suscriptor_2','recibo_pago','num_pago','70','suscriptor_id','2');
end;
/


begin
  guarda_blob_en_archivo('TMP_DIR','m_export_archivo_2.pdf',
  'f_aalm_articulo_1','pdf','articulo_id','2',null,null);
end;
/

Prompt mostrando el contenido del directorio para validar la existencia del archivo.
!ls -l &p_pdf_path/m_export_archivo_*.pdf


