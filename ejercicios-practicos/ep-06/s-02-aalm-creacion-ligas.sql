-- @Autor:  Ariadna Lázaro
-- @Fecha:  12/11/2023
-- @Descripcion:Creacion de ligas entre PDBs

prompt Conectándose a aalmbdd_s1 como usuario editorial_bdd
connect editorial_bdd/editorial_bdd@aalmbdd_s1

create database link aalmbdd_s2.fi.unam using 'AALMBDD_S2';

prompt Conectándose a aalmbdd_s2 como usuario editorial_bdd
connect editorial_bdd/editorial_bdd@aalmbdd_s2

create database link aalmbdd_s1.fi.unam using 'AALMBDD_S1';
