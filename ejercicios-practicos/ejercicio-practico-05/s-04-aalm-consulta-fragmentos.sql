-- @Autor:  Ariadna Lázaro
-- @Fecha:  15/10/2023
-- @Descripcion:Consulta de fragmentos en aalmbdd

Prompt Conectando a S1 - aalmbdd_s1
connect editorial_bdd/editorial_bdd@aalmbdd_s1
Prompt mostrando lista de fragmentos
col table_name format a30
select table_name from user_tables order by table_name;

Prompt Conectando a S2 - aalmbdd_s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2
Prompt mostrando lista de fragmentos
select table_name from user_tables order by table_name;

Prompt Listo!
exit
