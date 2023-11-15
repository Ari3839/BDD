--@Autor: Ariadna Lázaro
--@Fecha creación: 14/11/2023
--@Descripción: Creación de vistas

create or replace view pais as
  select q1.pais_id,q1.clave,q1.nombre,q1.region_economica
    from (
      select pais_id,clave,nombre,region_economica
      from pais_1
      union all
      select pais_id,clave,nombre,region_economica
      from pais_2
    ) q1;

/*create or replace view articulo as
  select 
  from (
    select pais_id
    from articulo_1 a1
    join articulo_2 a2
    on a1.articulo_id=a2.articulo_id;
  ) q2;
*/

create or replace view articulo_revista as
  select q3.articulo_revista_id,q3.fecha_aprobacion,
    q3.calificacion,q3.articulo_id,q3.revista_id
  from (
    select articulo_revista_id,fecha_aprobacion,
    calificacion,articulo_id,revista_id
    from articulo_revista_1
    union all
    select articulo_revista_id,fecha_aprobacion,
    calificacion,articulo_id,revista_id
    from articulo_revista_2
  ) q3;

  /*select count(*) into v_num_pagos
  from (
    select num_pagos
    from pago_1
    union all
    select num_pagos
    from pago_2
  ) q4;*/
  
create or replace view revista as
  select q5.revista_id,q5.folio,q5.titulo,
    q5.fecha_publicacion,q5.revista_adicional_id
  from (
    select revista_id,folio,titulo,
    fecha_publicacion,revista_adicional_id
    from revista_1
    union all
    select revista_id,folio,titulo,
    fecha_publicacion,revista_adicional_id
    from revista_2
  ) q5;

create or replace view suscriptor as
  select q6.suscriptor_id,q6.nombre,q6.ap_paterno,q6.ap_materno,
  q6.fecha_inscripcion,s1.num_tarjeta,q6.pais_id
  from (
    select suscriptor_id,nombre,ap_paterno,
    ap_materno,fecha_inscripcion,pais_id
    from suscriptor_2
    union all
    select suscriptor_id,nombre,ap_paterno,
    ap_materno,fecha_inscripcion,pais_id
    from suscriptor_3
    union all
    select suscriptor_id,nombre,ap_paterno,
    ap_materno,fecha_inscripcion,pais_id
    from suscriptor_4
  ) q6 join suscriptor_1 s1
  on s1.suscriptor_id=q6.suscriptor_id;