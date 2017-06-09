-- *********************************************
-- * Banco de prueba para Archivo de Registros *
-- *********************************************
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity archivo_reg_bp is
   generic(
      DIR_ANCHO:   integer:=2;  -- Número de bits para la dirección
      DATOS_ANCHO: integer:=8   -- Número de bits por término
   );
end archivo_reg_bp;

architecture arq_bp of archivo_reg_bp is
   constant T: time := 20 ns;  -- Período del reloj
   signal clk:   std_logic;    -- Reloj
   signal wr_en: std_logic;    -- Activador de escritura
   signal w_dir: std_logic_vector (DIR_ANCHO-1 downto 0);  -- Dirección de estcritura
   signal r_dir: std_logic_vector (DIR_ANCHO-1 downto 0);  -- Dirección de lectura
   signal prueba_e: std_logic_vector (DATOS_ANCHO-1 downto 0);  -- Entrada
   signal prueba_s: std_logic_vector (DATOS_ANCHO-1 downto 0);  -- Salida
begin
   -- Instanciar la unidad bajo prueba
   ubp: entity work.archivo_reg(arq)
      port map(
               clk => clk,
               wr_en   => wr_en,
               w_dir   => w_dir,
               r_dir   => r_dir,
               w_datos   => prueba_e,
               r_datos   => prueba_s
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
      -- Activar modo de escritura
      wr_en <= '1';
      -- Escribir en el tercer registro
      w_dir <= "10";
      prueba_e <= "11111111";
      wait until falling_edge(clk);

      -- Escribir el mismo valor en el segundo registro
      w_dir <= "01";
      prueba_e <= "11111111";
      wait until falling_edge(clk);

      -- Escribir otro valor en el primer registro
      w_dir <= "00";
      prueba_e <= "00001111";
      wait until falling_edge(clk);

       -- Escribir otro valor en el cuarto registro
      wr_en <= '1';
      w_dir <= "11";
      prueba_e <= "00000000";
      wait until falling_edge(clk);

      -- Deshabilitar escribir otro valor en el cuarto registro
      wr_en <= '0';
      w_dir <= "11";
      prueba_e <= "11110000";
      wait until falling_edge(clk);

      for i in 0 to 2**DIR_ANCHO-1 loop  -- Leer el archivo de registros
         r_dir <= std_logic_vector(to_unsigned(i,DIR_ANCHO));
         wait until falling_edge(clk);
      end loop;

      -- Terminar la simulación
      assert false
         report "Simulación Completada"
      severity failure;
   end process;
end arq_bp;
