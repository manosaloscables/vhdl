-- ********************
-- * Flip Flop tipo D *
-- ********************
-- Con reinicio asíncrono y activador
library ieee; use ieee.std_logic_1164.all;

entity ffden is
   port(
      clk, rst: in std_logic;
      en: in std_logic;  -- Activador
      d:  in std_logic;
      q: out std_logic
   );
end ffden;

architecture arq of ffden is
begin
   process(clk,rst)
   begin
      if (rst='1') then
         q <='0';
      elsif (clk'event and clk='1') then
         if (en='1') then
            q <= d;
         end if;
      end if;
   end process;
end arq;

-- Con una lógica simple de siguiente estado
architecture arq_dos_est of ffden is
   signal r_alm: std_logic;  -- Registro almacenado
   signal r_sig: std_logic;  -- Registro siguiente entrada
begin
   process(clk,rst)
   begin
      if (rst='1') then
         r_alm <='0';
      elsif (clk'event and clk='1') then
         r_alm <= r_sig;
      end if;
   end process;

   -- Lógica del siguiente estado
   r_sig <= d when en ='1' else
             r_alm;

   -- Lógica de la salida
   q <= r_alm;
end arq_dos_est;
