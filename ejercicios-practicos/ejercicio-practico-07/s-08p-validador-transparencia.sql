--@Autor:           Jorge Rodriguez
--@Fecha creación:  dd/mm/yyyy
--@Descripción:     Practica 7 - Validador

--parametros recibidos
define p_sys_pwd='&1'
define p_pdb='&2'
define p_usr='&3'
define p_pwd='&4'
define p_tipo_fr='&5'
define p_num_sitio ='&6'

Prompt Iniciando validacion para &&p_pdb. 

--crea archivos binarios de prueba.
!rm -rf /tmp/bdd/p7
!mkdir -p /tmp/bdd/p7
--crea un archivo binario de 1 MB
!dd if=/dev/urandom of=/tmp/bdd/p7/p7-sample-1.bin bs=1 count=0 seek=1M
--crea un archivo binario de 2 MB
!dd if=/dev/urandom of=/tmp/bdd/p7/p7-sample-2.bin bs=1 count=0 seek=2M
--crea un archivo binario de 3 MB
!dd if=/dev/urandom of=/tmp/bdd/p7/p7-sample-3.bin bs=1 count=0 seek=3M
--crea un archivo binario de 4 MB
!dd if=/dev/urandom of=/tmp/bdd/p7/p7-sample-4.bin bs=1 count=0 seek=4M
--crea un archivo binario de 5 MB
!dd if=/dev/urandom of=/tmp/bdd/p7/p7-sample-5.bin bs=1 count=0 seek=5M


--creando objecto directory y otorgando permisos
connect sys/&&p_sys_pwd@&&p_pdb as sysdba

create or replace directory bdd_p7_dir as '/tmp/bdd/p7';
grant read,write on directory bdd_p7_dir to &&p_usr; 

Prompt Iniciando creacion de procedimientos para &&p_pdb
connect &&p_usr/&&p_pwd@&&p_pdb


@s-00-funciones-validacion.plb
@s-00-load-blob-from-file.sql

create or replace procedure spv_valida_sinonimos(p_tipo_fr varchar2, 
  p_num_sitio number) is
  
  v_num_sinonimos number(2,0);
  v_num_sinonimos_esperados number(2,0);
  --Los sinónimos CUENTA Y MOVIMIENTO apuntan a la estrategia 2
  --El sinónimo CUENTA solo existe en el sitio 1
  cursor cur_sinonimos is
    select object_name,status
    from user_objects
    where object_type='SYNONYM'
    and object_name in (
      'PAIS_1','PAIS_2',
      'BANCO_1','BANCO_2',
      'SUCURSAL_1','SUCURSAL_2',
      'EMPLEADO_1','EMPLEADO_2',
      'CUENTA','CUENTA_1','CUENTA_2','CUENTA_3','CUENTA_4',
      'MOVIMIENTO','MOVIMIENTO_1','MOVIMIENTO_2','MOVIMIENTO_3'
    );

begin
  v_num_sinonimos := 0;
  for r in cur_sinonimos loop
    v_num_sinonimos := v_num_sinonimos + 1;

    spv_assert(r.status='VALID','VALID',r.status,'status del sinonimo: '
        ||r.object_name
        ||' invalido: '
        ||r.status);
    
    spv_print_ok('sinonimo ' ||r.object_name);
  
  end loop;

  if  p_num_sitio = 1 then
    v_num_sinonimos_esperados := 17;
  elsif p_num_sitio = 2 then
    v_num_sinonimos_esperados := 16;
  else
    spv_throw_error(
      'Valor invalido para numero de sitio: '
      ||p_num_sitio
    );
  end if;

  spv_assert(v_num_sinonimos = v_num_sinonimos_esperados,
    v_num_sinonimos_esperados,v_num_sinonimos,
    'Numero invalido de sinonimos para el sitio '
    ||p_num_sitio
  ); 
  spv_print_ok( v_num_sinonimos_esperados 
    ||' sinónimos obtenidos');
 
end;
/
show errors

