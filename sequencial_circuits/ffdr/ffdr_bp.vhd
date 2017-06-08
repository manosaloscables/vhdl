-- ******************************************************
-- * Banco de prueba para Flip Flop tipo D con reinicio *
-- ******************************************************
library ieee; use ieee.std_logic_1164.all;

entity ffdr_bp is
end ffdr_bp;

architecture arq_bp of ffdr_bp is
   constant T: time := 20 ns;     -- Período del reloj
   signal clk, rst: std_logic;  -- Reloj y reinicio
   signal prueba_e:   std_logic;  -- Entradas
   signal prueba_s:   std_logic;  -- Salida
begin
   -- Instanciar la unidad bajo prueba
   ubp: entity work.ffdr(arq)
      port map(
               clk => clk,
               rst => rst,
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

   -- Reinicio
   rst <= '1', '0' after T/2;

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
