-- *********************************
-- * Circuito para generar objetos *
-- *********************************

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

  --------------------
  -- Pared vertical --
  --------------------
  -- Pixel dentro de la pared
  obj_on <=
    '1' when (px_x >= PARED_X_I) and (px_x <= PARED_X_D) else
    '0';
  -- Salida RGB de la pared
  obj_rgb <= "001";  -- Azul

end pared;

architecture barra of gen_obj is

  -- Coordenadas x, y (0, 0) hasta (639, 479)
  signal px_x, px_y: unsigned(9 downto 0);
  constant MAX_X: integer := 640;
  constant MAX_Y: integer := 480;

  -----------------------------
  -- Barra vertical (4 x 72) --
  -----------------------------
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

  --------------------
  -- Barra vertical --
  --------------------
  -- Pixel dentro de la barra
  obj_on <=
    '1' when (px_x >= BAR_X_I) and (px_x <= BAR_X_D) and
             (px_y >= BAR_Y_S) and (px_y <= BAR_Y_I) else
    '0';
  -- Salida RGB de la barra
  obj_rgb <= "010";  -- Verde

end barra;