create or replace procedure spv_valida_vistas (p_tipo_fr varchar2, 
  p_num_sitio number) is
  cursor cur_vistas is
    select object_name, status
    from user_objects where object_type ='VIEW'
    and object_name in(
      'PAIS',
      'BANCO',
      'SUCURSAL',
      'EMPLEADO',
      'CUENTA_E1','CUENTA_E2','CUENTA',
      'MOVIMIENTO_E1','MOVIMIENTO_E2'
    );
  v_num_vista number(2,0);
  v_num_vistas_esperadas number(2,0);
begin
  
  v_num_vista := 0;
  for r in cur_vistas loop
    v_num_vista := v_num_vista + 1;

    spv_assert(r.status='VALID','VALID',r.status,
      'status de la vista: '
        ||r.object_name
        ||' invalido: '
        ||r.status);

    spv_print_ok('vista '||r.object_name);
  
  end loop;

  if p_num_sitio = 1 then
    v_num_vistas_esperadas := 8;
  else
    v_num_vistas_esperadas := 7;
  end if;

  spv_assert(v_num_vista = v_num_vistas_esperadas,
    v_num_vistas_esperadas,v_num_vista,'Número inválido de vistas');
  spv_print_ok(v_num_vistas_esperadas||' vistas encontradas');

end;
/
show errors

--crea tablas temporales para poder insertar blobs en cualquier fragmento
create or replace procedure spv_crea_tablas_temporales is 
begin 

  begin
    execute immediate 'drop table test_cuenta';
  exception
    when others then
      null;
  end;    

  execute immediate 'create global temporary table test_cuenta(
    cuenta_id number(10,0),
    contrato blob 
  )';

  begin
    execute immediate 'drop table test_movimiento';
  exception
    when others then
      null;
  end;
  execute immediate 'create global temporary table test_movimiento(
    num_movimiento number(10,0),
    cuenta_id number(10,0),
    comprobante blob,
    fecha_movimiento date,
    tipo_movimiento  char,
    importe number(18,2),
    descripcion varchar2(2000)
  )';
end;
/
show errors

exec spv_crea_tablas_temporales


/**
 * El procedimiento es invocado para ejecutarse en los 2 nodos.
 * Para un caso los blobs se leeran de forma remota y en el otro 
 * caso de forma local. Esto depende de la definición de la vista.
 */
create or replace procedure spv_prepara_datos(p_tipo_fr varchar2) is
  v_blob blob;
