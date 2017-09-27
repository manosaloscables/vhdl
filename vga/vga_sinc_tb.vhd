-- ***********************************************************
-- *  Banco de prueba para el circuito de sincronización VGA *
-- ***********************************************************

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_bp is
end vga_bp;

architecture arq_bp of vga_bp is
  constant T: time := 20 ns;  -- Periodo del Reloj
  signal clk, rst: std_logic; -- Entradas
  signal px_tick, video_on, hsinc, vsinc: std_logic;  -- Salidas
  signal px_x, px_y: std_logic_vector(9 downto 0);
  
  signal sw, rgb, rgb_reg: std_logic_vector(2 downto 0); -- Estímulos

begin

  -- Instanciar un circuito de sincronización VGA
  unidad_vga_sinc: entity work.vga_sinc(arq)
    port map(
             clk      => clk,
             rst      => rst,
             px_tick  => px_tick,
             video_on => video_on,
             pixel_x  => px_x,
             pixel_y  => px_y,
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

  -- Reloj
  process begin
    clk <= '0';
    wait for T/2;
    clk <= '1';
    wait for T/2;
  end process;

  -- Reinicio
  rst <= '0', '1' after T/2;

  -- Otros estímulos
  process begin

    sw <= "001";
    for i in 1 to 1000000 loop
      wait until falling_edge(clk);
    end loop;

    -- Terminar simulación
    assert false
      report "Simulación Completada"
    severity failure;

  end process;

end arq_bp;
