-- @Autor:  Ariadna Lázaro
-- @Fecha:  15/10/2023
-- @Descripcion:Borra tablas si ya existen


prompt Conectándose a aalmbdd_s1 como usuario SYS
connect sys/system@aalmbdd_s1 as sysdba

Prompt Tabla ARTICULO_2
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='ARTICULO_2';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/


Prompt Tabla REVISTA_1
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='REVISTA_1';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/




Prompt Tabla PAIS_1
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='PAIS_1';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/



Prompt Tabla SUSCRIPTOR_2
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='SUSCRIPTOR_2';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/



Prompt Tabla SUSCRIPTOR_1
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='SUSCRIPTOR_1';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/



Prompt Tabla PAGO_1
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='PAGO_1';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/



Prompt Tabla SUSCRIPTOR_3 
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='SUSCRIPTOR_3 ';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/



Prompt Tabla ARTICULO_REVISTA_1 
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='ARTICULO_REVISTA_1';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/


prompt Conectándose a aalmbdd_s2 como usuario SYS
connect sys/system@aalmbdd_s2 as sysdba

Prompt Tabla ARTICULO_1
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='ARTICULO_1';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

Prompt Tabla REVISTA_2
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='REVISTA_2';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

Prompt Tabla PAGO_2 
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='PAGO_2';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

Prompt Tabla PAIS_2
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='PAIS_2';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

Prompt Tabla SUSCRIPTOR_4 
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='SUSCRIPTOR_4 ';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

Prompt Tabla ARTICULO_REVISTA_2
declare
  v_count number;
  v_owner varchar2(20) := 'EDITORIAL_BDD';
  v_tablename varchar2(50):='ARTICULO_REVISTA_2';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/