-- @Autor:  Ariadna Lázaro
-- @Fecha:  12/11/2023
-- @Descripcion:Creacion del usuario para trabajar el ejercicio

prompt Conectándose a aalmbdd_s1 como usuario SYS
connect sys/system@aalmbdd_s1 as sysdba

grant create database link,create procedure to editorial_bdd;

prompt Conectándose a aalmbdd_s2 como usuario SYS
connect sys/system@aalmbdd_s2 as sysdba

grant create database link,create procedure  to editorial_bdd;
