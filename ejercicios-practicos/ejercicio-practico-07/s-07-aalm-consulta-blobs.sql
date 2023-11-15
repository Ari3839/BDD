--@Autor: Ariadna Lázaro
--@Fecha creación: 15/11/2023
--@Descripción: Validacion de tablas con datos blob

Prompt Conectando a S1 - aalmdd_s1
connect editorial_bdd/editorial_bdd@aalmbdd_s1

Prompt articulo estrategia 1
select articulo_id,dbms_lob.getlength(pdf) as longitud
from articulo_e1;

Prompt pago estrategia 1
select num_pago,dbms_lob.getlength(recibo_pago) as longitud
from pago_suscriptor_e1;

Prompt articulo estrategia 2
select articulo_id,dbms_lob.getlength(pdf) as longitud
from articulo_e2;

Prompt pago estrategia 2
select num_pago,dbms_lob.getlength(recibo_pago) as longitud
from pago_suscriptor_e2;

Prompt articulo, uso de sinonimo
select articulo_id,dbms_lob.getlength(pdf) as longitud
from articulo;

Prompt pago, uso de sinonimo
select num_pago,dbms_lob.getlength(recibo_pago) as longitud
from pago_suscriptor;

Prompt Conectando a S2 - aalmdd_s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2

Prompt pago estrategia 1
select num_pago,dbms_lob.getlength(recibo_pago) as longitud
from pago_suscriptor_e1;

Prompt pago estrategia 2
select num_pago,dbms_lob.getlength(recibo_pago) as longitud
from pago_suscriptor_e2;

Prompt pago, uso de sinonimo
select num_pago,dbms_lob.getlength(recibo_pago) as longitud
from pago_suscriptor;