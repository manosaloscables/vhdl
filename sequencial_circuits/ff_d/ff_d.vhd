-- ********************
-- * Flip Flop tipo D *
-- ********************
-- No tiene reinicio asíncrono

library ieee;
use ieee.std_logic_1164.all;

entity ff_d is
   port(
      clk: in  std_logic;
      d:   in  std_logic;
      q:   out std_logic
   );
end ff_d;

architecture arq of ff_d is
begin
   process(clk)
   begin
      if (clk'event and clk='1') then
         q <= d;
      end if;
   end process;
end arq;