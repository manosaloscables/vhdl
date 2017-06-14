-- *****************************************
-- *  Banco de prueba para Autómata finito *
-- *****************************************

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ej_af_bp is
end ej_af_bp;

architecture tb_arch of ej_af_bp is

   constant T: time := 20 ns;  -- Periodo del Reloj
   signal clk, rst, a, b, y0, y1: std_logic;

begin

   -- =============
   -- Instanciar la unidad bajo prueba
   -- =============
   ubp: entity work.ej_af(arq_dos_seg)

      port map(clk => clk, rst => rst,
               a => a, b => b,
               y0 => y0, y1 => y1);

   -- =====
   -- Reloj
   -- =====
   process begin
      clk <= '0';
      wait for T/2;
      clk <= '1';
      wait for T/2;
   end process;
   
   -- ========
   -- Reinicio
   -- ========
   rst <= '0', '1' after T/2;
   
   -- ==============
   -- Otros estímulos
   -- ==============
   process begin

      a <= '0';
      b <= '0';
      wait until falling_edge(clk);

      a <= '1';
      wait until falling_edge(clk);

      wait until falling_edge(clk);

      a <= '1';
      b <= '1';
      wait until falling_edge(clk);

      a <= '0';
      b <= '0';
      wait until falling_edge(clk);


      -- ===================
      -- Terminar simulación
      -- ===================
      assert false
         report "Simulación Completada"
      severity failure;

   end process;

end tb_arch;