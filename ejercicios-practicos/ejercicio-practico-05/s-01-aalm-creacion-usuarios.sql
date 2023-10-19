-- @Autor:  Ariadna Lázaro
-- @Fecha:  15/10/2023
-- @Descripcion:Creacion del usuario para trabajar el ejercicio

--Instrucciones de ejecución
--sqlplus /nolog
--@s-01-aalm-creacion-usuarios.sql

prompt Conectándose a aalmbdd_s1 como usuario SYS
connect sys/system@aalmbdd_s1 as sysdba

declare
  v_count number;
  v_username varchar2(20) := 'EDITORIAL_BDD';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count >0 then
    execute immediate 'drop user '||v_username|| 'cascade';
  end if;
end;
/
Prompt creando al usuario editorial_bdd
create user editorial_bdd identified by editorial_bdd quota unlimited on users;
grant create procedure, create session, create table, create sequence to editorial_bdd;

Prompt comprobando creación del user
connect editorial_bdd/editorial_bdd@aalmbdd_s1


prompt Conectándose a aalmbdd_s2 como usuario SYS
connect sys/system@aalmbdd_s2 as sysdba

declare
  v_count number;
  v_username varchar2(20) := 'EDITORIAL_BDD';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count >0 then
    execute immediate 'drop user '||v_username|| 'cascade';
  end if;
end;
/
Prompt creando al usuario editorial_bdd
create user editorial_bdd identified by editorial_bdd quota unlimited on users;
grant create procedure, create session, create table, create sequence to editorial_bdd;

Prompt comprobando creación del user
connect editorial_bdd/editorial_bdd@aalmbdd_s2

prompt Listo
exit
