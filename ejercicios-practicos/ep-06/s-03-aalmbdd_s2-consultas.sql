-- @Autor:  Ariadna Lázaro
-- @Fecha:  12/11/2023
-- @Descripcion:Consultas en cada PDB

prompt conectando a aalmbdd_s2
connect editorial_bdd/editorial_bdd@aalmbdd_s2
prompt Contando registros

--Habilita envio de mensajes a consola
set serveroutput on

declare 
  v_num_paises number;
  v_num_articulo number;
  v_num_articulo_revista number;
  v_num_revista number;
  v_num_pago number;
  v_num_suscriptor number;
begin
  dbms_output.put_line('Realizando consulta empleadon ligas');
  
  select count(*) as into v_num_paises
  from (
    select pais_id
    from f_aalm_pais_1@aalmbdd_s1.fi.unam
    union all
    select pais_id
    from f_aalm_pais_2
  ) q1;

  select count(*) as into v_num_articulo
  from (
    select articulo_id
    from f_aalm_articulo_2@aalmbdd_s1.fi.unam
  ) q2 join f_aalm_articulo_1 a1
  on a1.articulo_id=q2.articulo_id;

  select count(*) as into v_num_articulo_revista
  from (
    select articulo_revista_id
    from f_aalm_articulo_revista_1@aalmbdd_s1.fi.unam
    union all
    select articulo_revista_id
    from f_aalm_articulo_revista_2
  ) q3;

  select count(*) as into v_num_revista
  from (
    select revista_id
    from f_aalm_revista_1@aalmbdd_s1.fi.unam
    union all
    select revista_id
    from f_aalm_revista_2
  ) q4;

  select count(*) as into v_num_pago
  from (
    select suscriptor_id
    from f_aalm_pago_suscriptor_1@aalmbdd_s1.fi.unam
    union all
    select suscriptor_id
    from f_aalm_pago_suscriptor_2
  ) q5;

  select count(*) as into v_num_suscriptor
  from (
    select suscriptor_id
    from f_aalm_suscriptor_2@aalmbdd_s1.fi.unam 
    union all
    select suscriptor_id
    from f_aalm_suscriptor_3@aalmbdd_s1.fi.unam 
	  union all
    select suscriptor_id
    from f_aalm_suscriptor_4
  ) q5 join f_aalm_suscriptor_1@aalmbdd_s1.fi.unam s1
  on s1.suscriptor_id=q5.suscriptor_id;


  dbms_output.put_line('Resultado del conteo de registros');
  dbms_output.put_line('Paises:               '||v_num_paises);
  dbms_output.put_line('Revistas:             '||v_num_revista);
  dbms_output.put_line('Articulos:            '||v_num_articulo);
  dbms_output.put_line('Articulos-revistas:   '||v_num_articulo_revista);
  dbms_output.put_line('Pagos:                '||v_num_pago);
  dbms_output.put_line('Suscriptores:         '||v_num_suscriptor);


end;
/
prompt listo!
--exit