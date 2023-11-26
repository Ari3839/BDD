-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion: Trigger para articulo desde sitio 1

create or replace trigger t_dml_articulo
instead of insert or update or delete on articulo
declare
begin
  case
    when inserting then
      --insersión local
      insert into articulo_2(articulo_id,titulo,resumen,texto)
        values(:new.articulo_id,:new.titulo,:new.resumen,:new.texto);
      --inserta el blob en temp
      insert into t_articulo_insert(articulo_id,pdf)
        values(:new.articulo_id,:new.pdf);
      --Insersión remota con temp
      insert into articulo_1
        select * from t_articulo_insert
        where articulo_id = :new.articulo_id;
      delete from t_articulo_insert
        where articulo_id = :new.articulo_id;

    when deleting then
      delete from articulo_1
        where articulo_id = :old.articulo_id;
      delete from articulo_2
        where articulo_id = :old.articulo_id;

    when updating then
      raise_application_error(-20002,
      'Aún no se soporta dicha operación');

    end case;
end;
/

