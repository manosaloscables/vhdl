-- **********************************************
-- Banco de prueba para Circuitos combinacionales
-- **********************************************
-- En inglés se llama testbench

library ieee;
use ieee.std_logic_1164.all;
entity ig2_bp is
end ig2_bp;

architecture arq_bp of ig2_bp is
   signal prueba_e1, prueba_e2: std_logic_vector(1 downto 0);  -- Entradas
   signal prueba_s: std_logic;  -- Salida
begin
   -- Instanciar la unidad bajo prueba
   ubp: entity work.ig2(arq_est)
      port map(
               a => prueba_e1,
               b => prueba_e2,
               aigb => prueba_s
      );
   process begin
      -- Vector de prueba 1
      prueba_e1 <= "00";
      prueba_e2 <= "00";
      wait for 200 ns;
      
      -- Vector de prueba 2
      prueba_e1 <= "01";
      prueba_e2 <= "00";
      wait for 200 ns;
      
      -- Vector de prueba 3
      prueba_e1 <= "01";
      prueba_e2 <= "11";
      wait for 200 ns;
      
      -- Vector de prueba 4
      prueba_e1 <= "10";
      prueba_e2 <= "10";
      wait for 200 ns;
      
      -- Vector de prueba 5
      prueba_e1 <= "10";
      prueba_e2 <= "00";
      wait for 200 ns;
      
      -- Vector de prueba 6
      prueba_e1 <= "11";
      prueba_e2 <= "11";
      wait for 200 ns;
      
      -- Vector de prueba 7
      prueba_e1 <= "11";
      prueba_e2 <= "01";
      wait for 200 ns;
	  
	  -- Terminar la simulación
	  assert false
	     report "Simulación Completada"
		 severity failure;
   end process;
end arq_bp;
