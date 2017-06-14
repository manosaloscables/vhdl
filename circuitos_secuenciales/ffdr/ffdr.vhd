-- ********************
-- * Flip Flop tipo D *
-- ********************
-- Con reinicio asíncrono

library ieee; use ieee.std_logic_1164.all;

entity ffdr is
   port(
      clk: in  std_logic;  -- Reloj
      rst: in  std_logic;  -- Reinicio
      d:   in  std_logic;
      q:   out std_logic
   );
end ffdr;

architecture arq of ffdr is
begin
   process(clk, rst)
   begin
      if (rst='1') then
         q <='0';
      elsif (clk'event and clk='1') then
         q <= d;
      end if;
   end process;
end arq;