begin
  --elimina datos
  
  delete from movimiento_1;
  delete from movimiento_2;
  delete from movimiento_3;

  delete from cuenta_1;
  delete from cuenta_2;
  delete from cuenta_3;
  delete from cuenta_4;

  delete from sucursal_1;
  delete from sucursal_2;

  delete from empleado_1;
  delete from empleado_2;

  delete from banco_1;
  delete from banco_2;

  delete from pais_1;
  delete from pais_2;
  
  --Genera registros de prueba
  
  --pais
  insert into pais_1(pais_id,clave,nombre,zona_economica) 
  values (1,'MX','MEXICO','A');
  insert into pais_2(pais_id,clave,nombre,zona_economica) 
  values (2,'JAP','JAPON','B');

  --banco
  insert into banco_1(banco_id,clave,nombre) values(1,'BB003','BANCO BB003');
  insert into banco_2(banco_id,clave,nombre) values(2,'SS032','BANCO SS032');

  --empleado
  insert into  empleado_1(empleado_id,nombre,ap_paterno,ap_materno,
    folio_certificacion,jefe_id) 
  values (1,'JUAN','LOPEZ','LARA',null,null);

  insert into empleado_2(empleado_id,nombre,ap_paterno,ap_materno,
    folio_certificacion,jefe_id) 
  values (2,'CARLOS','BAEZ','AGUIRRE','900200',1);

  --sucursal
  if p_tipo_fr = 'P' then 
    insert into sucursal_1(sucursal_id,num_sucursal,banco_id,pais_id,gerente_id)
      values(1,100,1,1,1);
    insert into sucursal_1(sucursal_id,num_sucursal,banco_id,pais_id,gerente_id)
      values(3,300,2,1,1);
    insert into sucursal_2(sucursal_id,num_sucursal,banco_id,pais_id,gerente_id)
      values(2,200,1,2,2);
    insert into sucursal_2(sucursal_id,num_sucursal,banco_id,pais_id,gerente_id)
      values(4,400,2,2,2);

  elsif p_tipo_fr = 'B' then
    insert into sucursal_1(sucursal_id,num_sucursal,banco_id,pais_id,gerente_id)
    values(1,100,1,1,1);
    insert into sucursal_1(sucursal_id,num_sucursal,banco_id,pais_id,gerente_id)
    values(2,200,1,2,2);
    insert into sucursal_2(sucursal_id,num_sucursal,banco_id,pais_id,gerente_id)
    values(3,300,2,1,1);
    insert into sucursal_2(sucursal_id,num_sucursal,banco_id,pais_id,gerente_id)
    values(4,400,2,2,2);

  else
    spv_throw_error('Selección de fragmentación invalido (P|B): '||p_tipo_fr);
  end if; 

  --cuenta
  insert into cuenta_1(cuenta_id,nip,saldo) values(1,1234,45894.23);
  insert into cuenta_1(cuenta_id,nip,saldo) values(2,4321,100500.56);

  --inserta en temporal
  insert into test_cuenta(cuenta_id,contrato)
  values(1,load_blob_from_file('BDD_P7_DIR','p7-sample-1.bin'));

  insert into cuenta_2(cuenta_id,contrato)
    select cuenta_id,contrato
    from test_cuenta where cuenta_id =1;

   --inserta en temporal
  insert into test_cuenta(cuenta_id,contrato)
  values(2,load_blob_from_file('BDD_P7_DIR','p7-sample-2.bin'));

  insert into cuenta_2(cuenta_id,contrato)
    select cuenta_id,contrato
    from test_cuenta where cuenta_id =2;
  
  if p_tipo_fr = 'P' then

    insert into cuenta_3(cuenta_id,num_cuenta,tipo_cuenta,sucursal_id)
    values(1,'800600400','D',1);
    insert into cuenta_4(cuenta_id,num_cuenta,tipo_cuenta,sucursal_id)
    values(2,'900700500','V',2);

  elsif p_tipo_fr ='B' then
    insert into cuenta_3(cuenta_id,num_cuenta,tipo_cuenta,sucursal_id)
    values(1,'800600400','D',1);
    insert into cuenta_4(cuenta_id,num_cuenta,tipo_cuenta,sucursal_id)
    values(2,'900700500','V',4);
  else
    spv_throw_error('Selección de fragmentación invalido (P|B): '||p_tipo_fr);
  end if;   

  --movimiento

  --movimiento_1 
  --inserta en temporal
  insert into test_movimiento (num_movimiento,cuenta_id,fecha_movimiento,
    tipo_movimiento,importe,descripcion,comprobante)
  values(1,1,to_date('01-01-1980 14:55:31','dd-mm-yyyy hh24:mi:ss'),'D',
    85745.56,'PAGO AGUINALDO',
    load_blob_from_file('BDD_P7_DIR','p7-sample-4.bin'));
 
  insert into movimiento_1(num_movimiento,cuenta_id,fecha_movimiento,
    tipo_movimiento,importe,descripcion,comprobante)
  select num_movimiento,cuenta_id,fecha_movimiento,
    tipo_movimiento,importe,descripcion,comprobante
  from test_movimiento
  where num_movimiento = 1 and cuenta_id = 1;

  --movimiento_2
  -- inserta en tabla temporal
  insert into test_movimiento(num_movimiento,cuenta_id,fecha_movimiento,
    tipo_movimiento,importe,descripcion,comprobante)
  values(2,1,to_date('01-01-2015 12:00:15','dd-mm-yyyy hh24:mi:ss'),
    'D',500596.25,'PAGO BONO PRODUCTIVIDAD',
    load_blob_from_file('BDD_P7_DIR','p7-sample-3.bin'));

  --transmite a la tabla (no importa que sea local o remota)
  insert into movimiento_2(num_movimiento,cuenta_id,fecha_movimiento,
    tipo_movimiento,importe,descripcion,comprobante)
    select num_movimiento,cuenta_id,fecha_movimiento,
      tipo_movimiento,importe,descripcion,comprobante
    from test_movimiento
    where num_movimiento = 2 and cuenta_id = 1;

  --movimiento 3
  --inserta en temporal
  insert into test_movimiento (num_movimiento,cuenta_id,fecha_movimiento,
    tipo_movimiento,importe,descripcion,comprobante)
  values(3,2,to_date('01-01-2016 19:05:04','dd-mm-yyyy hh24:mi:ss'),'R',
    40200.32,'RETIRO LETRA AUTO',
    load_blob_from_file('BDD_P7_DIR','p7-sample-5.bin'));

  insert into movimiento_3(num_movimiento,cuenta_id,fecha_movimiento,
    tipo_movimiento,importe,descripcion,comprobante)
  select num_movimiento,cuenta_id,fecha_movimiento,
    tipo_movimiento,importe,descripcion,comprobante
  from test_movimiento
  where num_movimiento = 3 and cuenta_id = 2;

  --Haciendo commit para asegurar visibilidad de datos blob.
  commit;
