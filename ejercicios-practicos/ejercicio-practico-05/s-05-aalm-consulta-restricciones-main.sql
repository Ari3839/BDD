-- @Autor:  Ariadna Lázaro
-- @Fecha:  15/10/2023
-- @Descripcion:Consulta de restricciones de referencia MAIN

Prompt Conectando a S1 - aalmbdd_s1
connect editorial_bdd/editorial_bdd@aalmbdd_s1
--ejecuta la misma consulta en ambas pdbs
@s-05-aalm-consulta-restricciones.sql
Prompt Conectando a S2 - aalmbdd_s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2
--ejecuta la misma consulta en ambas pdbs
@s-05-aalm-consulta-restricciones.sql
Prompt Listo!
exit
