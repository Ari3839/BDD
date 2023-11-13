--@Author Jorge A. Rodriguez C
--Procedimiento empleado para exportar un el contenido de una columna BLOB a
--un archivo. Se emplea el valor de la llave primaria para localizar el registro.
--Instrucciones:
-- 1. Como SYS crear un directorio virtual en el que se guardará el archivo.
-- Por Ejemplo
-- create or replace directory tmp_dir as '/tmp/bdd';
-- 2. Como SYS otorgar permisos de lectura y escritura al usuario que va
-- ejecutar el script.
-- grant read,write on directory tmp_dir to <my_user>;
-- 3. Suponer que se desea leer el contenido de la columna pdf de la tabla:
-- create table my_table(
-- id number(2,0) ,
-- pdf blob
-- );
-- 4. Invocar el procedimiento:
--
-- exec save_file_from_blob('TMP_DIR','revista3.pdf','my_table','pdf','id','5');
-- parámetro 1: nombre del directorio virtual creado anteriormente
-- parámetro 2: nombre del archivo dentro del directorio configurado
-- parámetro 3: nombre de la tabla que contiene lacolumna a leer
-- parámetro 4: nombre de la columna tipo blob.
-- parámetro 5: nombre de la columna que actua como PK.
-- parámetro 6: valor de la PK que se emplea para localizar al registro cuyo
-- valor de la columna de tipo blob se va a leer.
create or replace procedure guarda_blob_en_archivo(
  v_directory_name in varchar2,
  v_dest_file_name in varchar2,
  v_table_name in varchar2,
  v_blob_column_name in varchar2,
  v_pk_column_name in varchar2,
  v_pk_column_value in varchar2,
  v_pk_column_name2 in varchar2,
  v_pk_column_value2 in varchar2) is
  v_file utl_file.FILE_TYPE;
  v_buffer_size number :=32767;
  v_buffer RAW(32767);
  v_blob blob;
  v_blob_length number;
  v_position number;
  v_query varchar2(2000);

begin
  v_query := 'select '
    ||v_blob_column_name
    ||' into :ph '
    ||' from '
    ||v_table_name
    ||' where '
    ||v_pk_column_name
    ||'='
    ||':ph1';

  if v_pk_column_name2 is not null then
    v_query := v_query||' and '||v_pk_column_name2||'='||':ph2';
  end if;

  dbms_output.put_line(v_query);

  --ejecuta query dinámico
  if v_pk_column_name2 is not null then
    execute immediate v_query into v_blob using v_pk_column_value,v_pk_column_value2;
  else
    execute immediate v_query into v_blob using v_pk_column_value;
  end if;

  v_blob_length := dbms_lob.getlength(v_blob);
  v_position := 1;
  v_file := utl_file.fopen(v_directory_name,v_dest_file_name,'wb',32767);
  --lee el archivos por partes hasta completar
  while v_position < v_blob_length loop
    dbms_lob.read(v_blob,v_buffer_size,v_position,v_buffer);
    UTL_FILE.put_raw(v_file,v_buffer,TRUE);
    v_position := v_position+v_buffer_size;
  end loop;
  utl_file.fclose(v_file);

  -- cierra el archivo en caso de error y relanza la excepción.
  exception when others then
  --cerrar v_file en caso de error.
  if utl_file.is_open(v_file) then
    utl_file.fclose(v_file);
  end if;
  raise;
end;
/
show errors;