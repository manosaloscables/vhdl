-- **************************************************
-- Registro de Desplazamiento de funcionamiento libre
-- **************************************************
-- Desplaza una posición el contenido del registro hacia la derecha o izquierda
-- en cada ciclo de reloj.

library ieee;
use ieee.std_logic_1164.all;

entity rddl is

   generic(N: integer:=8);
   
   port(
      clk, rst: in std_logic;
      s: in std_logic;  -- Sentido de desplazamiento (derecha o izquierda)
      ent_s: in std_logic;  -- Entrada serial
      sal_s: out std_logic_vector(N-1 downto 0)  -- Registro de salida
   );

end rddl;

architecture arq of rddl is

   signal r_reg, r_sig: std_logic_vector(N-1 downto 0);
   
begin

   -- Registro
   process(clk, rst) begin

      if(rst='0') then
         r_reg <= (others=>'0');

      elsif(clk'event and clk='1') then
         r_reg <= r_sig;
      end if;

   end process;

   -- Lógica del siguiente estado (desplazar 1 bit)
   process(s, ent_s, r_reg) begin

      if(s='0') then  -- Desplazar a la derecha
         r_sig <= ent_s & r_reg(N-1 downto 1);

      else  -- Desplazar a la izquierda
         r_sig <= r_reg(N-1 downto 1) & ent_s;
      end if;

   end process;

   -- Salida
   sal_s <= r_reg;

end arq;