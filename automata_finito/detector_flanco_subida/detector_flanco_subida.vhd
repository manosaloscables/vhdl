-- ********************************
-- * Detector de Flanco de Subida *
-- ********************************

library ieee;
use ieee.std_logic_1164.all;

entity detec_flanco_s is

   port(
      clk, rst: in std_logic;
      nivel : in  std_logic;
      tick  : out std_logic
   );

end detec_flanco_s;

architecture arq_moore of detec_flanco_s is

   type tipo_est is (cero, flanco, uno);
   signal est_reg, est_sig: tipo_est;

begin

   -- Registro de estado
   process(clk, rst)
   begin

      if (rst='0') then
         est_reg <= cero;
      elsif (clk'event and clk='1') then
         est_reg <= est_sig;
      end if;

   end process;

   -- Lógica del siguiente estado/salida
   process(est_reg, nivel)
   begin

      est_sig <= est_reg;  -- Volver al mismo estado por defecto
      tick <= '0';  -- Por defecto 0

      case est_reg is

         when cero =>
            if(nivel='1') then
               est_sig <= flanco;
            end if;

         when flanco =>
            tick <= '1';
            if(nivel='1') then
               est_sig <= uno;
            else
               est_sig <= cero;
            end if;

         when uno =>
            if(nivel='0') then
               est_sig <= cero;
            end if;

      end case;

   end process;

end arq_moore;

architecture arq_mealy of detec_flanco_s is

   type tipo_est is (cero, uno);
   signal est_reg, est_sig: tipo_est;

begin

   -- Registro de estado
   process(clk, rst)
   begin

      if (rst='0') then
         est_reg <= cero;
      elsif (clk'event and clk='1') then
         est_reg <= est_sig;
      end if;

   end process;

   -- Lógica del siguiente estado/salida
   process(est_reg, nivel)
   begin

      est_sig <= est_reg;  -- Volver al mismo estado por defecto
      tick <= '0';  -- Por defecto 0

      case est_reg is

         when cero =>
            if(nivel='1') then
               est_sig <= uno;
               tick <= '1';
            end if;

         when uno =>
            if(nivel='0') then
               est_sig <= cero;
            end if;

      end case;

   end process;

end arq_mealy;

-- Arquitectura a nivel de compuertas lógicas
architecture arq_compuertas of detec_flanco_s is

   signal reg_previo: std_logic;


begin

   process(clk, rst) begin

      if(rst='1') then
         reg_previo <= '0';
      elsif(clk' event and clk='1') then
         reg_previo <= nivel;
      end if;

   end process;

   -- Lógica de decodificación
   tick <= (not reg_previo) and nivel;

end arq_compuertas;
