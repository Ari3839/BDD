--@Autor: Ariadna Lázaro
--@Fecha creación: 15/11/2023
--@Descripción: Consultas de num de registros

Prompt Conectando a S1 - aalmdd_s1
connect editorial_bdd/editorial_bdd@aalmbdd_s1

set linesize window

select
  (select count(*) from pais) as pais,
  (select count(*) from suscriptor) as suscriptor,
  (select count(*) from articulo) as articulo,
  (select count(*) from revista) as revista,
  (select count(*) from articulo_revista) as articulo_revista,
  (select count(*) from pago_suscriptor) as pago_suscriptor
  from dual;


Prompt Conectando a S2 - aalmdd_s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2

set linesize window

select
  (select count(*) from pais) as pais,
  (select count(*) from suscriptor) as suscriptor,
  (select count(*) from articulo) as articulo,
  (select count(*) from revista) as revista,
  (select count(*) from articulo_revista) as articulo_revista,
  (select count(*) from pago_suscriptor) as pago_suscriptor
from dual;

Prompt listo
