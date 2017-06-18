-- *******************************************
-- * Banco de pruebas para SRAM de un puerto *
-- *******************************************

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram_up_bp is
   generic(
      DIR_ANCHO: integer:=2;
      DATOS_ANCHO: integer:=8
   );
end sram_up_bp;

architecture tb_arch of sram_up_bp is

   constant T: time := 20 ns;  -- Período del Reloj
   signal clk: std_logic;
   signal we:  std_logic;
   signal dir: std_logic_vector(DIR_ANCHO-1 downto 0);
   signal d: std_logic_vector(DATOS_ANCHO-1 downto 0);
   signal q: std_logic_vector(DATOS_ANCHO-1 downto 0);

begin

   -- =============
   -- Instanciación
   -- =============
   ubp: entity work.sram_up(arq_dir_reg)
   
      generic map(DIR_ANCHO => DIR_ANCHO,
      DATOS_ANCHO => DATOS_ANCHO)
      
      port map(clk => clk,
               we  => we,
               dir => dir,
               d => d,
               q => q);

   -- =====
   -- Reloj
   -- =====
   process begin
      clk <= '0';
      wait for T/2;
      clk <= '1';
      wait for T/2;
   end process;

   -- ===============
   -- Otros estímulos
   -- ===============
   process begin
      
      we <= '1';  -- Activar la escritura

      -- Escribir toda la memoria
      for i in 0 to 2**DIR_ANCHO-1 loop
         dir <= std_logic_vector(to_unsigned(i, DIR_ANCHO));
         d   <= std_logic_vector(to_unsigned(i + 8, DATOS_ANCHO));
         wait until falling_edge(clk);
      end loop;

      we <= '0';  -- Desactivar la escritura/activar la lectura
      wait until falling_edge(clk);

      -- Leer toda la memoria
      for i in 0 to 2**DIR_ANCHO-1 loop
         dir <= std_logic_vector(to_unsigned(i, DIR_ANCHO));
         wait until falling_edge(clk);
      end loop;

      -- ===================
      -- Terminar simulación
      -- ===================
      assert false
         report "Simulación Completada"
      severity failure;

   end process;
   
end tb_arch;
