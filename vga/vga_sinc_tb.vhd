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
  signal px_tick, hsinc: std_logic;  -- Salidas
  signal px_x: std_logic_vector(9 downto 0);

begin

  -- Instanciar un circuito de sincronización VGA
  unidad_vga_sinc: entity work.vga_sinc(arq)
    port map(
             clk     => clk,
             rst     => rst,
             px_tick => px_tick,
             hsinc   => hsinc,
             pixel_x => px_x
    );

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

    for i in 1 to 3201 loop
      wait until falling_edge(clk);
    end loop;

    -- Terminar simulación
    assert false
      report "Simulación Completada"
    severity failure;

  end process;

end arq_bp;
