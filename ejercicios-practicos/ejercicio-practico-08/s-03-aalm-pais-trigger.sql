-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion: Trigger para pais

create or replace trigger t_dml_pais
instead of insert or update or delete on pais
declare
begin
  case
    when inserting then
      if :new.region_economica = 'A' then
        insert into pais_1(pais_id,clave,nombre,region_economica)
        values(:new.pais_id,:new.clave,:new.nombre,:new.region_economica);
      elsif :new.region_economica = 'B' then
        insert into pais_2(pais_id,clave,nombre,region_economica)
        values(:new.pais_id,:new.clave,:new.nombre,:new.region_economica);
      else
        raise_application_error(-20001,
        'Valor incorrecto para el campo region_economica : '
        || :new.region_economica
        || ' Solo se permiten los valores A , B ');
      end if;

    when deleting then
      if :old.region_economica ='A' then
        delete from pais_1 where pais_id = :old.pais_id;
      elsif :old.region_economica='B' then
        delete from pais_2 where pais_id = :old.pais_id;
      else
        raise_application_error(-20001,
        'Valor incorrecto para el campo region_economica : '
        || :old.region_economica
        || ' Solo se permiten los valores A , B ');
      end if;

    when updating then
    --el registro se queda en el sitio A
      if :new.region_economica ='A' and :old.region_economica ='A' then
        update pais_1 set pais_id = :new.pais_id,
        clave=:new.clave,nombre=:new.nombre,
        region_economica=:new.region_economica
        where pais_id = :old.pais_id;

    --el registro cambia de sitio S2->S1
      elsif :new.region_economica = 'A' and :old.region_economica ='B' then
        delete from pais_2 where pais_id = :old.pais_id;
        insert into pais_1(pais_id,clave,nombre,region_economica)
        values(:new.pais_id,:new.clave,:new.nombre,:new.region_economica);

      --el registro se queda en el sitio B
      elsif :new.region_economica ='B' and :old.region_economica = 'B' then
        update pais_2 set pais_id = :new.pais_id,
        clave=:new.clave,nombre=:new.nombre,
        region_economica=:new.region_economica
        where pais_id = :old.pais_id;
      
      --el registro cambia de sitio S1->S2
      elsif :new.region_economica='B' and :old.region_economica = 'A' then
        delete from pais_1 where pais_id = :old.pais_id;
        insert into pais_2(pais_id,clave,nombre,region_economica)
        values(:new.pais_id,:new.clave,:new.nombre,:new.region_economica);
      
      --valores invalidos
      else
        raise_application_error(-20001,
        'Valor incorrecto para el campo region_economica : '
        || :old.region_economica
        || ' Solo se permiten los valores A , B ');
      end if;
  
  end case;
end;
/