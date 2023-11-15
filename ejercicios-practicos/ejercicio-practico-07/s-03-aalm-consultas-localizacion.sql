-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion: Consultas con sinónimos

declare
  v_num_paises number;
  v_num_articulos number;
  v_num_suscriptores number;
  v_num_articulo_revista number;
  v_num_revistas number;
  v_num_pagos number;

begin
  dbms_output.put_line('Realizando consulta empleando sinonimos');

  --consultando paises
  select count(*) into v_num_paises
  from (
    select pais_id
    from pais_1
    union all
    select pais_id
    from pais_2
  ) q1;

  select count(*) into v_num_articulos
  from (
    select a1.articulo_id
    from articulo_1 a1
    join articulo_2 a2
    on a1.articulo_id=a2.articulo_id
  ) q2;

  select count(*) into v_num_articulo_revista
  from (
    select articulo_revista_id
    from articulo_revista_1
    union all
    select articulo_revista_id
    from articulo_revista_2
  ) q3;

  select count(*) into v_num_pagos
  from (
    select num_pago
    from pago_suscriptor_1
    union all
    select num_pago
    from pago_suscriptor_2
  ) q4;
  
  select count(*) into v_num_revistas
  from (
    select revista_id
    from revista_1
    union all
    select revista_id
    from revista_2
  ) q5;

  select count(*) into v_num_suscriptores
  from (
    select suscriptor_id
    from suscriptor_2
    union all
    select suscriptor_id
    from suscriptor_3
    union all
    select suscriptor_id
    from suscriptor_4
  ) q6 join suscriptor_1 s4
  on s4.suscriptor_id=q6.suscriptor_id;
  
  dbms_output.put_line('Resultado del conteo de registros');
  dbms_output.put_line('==================================');
  dbms_output.put_line('Paises: '||v_num_paises);
  dbms_output.put_line('Articulos '||v_num_articulos);  
  dbms_output.put_line('Revistas '||v_num_revistas);  
  dbms_output.put_line('Articulo-revista '||v_num_articulo_revista);  
  dbms_output.put_line('Pagos '||v_num_pagos);  
  dbms_output.put_line('Suscriptores '||v_num_suscriptores);  


  end;
/