exception
  when others then
    rollback;
    raise;
end;
/
show errors 


create or replace procedure spv_consulta_datos(p_num_sitio number) is
  v_num_pais number;
  v_num_banco number;
  v_num_sucursal number;
  v_num_cuenta number;
  v_num_movimiento number;
  v_num_empleado number;
  
  --variables para contabilizar la longitud del campo comprobante

  -- uso del sinómino
  v_comprobante_length_syn number;
  --uso de la estrategia 1
  v_comprobante_length_e1 number;
  --uso de la estrategia 2
  v_comprobante_length_e2 number;  
  --total empleando las 3 técnicas
  v_comprobante_length_total number;

  --variables para contabilizar la longitud del campo contrato

  --Uso del sinónimo
  v_contrato_length_syn number;
  --Uso de la estrategia 1
  v_contrato_length_e1 number;
  --Uso de la estrategia 2
  v_contrato_length_e2 number;
  --total empleando las 3 técnicas
  v_contrato_length_total number;

begin
  
  select count(*) into v_num_pais from pais;
  select count(*) into v_num_sucursal from sucursal;
  select count(*) into v_num_empleado from empleado;
  select count(*) into v_num_cuenta from cuenta;
  select count(*) into v_num_movimiento from movimiento;
  select count(*) into v_num_banco from banco;
  
  -- validacion de blobs con estrategias e1 y e2 para cuenta

  --uso del sinonimo/vista para cuenta
  select sum(dbms_lob.getlength(contrato)) into v_contrato_length_syn
  from cuenta;
  
  --Se usa sql dinámico ya que esos objetos solo viven en el sitio 1
  if p_num_sitio = 1 then
    --uso de vista estrategia 1
    execute immediate '
    select sum(dbms_lob.getlength(contrato)) into :ph1
    from cuenta_e1' into v_contrato_length_e1;

    --uso de vista estrategia 2
    execute immediate '
    select sum(dbms_lob.getlength(contrato)) into :ph2
    from cuenta_e2' into v_contrato_length_e2;

  else
    --iguala las variables para evitar que sean cero
    v_contrato_length_e1 := v_contrato_length_syn;
    v_contrato_length_e2 := v_contrato_length_syn;
  
  end if;

  -- validacion de blobs con estrategias e1 y e2 para movimiento

  --validacion de blobs con estrategia e1. En ambos sitios están estos objetos.
  select sum(dbms_lob.getlength(comprobante)) into v_comprobante_length_e1
  from movimiento_e1;

  --validacion de blobs con estrategia e2
  select sum(dbms_lob.getlength(comprobante)) into v_comprobante_length_e2 
  from movimiento_e2;
     
  --empleando el sinonimo o la vista
  select sum(dbms_lob.getlength(comprobante)) into v_comprobante_length_syn
  from movimiento;

  dbms_output.put_line('Registros encontrados empleando vistas');
  
  spv_print_ok(' Paises                     : '||v_num_pais);
  spv_print_ok(' Bancos                     : '||v_num_banco); 
  spv_print_ok(' Sucursal                   : '||v_num_sucursal);   
  spv_print_ok(' Cuenta                     : '||v_num_cuenta);
  spv_print_ok(' Empleado                   : '||v_num_empleado);
  spv_print_ok(' Movimiento                 : '||v_num_movimiento);

  dbms_output.put_line('Longitudes de campos BLOB');

  spv_print_ok(' Total Blob contrato       : '||v_contrato_length_syn);
  spv_print_ok(' Total Blob contrato e1    : '||v_contrato_length_e1);
  spv_print_ok(' Total Blob contrato e2    : '||v_contrato_length_e2);
  spv_print_ok(' Total Blob comprobante    : '||v_comprobante_length_syn);
  spv_print_ok(' Total Blob comprobante e1 : '||v_comprobante_length_e1);
  spv_print_ok(' Total Blob comprobante e2 : '||v_comprobante_length_e2);
  
  --valida número de registros
  if v_num_pais = 0 or 
     v_num_sucursal = 0 or 
     v_num_banco =  0 or
     v_num_empleado = 0 or
     v_num_cuenta = 0 or 
     v_num_movimiento = 0   then

    spv_throw_error('ERROR: Se obtuvo 0 registros al consultar'
      ||' las vistas. Revisar la lista anterior');

  end if;

  --valida longitudes de datos blob

  -- total = los 2 primeros archivos para el campo contrato
  v_contrato_length_total := 1024*1024*(1+2);
  -- total = los ultimos 3 archivos para el campo comprobante
  v_comprobante_length_total := 1024*1024*(3+4+5);

  spv_assert(v_contrato_length_syn = v_contrato_length_total, 
    v_contrato_length_total,v_contrato_length_syn,
    ' Longitud total de archivos binarios inválida para el campo contrato');

  spv_assert(v_contrato_length_e1 = v_contrato_length_total, 
    v_contrato_length_total,v_contrato_length_e1,
    ' Longitud total de archivos binarios inválida pra el campo contrato e1');

  spv_assert(v_contrato_length_e2 = v_contrato_length_total, 
    v_contrato_length_total,v_contrato_length_e2,
    ' Longitud total de archivos binarios inválida pra el campo contrato e2');

  spv_print_ok('Longitud total de PDFs para el campo contrato '
    ||v_contrato_length_total);

  spv_assert(v_comprobante_length_total = v_comprobante_length_syn,
    v_comprobante_length_total,v_comprobante_length_syn,
    ' Longitud total de archivos binarios inválida para el campo comprobante');

  spv_assert(v_comprobante_length_total = v_comprobante_length_e1,
    v_comprobante_length_total,v_comprobante_length_e1,
    ' Longitud total de archivos binarios inválida para el campo comprobante e1');

  spv_assert(v_comprobante_length_total = v_comprobante_length_e2,
    v_comprobante_length_total,v_comprobante_length_e2,
    ' Longitud total de archivos binarios inválida para el campo comprobante e2');

  spv_print_ok('Longitud total de PDFs para el campo comprobante '
    ||v_comprobante_length_total);

  spv_print_ok('Valiación concluida');

end;
/
show errors

exec spv_print_header
host sha256sum &&p_script_validador
exec spv_prepara_datos(trim(upper('&&p_tipo_fr')));
exec spv_valida_sinonimos(trim(upper('&&p_tipo_fr')),&&p_num_sitio);
exec spv_valida_vistas(trim(upper('&&p_tipo_fr')),&&p_num_sitio);
exec spv_consulta_datos(&&p_num_sitio);

