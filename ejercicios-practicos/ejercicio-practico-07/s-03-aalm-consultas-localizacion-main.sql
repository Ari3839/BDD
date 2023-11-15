-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion: Consultas main

prompt conectando a s1
connect editorial_bdd/editorial_bdd@aalmbdd_s1
prompt Realizando conteo de registros
set serveroutput on
start s-03-aalm-consultas-localizacion.sql

prompt conectando a s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2
prompt Realizando conteo de registros
set serveroutput on
start s-03-aalm-consultas-localizacion.sql
