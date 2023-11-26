-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion:Comprobando triggers

whenever sqlerror exit rollback

Prompt =================================
Prompt creando triggers en S1
connect editorial_bdd/editorial_bdd@aalmbdd_s1

Prompt creando trigger para pais
@s-03-aalm-pais-trigger.sql
show errors

Prompt creando trigger para suscriptor
@s-03-aalm-suscriptor-n1-trigger.sql
show errors

Prompt creando trigger para pago_suscriptor
@s-03-aalm-pago-suscriptor-n1-trigger.sql
show errors

Prompt creando trigger para articulo
@s-03-aalm-articulo-n1-trigger.sql
show errors

Prompt =================================
Prompt creando triggers en S2
connect editorial_bdd/editorial_bdd@aalmbdd_s2

Prompt creando trigger para pais
@s-03-aalm-pais-trigger.sql
show errors
Prompt creando trigger para suscriptor
@s-03-aalm-suscriptor-n2-trigger.sql
show errors
Prompt creando trigger para pago_suscriptor
@s-03-aalm-pago-suscriptor-n2-trigger.sql
show errors
Prompt creando trigger para articulo
@s-03-aalm-articulo-n2-trigger.sql
show errors

Prompt Listo!
exit