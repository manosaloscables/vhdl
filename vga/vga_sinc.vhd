-- **********************************
-- * Circuito de sincronización VGA *
-- **********************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sinc is

  port(
    clk, rst: in  std_logic;
    px_tick : out std_logic
  );

end vga_sinc;

architecture arq of vga_sinc is

  -- Contador módulo 2
  signal mod2_reg, mod2_next: std_logic;
  
  -- Señal de estado
    signal pixel_tick: std_logic;

begin
  -- Registro
  process(clk, rst) begin
  
    if rst = '0' then
      mod2_reg <= '0';

    elsif(rising_edge(clk)) then
      mod2_reg <= mod2_next;
    end if;

  end process;
  
  -- Circuito de módulo 2 para generar el tick de activación de 25 MHz
  mod2_next <= not mod2_reg;
  
  -- Pixel tick de 25 MHz
  pixel_tick <= mod2_reg;
  
  -- Señal de salida
  px_tick <= pixel_tick;

end arq;
