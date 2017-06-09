-- ************************
-- * Archivo de Registros *
-- ************************
-- Usa indexado din�mico.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity archivo_reg is
   generic(
      DIR_ANCHO:   integer:=2;  -- N�mero de bits para la direcci�n
      DATOS_ANCHO: integer:=8   -- N�mero de bits por t�rmino
   );
   port(
      clk: in std_logic;

      -- Activador de estcritura
      wr_en: in std_logic;

      -- Direcci�n de estcritura
      w_dir: in std_logic_vector (DIR_ANCHO-1 downto 0);

      -- Direcci�n de lectura
      r_dir: in std_logic_vector (DIR_ANCHO-1 downto 0);

      -- Datos a escribir
      w_datos: in std_logic_vector (DATOS_ANCHO-1 downto 0);

      -- Datos a leer
      r_datos: out std_logic_vector (DATOS_ANCHO-1 downto 0)
   );
end archivo_reg;

architecture arq of archivo_reg is
   -- Debe crearse un nuevo tipo de datos ya que un arreglo de dos dimensiones
   -- no existe en el paquete de std_logic_1164
   type mem_tipo_2d is array (0 to 2**DIR_ANCHO-1) of
        std_logic_vector(DATOS_ANCHO-1 downto 0);

   signal arreglo_reg: mem_tipo_2d;
begin
   process(clk)
   begin
      if (clk'event and clk='1') then
         if wr_en='1' then
            -- La siguiente declaraci�n infiere la l�gica de decodificai�n
            arreglo_reg(to_integer(unsigned(w_dir))) <= w_datos;
         end if;
      end if;
   end process;

   -- Puerto de lectura
   -- La siguiente declaraci�n infiere la l�gica de multiplexaci�n
   r_datos <= arreglo_reg(to_integer(unsigned(r_dir)));
end arq;
