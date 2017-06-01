-- *******************************
-- Comparador de igualdad de 1 bit
-- *******************************

-- Usar (--) para añadir un comentario.
-- VHDL no diferencia mayúsculas de minúsculas.
-- Los espacios verticales y horizontales se
-- pueden añadir libremente.
-- Convencionalmente usar mayúsculas para las constantes.

-- Los paquetes y las librerías permiten añadir tipos, operadores y
-- funciones a VHDL.
library ieee;  -- Librería
use ieee.std_logic_1164.all;  -- Paquete de la librería ieee

-- std_logic está definida en el paque std_logic_1164 y puede tomar 9 valores.
-- 0 y 1 son valores que se pueden sintetizar en hardware.

-- Se pueden usar not, and, or y xor como operadores lógicos con std_logic
-- y std_logic_vector. Usar paréntesis para establecer el orden ya que estos
-- operadores tienen la misma precedencia.

-- **********************
-- Declaración de entidad
-- **********************

-- Un identificador es el nombre del objeto y está compuesto por 26 letras,
-- dígitos y guiones bajos. Debe comenzar con una letra.

entity ig1 is  -- Identificador
   port(
   -- señal1, señal2, ... : modo tipo_dato;
      e1, e2:                in  std_logic;  -- Entradas
      ig:                    out std_logic   -- Salida
   );
end ig1;

-- *****************************
-- Estructura de la arquitectura
-- *****************************
-- Describe la operación del circuito.

-- Se pueden asociar muchas estructuras para una entidad. En este caso se usa
-- sdp_arq (arquitectura de suma de productos).
architecture arq_sdp of ig1 is

   -- Sección opcional para declarar constantes, señales internas, etc.
   signal p1, p2: std_logic;  -- Dos señales internas
   
begin  -- Inicio de la descripción principal

   -- suma del producto de dos términos
   ig <= p1 or p2;  -- Declaración concurrente (no importa el orden)
   
   -- producto de términos
   p1 <= (not e1) and (not e2);  -- Declaración concurrente
   p2 <= e1 and e2;  -- Declaración concurrente
   
end arq_sdp;  -- Fin de la descripción principal
