-- **************************************************
-- * Circuito de pruebas para la sincronización VGA *
-- **************************************************

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_top is
  port(
    clk  , rst   : in  std_logic;
    sw           : in  std_logic_vector(2 downto 0);
    rgb          : out std_logic_vector(2 downto 0);
    hsinc, vsinc : out std_logic
  );
end vga_top;

architecture arq of vga_top is

  signal rgb_reg : std_logic_vector(2 downto 0);
  signal video_on: std_logic;

begin

  -- Instanciar un circuito de sincronización VGA
  unidad_vga_sinc: entity work.vga_sinc(arq)
    port map(
             clk      => clk,
             rst      => rst,
             px_tick  => open,
             video_on => video_on,
             pixel_x  => open,
             pixel_y  => open,
             hsinc    => hsinc,
             vsinc    => vsinc
    );

  -- Búfer RGB
  process(clk, rst) begin

    if rst = '0' then
      rgb_reg <= (others => '0');
    
    elsif(rising_edge(clk)) then
      rgb_reg <= sw;
    end if;

  end process;
  
  rgb <= rgb_reg when video_on = '1' else "000";

end arq;
