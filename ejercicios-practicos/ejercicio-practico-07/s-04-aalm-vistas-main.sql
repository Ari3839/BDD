--@Autor: Ariadna Lázaro
--@Fecha creación: 14/11/2023
--@Descripción: Script de ejecución para crear de vistas

Prompt conectandose a aalmbdd_s1
connect  editorial_bdd/editorial_bdd@aalmbdd_s1
Prompt creando vistas en aalmbdd_s1
@s-04-aalm-def-vistas.sql

Prompt conectandose a aalmbdd_s2
connect  editorial_bdd/editorial_bdd@aalmbdd_s2
Prompt creando vistas en aalmbdd_s2
@s-04-aalm-def-vistas.sql
Prompt Listo!