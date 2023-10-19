-- @Autor:  Ariadna Lázaro
-- @Fecha:  15/10/2023
-- @Descripcion:Invocar a ambos s-02 para crear los objetos

prompt Conectándose como user editorial_bdd en s1
connect editorial_bdd/editorial_bdd@aalmbdd_s1

start s-02-aalm-aalmbdd_s1-ddl.sql

prompt Conectándose como user editorial_bdd en s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2

start s-02-aalm-aalmbdd_s2-ddl.sql

prompt listo
