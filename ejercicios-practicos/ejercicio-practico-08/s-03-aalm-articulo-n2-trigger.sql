-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/11/2023
-- @Descripcion: Trigger para articulo desde sitio 2

create or replace trigger t_dml_articulo
instead of insert or update or delete on articulo
declare
begin
  case
    when inserting then
      --insersión local, sin temp
      insert into articulo_2(articulo_id,titulo,resumen,texto)
        values(:new.articulo_id,:new.titulo,:new.resumen,:new.texto);
      --inserta el blob 
      insert into articulo_1(articulo_id,pdf)
        values(:new.articulo_id,:new.pdf);
      --Insersión remota con temp

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

