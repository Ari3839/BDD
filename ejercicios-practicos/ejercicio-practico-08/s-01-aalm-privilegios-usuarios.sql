-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion: asignando privilegios para triggers

Prompt Conectando como sys a s1
connect sys/system@aalmbdd_s1 as sysdba
grant create trigger to editorial_bdd;

Prompt Conectando como sys a s2
connect sys/system@aalmbdd_s2 as sysdba
grant create trigger to editorial_bdd;