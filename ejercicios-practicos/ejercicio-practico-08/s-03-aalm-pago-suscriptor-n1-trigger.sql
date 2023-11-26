-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion: Trigger para pago desde sitio 1

create or replace trigger t_dml_pago_suscriptor
instead of insert or update or delete on pago_suscriptor
declare
begin
  case
    when inserting then
      if :new.num_pago <= 60 then
      	--insersión local, no se necesita la tabla temp
        insert into pago_suscriptor_1(num_pago,suscriptor_id,
          fecha_pago,importe,recibo_pago)
        values(:new.num_pago,:new.suscriptor_id,:new.fecha_pago,
          :new.importe,:new.recibo_pago);
      elsif :new.num_pago > 60 then
        --insersión remota, binario a t_pago_suscriptor_insert
        insert into t_pago_suscriptor_insert(num_pago,suscriptor_id,
          fecha_pago,importe,recibo_pago)
        values(:new.num_pago,:new.suscriptor_id,:new.fecha_pago,
          :new.importe,:new.recibo_pago);
        --inserta en el sitio remoto a través de la tabla temporal
        insert into pago_suscriptor_2
          select * from t_pago_suscriptor_insert
            where num_pago = :new.num_pago
            and suscriptor_id = :new.suscriptor_id;
        delete from t_pago_suscriptor_insert;
      else
        raise_application_error(-20001,
        'Valor incorrecto para el campo num_pago : '
        || :new.num_pago);
      end if;

    when deleting then
      if :old.num_pago <= 60 then
        delete from pago_suscriptor_1 
          where num_pago = :old.num_pago
          and suscriptor_id = :old.suscriptor_id;
      elsif :old.num_pago > 60 then
        delete from pago_suscriptor_2 
          where num_pago = :old.num_pago
          and suscriptor_id = :old.suscriptor_id;
      else
        raise_application_error(-20001,
        'Valor incorrecto para el campo num_pago '
        || :old.num_pago
        || ' o suscriptor_id: '
        || :old.suscriptor_id);
      end if;

    when updating then
      raise_application_error(-20002,
      'Aún no se soporta dicha operación');

    end case;
end;
/

