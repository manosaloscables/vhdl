-- *******************************************************
-- * Banco de prueba para Flip Flop tipo D con activador *
-- *******************************************************
library ieee; use ieee.std_logic_1164.all;

entity ffden_bp is
end ffden_bp;

architecture arq_bp of ffden_bp is
   constant T: time := 20 ns;       -- Período del reloj
   signal clk, rst, en: std_logic;  -- Reloj, reinicio y activador
   signal prueba_e: std_logic;      -- Entradas
   signal prueba_s: std_logic;      -- Salida
begin
   -- Instanciar la unidad bajo prueba
   ubp: entity work.ffden(arq)
      port map(
               clk => clk,
               rst => rst,
               en => en,
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
      en <= '0';
      for i in 1 to 5 loop  -- Esperar 5 transisiones del Flip Flop tipo D
         prueba_e <= '0';
         wait until falling_edge(clk);

         prueba_e <= '1';
         wait until falling_edge(clk);
      end loop;

      en <= '1';
      for i in 1 to 5 loop  -- Esperar 5 transisiones del Flip Flop tipo D
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

