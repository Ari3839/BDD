-- @Autor:  Ariadna Lázaro
-- @Fecha:  16/10/2023
-- @Descripcion:carga inicial de datos

Prompt Conectando a S1 - aalmdd_s1
connect editorial_bdd/editorial_bdd@aalmbdd_s1
--si ocurre un error, la ejecución se detiene.
whenever sqlerror exit rollback;

Prompt limpiando.
delete from f_aalm_pago_suscriptor_1;
delete from f_aalm_suscriptor_2;
delete from f_aalm_articulo_revista_1;
delete from f_aalm_suscriptor_3;
delete from f_aalm_articulo_2;
delete from f_aalm_revista_1;
delete from f_aalm_pais_1;
delete from f_aalm_suscriptor_1;

Prompt Cargando datos
insert into f_aalm_articulo_2(articulo_id,titulo,resumen,texto) 
	values(1,'LOS SIMIOS','Estudio y orifen de los sismos.','Texto de ejemplo para el articulo');

insert into f_aalm_articulo_2(articulo_id,titulo,resumen,texto) 
	values(2,'FAUNA MARINA','Estudio de la fauna marina de México.','Texto de ejemplo para el artículo');

insert into f_aalm_revista_1(revista_id,folio,titulo,fecha_publicacion,revista_adicional_id) 
	values(1,'90001','Premier',to_date('01/03/2017','dd/mm/yyyy'),null);

insert into f_aalm_articulo_revista_1(articulo_revista_id,fecha_aprobacion,calificacion,
revista_id,articulo_id) values(1,to_date('01/02/2017','dd/mm/yyyy'),9,1,1);

insert into f_aalm_pais_1(pais_id,clave,nombre,region_economica) 
	values(1,'MX','MEXICO','A');

insert into f_aalm_suscriptor_1(suscriptor_id,num_tarjeta)
	values(1,'5420900754028724');

insert into f_aalm_suscriptor_1(suscriptor_id,num_tarjeta)
	values(2,'5800807976301529');

insert into f_aalm_suscriptor_1(suscriptor_id,num_tarjeta)
	values(3,'6202870129036021');

insert into f_aalm_suscriptor_2(suscriptor_id,nombre,ap_paterno,ap_materno,fecha_inscripcion,pais_id)
	values(1,'OMAR','LOPEZ','MENDEZ',to_date('01/01/2017','dd/mm/yyyy'),1);

insert into f_aalm_suscriptor_3(suscriptor_id,nombre,ap_paterno,ap_materno,fecha_inscripcion,pais_id)
	values(2,'LALO','KIM','LUNA',to_date('01/01/2016','dd/mm/yyyy'),2);


insert into f_aalm_pago_suscriptor_1(num_pago,suscriptor_id,fecha_pago,importe,recibo_pago) 
	values(1,1,to_date('01/02/2017','dd/mm/yyyy'),989.67,empty_blob());

commit;


Prompt Conectando a S2 - aalmbdd_s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2
--si ocurre un error, la ejecución se detiene.
whenever sqlerror exit rollback;

Prompt limpiando.
delete from f_aalm_suscriptor_4;
delete from f_aalm_articulo_revista_2;
delete from f_aalm_revista_2;
delete from f_aalm_articulo_1;
delete from f_aalm_pais_2;
delete from f_aalm_pago_suscriptor_2;

Prompt Cargando datos
insert into f_aalm_articulo_1(articulo_id,pdf) values(1,empty_blob());
insert into f_aalm_articulo_1(articulo_id,pdf) values(2,empty_blob());

insert into f_aalm_revista_2(revista_id,folio,titulo,fecha_publicacion,revista_adicional_id) 
	values(2,'90002','TI en la UNAM',to_date('01/09/2017','dd/mm/yyyy'),1);

insert into f_aalm_articulo_revista_2(articulo_revista_id,fecha_aprobacion,calificacion,
revista_id,articulo_id) values(2,to_date('01/08/2017','dd/mm/yyyy'),10,2,2);


insert into f_aalm_pais_2(pais_id,clave,nombre,region_economica) 
	values(2,'JAP','JAPON','B');


insert into f_aalm_pago_suscriptor_2(num_pago,suscriptor_id,fecha_pago,importe,recibo_pago) 
	values(70,2,to_date('01/08/2017','dd/mm/yyyy'),1000.55,empty_blob());

insert into f_aalm_suscriptor_4(suscriptor_id,nombre,ap_paterno,ap_materno,fecha_inscripcion,pais_id)
	values(3,'LUCY','ZAMORA','PEREZ',to_date('01/01/2015','dd/mm/yyyy'),2);

commit;
Prompt Listo!
exit
