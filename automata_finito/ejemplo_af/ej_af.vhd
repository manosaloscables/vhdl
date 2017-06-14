-- **********************************************
-- * Autómata finito (máquina de estado finito) *
-- **********************************************

library ieee;
use ieee.std_logic_1164.all;

entity ej_af is

   port(
      clk, rst: in std_logic;
      a, b: in std_logic;
      y0, y1: out std_logic
   );

end ej_af;

architecture arq_dos_seg of ej_af is

   type tipo_est_ej is (s0, s1, s2);  -- Lista (enumera) los valores simbólicos
   signal est_reg, est_sig: tipo_est_ej;

begin

   -- Registro de estado
   process(clk, rst)
   begin

      if (rst='0') then
         est_reg <= s0;
      elsif (clk'event and clk='1') then
         est_reg <= est_sig;
      end if;

   end process;

   -- Lógica del siguiente estado/salida
   process(est_reg, a, b)
   begin

      est_sig <= est_reg;  -- Volver al mismo estado por defecto
      y0 <= '0';  -- Por defecto 0
      y1 <= '0';  -- Por defecto 0

      case est_reg is

         when s0 =>
            y1 <= '1';
            if a='1' then
               if b='1' then
                  est_sig <= s2;
                  y0 <= '1';
               else
                  est_sig <= s1;
               end if;
            -- sin else ya que s0 se mantiene para a=0
            end if;

         when s1 =>
            y1 <= '1';
            if (a='1') then
               est_sig <= s0;
            -- sin else ya que s1 se mantiene para a=0
            end if;

         when s2 =>
            est_sig <= s0;

      end case;

   end process;

end arq_dos_seg;