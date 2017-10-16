-- **************************************************************
-- *  Banco de prueba para el circuito de generación de píxeles *
-- **************************************************************

library ieee; 
use ieee.std_logic_1164.all;

entity gen_px_tb is
end gen_px_tb;

architecture arq_bp of gen_px_tb is
  constant T: time := 20 ns;  -- Periodo del Reloj
  signal clk, rst: std_logic; -- Entradas
  signal rgb: std_logic_vector(2 downto 0);  -- Salidas
  signal hsinc, vsinc: std_logic;

begin

  -- Instanciar un circuito de generación de píxeles
  unidad_gen_px: entity work.gen_px(arq)
    port map(
             clk   => clk,
             rst   => rst,
             rgb   => rgb,
             hsinc => hsinc,
             vsinc => vsinc
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

    for i in 1 to 1000000 loop
      wait until falling_edge(clk);
    end loop;

    -- Terminar simulación
    assert false
      report "Simulación Completada"
    severity failure;

  end process;

end arq_bp;