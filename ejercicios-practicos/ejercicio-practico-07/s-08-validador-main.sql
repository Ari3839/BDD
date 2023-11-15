--@Autor:           Jorge Rodriguez
--@Fecha creación:  dd/mm/yyyy
--@Descripción:     Ejercicio práctico 7 - Validador - Main

--Modificar las siguientes 6 variables en caso de ser necesario.
--En scripts reales no deben incluirse passwords. Solo se hace para
--propósitos de pruebas y evitar escribirlos cada vez que se quiera ejecutar 
--el proceso de validación de la práctica (propósitos académicos).

--
-- Nombre del usuario empleado en esta práctica
--
define p_usuario='editorial_bdd'

--
-- Password del usuario empleado en esta práctica
--
define p_usuario_pass='editorial_bdd'

--
-- Password del usuario sys
--
define p_sys_password='system'

--
-- Nombre de la PDB 1
--
define p_pdb1='jrcbdd_s1'

--
-- Nombre de la PDB 2
--
define p_pdb2='jrcbdd_s2'

---
--- Elección de fragmentación para SUCURSAL: 
---  P  Con respecto a País (default)
---  B  Con respecto a  Banco  
---
define p_tipo_fr='A'


--- ============= Las siguientes configuraciones ya no requieren cambiarse====

whenever sqlerror exit rollback
set verify off
set feedback off

Prompt =========================================================
Prompt Iniciando validador - Ejercicio práctico 7
Prompt Presionar Enter si los valores configurados son correctos.
Prompt De lo contrario editar el script s-08-validador-main.sql
Prompt O en su defecto proporcionar nuevos valores
Prompt =========================================================

Prompt Datos de Entrada:
accept p_sys_pwd default '&&p_sys_password' prompt '1. Proporcionar el password de SYS [configurado en script]: '
accept p_usuario default '&&p_usuario' prompt '1. Proporcionar el nombre de usuario [&&p_usuario]: '
accept p_usuario_pass default '&&p_usuario_pass' prompt '2. Proporcionar password del usuario &&p_usuario [Configurado en script]: '
accept p_pdb1 default &&p_pdb1 prompt '3. Nombre del sitio 1 (PDB 1). [&&p_pdb1]: '
accept p_pdb2 default &&p_pdb2 prompt '4. Nombre del sitio 2 (PDB 2). [&&p_pdb2]: '

Prompt Indicar la estrategia de fragmentación para la tabla ARTICULO_REVISTA:
prompt A - Con respecto a ARTICULO (default)
Prompt R - Con respecto a REVISTA
accept p_tipo_fr default '&&p_tipo_fr' prompt 'Indicar valor [&&p_tipo_fr]: '

define p_script_validador='s-08p-validador-transparencia.plb'

--ejecuta validación en pdb1
start &&p_script_validador &&p_sys_pwd &&p_pdb1 &&p_usuario &&p_usuario_pass &&p_tipo_fr 1

--ejecuta validación en pdb2
start &&p_script_validador &&p_sys_pwd &&p_pdb2 &&p_usuario &&p_usuario_pass &&p_tipo_fr 2

exit