-- ************************************
-- * RAM síncrona de un puerto Altera *
-- ************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram_up is

   generic(
      DIR_ANCHO: integer:=2;
      DATOS_ANCHO: integer:=8
   );

   port(
      clk: in std_logic;
      we: in std_logic;  -- Activador de escritura

      -- Dirección de memoria
      dir: in std_logic_vector(DIR_ANCHO-1 downto 0);

      -- Registros que reflejan cómo los módulos de memoria embebida están 
      -- empaquetados con una interfaz síncrona en los chips Cyclone.
      d: in std_logic_vector(DATOS_ANCHO-1 downto 0);
      q: out std_logic_vector(DATOS_ANCHO-1 downto 0)
   );
   
end sram_up;

-- Arquitectura que registra la dirección de lectura
architecture arq_dir_reg of sram_up is

   --------------------------------------------------------------------
   -- Crear un tipo de datos de dos dimensiones definido por el usuario
   type mem_tipo_2d is array (0 to 2**DIR_ANCHO-1)
      of std_logic_vector (DATOS_ANCHO-1 downto 0);

   signal sram: mem_tipo_2d;
   --------------------------------------------------------------------
   
   signal dir_reg: std_logic_vector(DIR_ANCHO-1 downto 0);

begin

   process (clk)
   begin

      if (clk'event and clk = '1') then

         if (we='1') then
            sram(to_integer(unsigned(dir))) <= d;
         end if;

         dir_reg <= dir;

      end if;

   end process;
   
   -- Salida
   q <= sram(to_integer(unsigned(dir_reg)));

end arq_dir_reg;
