-- **************************************************
-- * Circuito de pruebas para la sincronización VGA *
-- **************************************************

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_top is
  port(
    clk, rst: in  std_logic;
    px_tick: out std_logic
  );
end vga_top;

architecture arq of vga_top is

begin

  -- Instanciar un circuito de sincronización VGA
  unidad_vga_sinc: entity work.vga_sinc(arq)
    port map(
             clk => clk,
             rst => rst,
             px_tick => px_tick
    );

end arq;
