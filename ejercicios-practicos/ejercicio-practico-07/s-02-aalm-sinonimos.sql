-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion: creando sinónimos

Prompt conectandose a s1
connect editorial_bdd/editorial_bdd@aalmbdd_s1

Prompt creando sinónimos en s1
create or replace synonym articulo_1 for f_aalm_articulo_1@aalmbdd_s2;
create or replace synonym articulo_2 for f_aalm_articulo_2;
create or replace synonym articulo_revista_1 for f_aalm_articulo_revista_1;
create or replace synonym articulo_revista_2 for f_aalm_articulo_revista_2@aalmbdd_s2;
create or replace synonym pago_suscriptor_1 for f_aalm_pago_suscriptor_1;
create or replace synonym pago_suscriptor_2 for f_aalm_pago_suscriptor_2@aalmbdd_s2;
create or replace synonym pais_1 for f_aalm_pais_1; 
create or replace synonym pais_2 for f_aalm_pais_2@aalmbdd_s2;
create or replace synonym revista_1 for f_aalm_revista_1;
create or replace synonym revista_2 for f_aalm_revista_2@aalmbdd_s2;
create or replace synonym suscriptor_1 for f_aalm_suscriptor_1; 
create or replace synonym suscriptor_2 for f_aalm_suscriptor_2; 
create or replace synonym suscriptor_3 for f_aalm_suscriptor_3; 
create or replace synonym suscriptor_4 for f_aalm_suscriptor_4@aalmbdd_s2; 



Prompt conectandose a s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2
Prompt creando sinónimos en s2
create or replace synonym articulo_1 for f_aalm_articulo_1;
create or replace synonym articulo_2 for f_aalm_articulo_2@aalmbdd_s1;
create or replace synonym articulo_revista_1 for f_aalm_articulo_revista_1@aalmbdd_s1;
create or replace synonym articulo_revista_2 for f_aalm_articulo_revista_2;
create or replace synonym pago_suscriptor_1 for f_aalm_pago_suscriptor_1@aalmbdd_s1;
create or replace synonym pago_suscriptor_2 for f_aalm_pago_suscriptor_2;
create or replace synonym pais_1 for f_aalm_pais_1@aalmbdd_s1;
create or replace synonym pais_2 for f_aalm_pais_2;
create or replace synonym revista_1 for f_aalm_revista_1@aalmbdd_s1;
create or replace synonym revista_2 for f_aalm_revista_2;
create or replace synonym suscriptor_1 for f_aalm_suscriptor_1@aalmbdd_s1; 
create or replace synonym suscriptor_2 for f_aalm_suscriptor_2@aalmbdd_s1; 
create or replace synonym suscriptor_3 for f_aalm_suscriptor_3@aalmbdd_s1; 
create or replace synonym suscriptor_4 for f_aalm_suscriptor_4;


Prompt Listo!
exit
