-- @Autor:  Ariadna Lázaro
-- @Fecha:  16/10/2023
-- @Descripcion:

Prompt Conectando a S1 - aalmdd_s1
connect editorial_bdd/editorial_bdd@aalmbdd_s1

set linesize window

select
  (select count(*) from f_aalm_pais_1) as pais_1,
  (select count(*) from f_aalm_suscriptor_1) as suscriptor_1,
  (select count(*) from f_aalm_suscriptor_2) as suscriptor_2,
  (select count(*) from f_aalm_suscriptor_3) as suscriptor_3,
  (select count(*) from f_aalm_articulo_2) as articulo_2,
  (select count(*) from f_aalm_revista_1) as revista_1,
  (select count(*) from f_aalm_articulo_revista_1) as articulo_revista_1,
  (select count(*) from f_aalm_pago_suscriptor_1) as pago_1
from dual;


Prompt Conectando a S2 - aalmdd_s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2

set linesize window

select
  (select count(*) from f_aalm_pais_2) as pais_2,
  (select count(*) from f_aalm_suscriptor_4) as suscriptor_4,
  (select count(*) from f_aalm_articulo_1) as articulo_1,
  (select count(*) from f_aalm_revista_2) as revista_3,
  (select count(*) from f_aalm_articulo_revista_2) as articulo_revista_2,
  (select count(*) from f_aalm_pago_suscriptor_2) as pago_2
from dual;

Prompt listo
