-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion: Trigger para suscriptor desde sitio 2

create or replace trigger t_dml_suscriptor
instead of insert or update or delete on suscriptor
declare
  v_count number;
  v_count2 number;
begin
  case
    when inserting then
      select count(*) into v_count
      from pais_2
      where pais_id =:new.pais_id;

      select count(*) into v_count2
      from pais_2
      where pais_id =:new.pais_id;
      
      if v_count > 0 then
        --Insersión local (AP [M-Z])
        if substr(:new.ap_paterno,1,1) between 'M' and 'Z' then
          insert into suscriptor_4(suscriptor_id,nombre,ap_paterno,
            ap_materno,fecha_inscripcion,pais_id)
          values(:new.suscriptor_id,:new.nombre,:new.ap_paterno,
            :new.ap_materno,:new.fecha_inscripcion,:new.pais_id);
          --Insersión en fragmento vertical (remota)
          insert into suscriptor_1(suscriptor_id,num_tarjeta)
            values(:new.suscriptor_id,:new.num_tarjeta);

        elsif substr(:new.ap_paterno,1,1) between 'A' and 'N' then
          --insersión remota
          insert into suscriptor_3(suscriptor_id,nombre,ap_paterno,
            ap_materno,fecha_inscripcion,pais_id)
          values(:new.suscriptor_id,:new.nombre,:new.ap_paterno,
            :new.ap_materno,:new.fecha_inscripcion,:new.pais_id);
          --Insersión en fragmento vertical
          insert into suscriptor_1(suscriptor_id,num_tarjeta)
            values(:new.suscriptor_id,:new.num_tarjeta);

        else
          raise_application_error(-20001,
          'Valor incorrecto para el campo Ap_paterno : '
          || :new.ap_paterno);
        end if;

      else
          insert into suscriptor_2(suscriptor_id,nombre,ap_paterno,
            ap_materno,fecha_inscripcion,pais_id)
          values(:new.suscriptor_id,:new.nombre,:new.ap_paterno,
            :new.ap_materno,:new.fecha_inscripcion,:new.pais_id);
          --Insersión en fragmento vertical
          insert into suscriptor_1(suscriptor_id,num_tarjeta)
            values(:new.suscriptor_id,:new.num_tarjeta);
        
      /*else
        raise_application_error(-20001,
        'Error de integridad para el campo pais_id : '
        || :new.pais_id
        || ' No se encontró el registro padre en fragmentos');*/
      end if;

    when deleting then
      select count(*) into v_count
      from pais_2
      where pais_id =:old.pais_id;

      select count(*) into v_count2
      from pais_2
      where pais_id =:old.pais_id;
        
      if v_count > 0 then
        if substr(:old.ap_paterno,1,1) between 'M' and 'Z' then
          --Borrar local 
          delete from suscriptor_4 where suscriptor_id = :old.suscriptor_id;
          delete from suscriptor_1 where suscriptor_id = :old.suscriptor_id;
        elsif substr(:old.ap_paterno,1,1) between 'A' and 'N' then
          --Borrar remoto
          delete from suscriptor_3 where suscriptor_id = :old.suscriptor_id;
          delete from suscriptor_1 where suscriptor_id = :old.suscriptor_id;
        else
          raise_application_error(-20001,
          'Valor incorrecto para el campo Ap_paterno : '
          || :old.ap_paterno);
        end if;

      else
          --Borrar remoto
          delete from suscriptor_2 where suscriptor_id = :old.suscriptor_id;
          --Borrar vertical pura
          delete from suscriptor_1 where suscriptor_id = :old.suscriptor_id;
        
      /*else
        raise_application_error(-20001,
        'Error de integridad para el campo pais_id : '
        || :old.pais_id
        || ' No se encontró el registro padre en fragmentos');*/
      end if;

    when updating then
      raise_application_error(-20002,
      'Aún no se soporta dicha operación');

    end case;
end;
/