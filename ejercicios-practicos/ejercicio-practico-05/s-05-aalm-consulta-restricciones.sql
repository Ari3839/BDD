-- @Autor:  Ariadna Lázaro
-- @Fecha:  15/10/2023
-- @Descripcion:Consulta de restricciones de referencia

--hija,constraint,padre,tipo

Prompt mostrando lista de restricciones de referencia
col tabla_padre format A30
col tabla_hija format A30
col nombre_restriccion format A41
set linesize 200
select th.table_name as tabla_hija, th.constraint_name as nombre_restriccion,
  tp.table_name as tabla_padre, th.constraint_type as tipo_constraint
from user_constraints th, user_constraints tp
where th.constraint_type='R'
  and th.r_constraint_name=tp.constraint_name
order by tabla_padre;
