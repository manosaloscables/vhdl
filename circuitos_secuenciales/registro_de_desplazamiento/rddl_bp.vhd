-- *********************************************************
-- * Banco de prueba para Registro de Desplazamiento Libre *
-- *********************************************************

library ieee; use ieee.std_logic_1164.all;

entity rddl_bp is
   generic(N: integer:=8);
end rddl_bp;

architecture arq_bp of rddl_bp is

   constant T: time := 20 ns;  -- Período del reloj
   signal clk, rst: std_logic;
   signal s, ent_s, sal_s: std_logic;
   signal reg: std_logic_vector(N-1 downto 0);
   
begin
   -- Instanciar la unidad bajo prueba
   ubp: entity work.rddl(arq)
      port map(clk => clk, rst => rst, s => s,
               ent_s => ent_s, sal_s => sal_s,
               reg => reg);

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

      s <= '0';  -- Derecha
      ent_s <= '1';

      for i in 1 to 4 loop
         wait until falling_edge(clk);
      end loop;

      ent_s <= '0';
      for i in 1 to 4 loop
         wait until falling_edge(clk);
      end loop;

      s <= '1';  -- Izquierda
      ent_s <= '1';

      for i in 1 to 3 loop
         wait until falling_edge(clk);
      end loop;

      ent_s <= '0';
      for i in 1 to 5 loop
         wait until falling_edge(clk);
      end loop;

      -- Terminar la simulación
      assert false
         report "Simulación Completada"
      severity failure;

   end process;

end arq_bp;
