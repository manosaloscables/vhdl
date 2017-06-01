-- ********************************
-- Comparador de igualdad de 2 bits
-- ********************************

library ieee;
use ieee.std_logic_1164.all;

-- std_logic_vector es un arreglo de elementos std_logic para señales de más
-- de un bit.
-- Convencionalmente se usa std_logic_vector(N downto 0) en vez de 
-- std_logic_vector(0 to N) ya que el bit más significativo (MSB) está en la
-- posición más a la izquierda.

entity ig2 is
   port(
      a, b: in std_logic_vector(1 downto 0);
      aigb: out std_logic
   );
end ig2;

architecture arq_sdp of ig2 is
   signal p1, p2, p3, p4: std_logic;
begin
   -- Suma de productos de los términos
   aigb <= p1 or p2 or p3 or p4;
   
   -- Producto de los términos
   p1 <= ((not a(1)) and (not b(1))) and
         ((not a(0)) and (not b(0)));
   p2 <= ((not a(1)) and (not b(1))) and (a(0) and b(0));
   p3 <= (a(1) and b(1)) and ((not a(0)) and (not b(0)));
   p4 <= (a(1) and b(1)) and (a(0) and b(0));
end arq_sdp;

-- Una descripción estructural crea instancias de componentes simples para crear
-- un sistema más complejo.
-- La sintaxis para declarar instancias de componentes es:
--    nombre_unidad: entity nombre_lib.nombre_entidad(nombre_arq)
--    port map(
--       señal_instancia => señal_usada,
--       señal2_instancia => señal2_usada
--    );
architecture arq_est of ig2 is
   signal igual1, igual2: std_logic;
begin
   -- Instanciar dos comparadores de igualdad de 1-bit
   unidad_ig_bit1: entity work.ig1(arq_sdp)
      port map(
         e1=>a(0),
         e2=>b(0),
         ig=>igual1
      );
         
   unidad_ig_bit2: entity work.ig1(arq_sdp)
      port map(e1=>a(1), e2=>b(1), ig=>igual2);
      
   -- a y b son iguales si los bits individuales son iguales
   aigb <= igual1 and igual2;
end arq_est;