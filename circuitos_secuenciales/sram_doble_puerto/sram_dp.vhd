-- ******************************************************************
-- * RAM síncrona de doble puerto simplificada para FPGAs de Altera *
-- ******************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram_dp is

  generic(
    DIR_ANCHO  : integer:=2;
    DATOS_ANCHO: integer:=8
  );

  port(
    clk: in std_logic;
    we : in std_logic;  -- Activador de escritura

    -- Direcciones de escritura y lectura
    w_dir: in std_logic_vector(DIR_ANCHO-1 downto 0);  -- Escritura
    r_dir: in std_logic_vector(DIR_ANCHO-1 downto 0);  -- Lectura

    -- Registros que reflejan cómo los módulos de memoria embebida están 
    -- empaquetados con una interfaz síncrona en los chips Cyclone.
    d: in  std_logic_vector(DATOS_ANCHO-1 downto 0);
    q: out std_logic_vector(DATOS_ANCHO-1 downto 0)
  );

end sram_dp;

-- ****************************************************************************
-- Si w_addr y r_addr son iguales, q adquiere los datos actuales (nuevos datos)
-- ****************************************************************************
architecture arq_dir_reg of sram_dp is

  --------------------------------------------------------------------
  -- Crear un tipo de datos de dos dimensiones definido por el usuario
  type mem_tipo_2d is array (0 to 2**DIR_ANCHO-1)
    of std_logic_vector (DATOS_ANCHO-1 downto 0);

  signal sram: mem_tipo_2d;
  --------------------------------------------------------------------

  signal dir_reg: std_logic_vector(DIR_ANCHO-1 downto 0);

begin

  process (clk) begin

    if(rising_edge(clk)) then

      if (we='1') then
        sram(to_integer(unsigned(w_dir))) <= d;
      end if;

      dir_reg <= r_dir;

    end if;

  end process;

  -- Salida
  q <= sram(to_integer(unsigned(dir_reg)));

end arq_dir_reg;
