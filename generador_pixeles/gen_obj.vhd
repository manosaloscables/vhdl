-- *************************************
-- * Circuito para generar objetos VGA *
-- *************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_obj is  -- Generador de objetos estáticos
  port(
    obj_on  : out std_logic;
    pixel_x, pixel_y: in  std_logic_vector(9 downto 0);
    obj_rgb         : out std_logic_vector(2 downto 0)
  );
end gen_obj;

--------------------
-- Pared vertical --
--------------------
architecture pared of gen_obj is

  -- Coordenadas x, y (0, 0)
  signal px_x, px_y: unsigned(9 downto 0);

  ----------------------------------------------
  -- Pared vertical (4 x Resolución vertical) --
  ----------------------------------------------
  -- Borde horizontal(x) izquierdo y derecho
  constant PARED_X_I: integer := 32;
  constant PARED_X_D: integer := 35;

begin

  px_x <= unsigned(pixel_x);
  px_y <= unsigned(pixel_y);

  -- Pixel dentro de la pared
  obj_on <=
    '1' when (px_x >= PARED_X_I) and (px_x <= PARED_X_D) else
    '0';

  -- Salida RGB de la pared
  obj_rgb <= "001";  -- Azul

end pared;

-----------------------------
-- Barra vertical (4 x 72) --
-----------------------------
architecture barra of gen_obj is

  -- Coordenadas x, y (0, 0) hasta (639, 479)
  signal px_x, px_y: unsigned(9 downto 0);
  constant MAX_X: integer := 640;
  constant MAX_Y: integer := 480;

  constant BAR_X_DIM: integer := 4;  -- Dimensión/tamaño
  constant BAR_Y_DIM: integer := 72;
  -- Borde horizontal(x) izquierdo y derecho
  constant BAR_X_I: integer := 600;
  constant BAR_X_D: integer := BAR_X_I + BAR_X_DIM - 1;
  -- Borde vertical(y) superior e inferior
  constant BAR_Y_S: integer := MAX_Y/2 - BAR_Y_DIM/2;  -- 204
  constant BAR_Y_I: integer := BAR_Y_S + BAR_Y_DIM - 1;

begin

  px_x <= unsigned(pixel_x);
  px_y <= unsigned(pixel_y);

  -- Pixel dentro de la barra
  obj_on <=
    '1' when (px_x >= BAR_X_I) and (px_x <= BAR_X_D) and
             (px_y >= BAR_Y_S) and (px_y <= BAR_Y_I) else
    '0';

  -- Salida RGB de la barra
  obj_rgb <= "010";  -- Verde

end barra;

----------------------------------------------
-- Bola (delimitada por un cuadrado de 8x8) --
----------------------------------------------
architecture bola of gen_obj is

  -- Coordenadas x, y (0, 0)
  signal px_x, px_y: unsigned(9 downto 0);

  constant BOLA_DIM: integer := 8;  -- Dimensión
  -- Borde horizontal(x) izquierdo y derecho
  signal bola_x_i, bola_x_d: unsigned(9 downto 0);
  -- Borde vertical(y) superior e inferior
  signal bola_y_s, bola_y_i: unsigned(9 downto 0);

  -- Señal que indica si las coordenadas del barrido se encuentran dentro de la
  -- región cuadrada
  signal cuadrado_on: std_logic;

  ----------------------------
  -- Imagen ROM de una bola --
  ----------------------------
  type tipo_rom is array (0 to 7) of std_logic_vector(0 to 7);

  -- Definición de la memoria ROM
  constant BOLA_ROM: tipo_rom :=
  (
    "00111100", --   ****
    "01111110", --  ******
    "11111111", -- ********
    "11111111", -- ********
    "11111111", -- ********
    "11111111", -- ********
    "01111110", --  ******
    "00111100"  --   ****
  );

  signal rom_dir, rom_col: unsigned(2 downto 0);
  signal rom_datos: std_logic_vector(7 downto 0);
  signal rom_bit: std_logic;

begin

  px_x <= unsigned(pixel_x);
  px_y <= unsigned(pixel_y);

  -- Declaración temporal
  bola_x_i <= to_unsigned(580, 10);
  bola_x_d <= to_unsigned(587, 10);
  bola_y_s <= to_unsigned(238, 10);
  bola_y_i <= to_unsigned(245, 10);

  -- Pixel dentro del cuadrado de 8x8
  cuadrado_on <=
    '1' when (px_x >= bola_x_i) and (px_x <= bola_x_d) and
             (px_y >= bola_y_s) and (px_y <= bola_y_i) else
    '0';

  -- Mapear la ubicación del píxel actual a la dir/col ROM
  rom_dir <= px_y(2 downto 0) - bola_y_s(2 downto 0);
  rom_col <= px_x(2 downto 0) - bola_x_i(2 downto 0);
  rom_datos <= BOLA_ROM(to_integer(rom_dir));
  rom_bit <= rom_datos(to_integer(rom_col));

  obj_on <=
    '1' when (cuadrado_on = '1') and (rom_bit = '1') else
    '0';

  -- Salida RGB de la bola
  obj_rgb <= "100";  -- Rojo

end bola;
