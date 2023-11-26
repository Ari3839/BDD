-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion: creando tablas temp para blobs

Prompt Conectando a s1
connect editorial_bdd/editorial_bdd@aalmbdd_s1

create global temporary table t_articulo_insert(
  articulo_id number(10,0) constraint t_articulo_insert_pk primary key,
  pdf blob not null
) on commit preserve rows;

create global temporary table t_pago_suscriptor_insert(
  num_pago number(10,0),
  suscriptor_id number(10,0),
  fecha_pago date not null,
  importe number(8,2) not null,
  recibo_pago blob not null,
  constraint t_pago_suscriptor_insert_pk primary key(num_pago,suscriptor_id) 
) on commit preserve rows;


Prompt Conectando a s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2

create global temporary table t_pago_suscriptor_insert(
  num_pago number(10,0),
  suscriptor_id number(10,0),
  fecha_pago date not null,
  importe number(8,2) not null,
  recibo_pago blob not null,
  constraint t_pago_suscriptor_insert_pk primary key(num_pago,suscriptor_id) 
) on commit preserve rows;