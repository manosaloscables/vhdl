-- *****************************************
-- * Banco de prueba para Flip Flop tipo D *
-- *****************************************
library ieee; use ieee.std_logic_1164.all;

entity ff_d_bp is
end ff_d_bp;

architecture arq_bp of ff_d_bp is
   constant T: time := 20 ns;        -- Período del reloj
   signal clk, prueba_e: std_logic;  -- Entradas
   signal prueba_s:      std_logic;  -- Salida
begin
   -- Instanciar la unidad bajo prueba
   ubp: entity work.ff_d(arq)
      port map(
               clk => clk,
               d   => prueba_e,
               q   => prueba_s
      );

   -- Reloj
   process begin
      clk <= '0';
      wait for T/2;
      clk <= '1';
      wait for T/2;
   end process;

   -- Otros estímulos
   process begin
      for i in 1 to 10 loop  -- Esperar 10 transisiones del Flip Flop tipo D
         prueba_e <= '0';
         wait until falling_edge(clk);

         prueba_e <= '1';
         wait until falling_edge(clk);
      end loop;

      -- Terminar la simulación
      assert false
         report "Simulación Completada"
      severity failure;
   end process;
end arq_bp;
