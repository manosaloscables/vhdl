-- ****************************************************
-- * Banco de prueba para el generador de objetos VGA *
-- ****************************************************
-- Recordar que durante la simulación se deben incluir
-- las constantes para que obj_on funcione.

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_obj_bp is
end gen_obj_bp;

architecture arq_bp of gen_obj_bp is
  signal px_x, px_y: std_logic_vector(9 downto 0);  -- Entradas
  signal pared_on, bar_on: std_logic;  -- Salidas
  signal pared_rgb, bar_rgb: std_logic_vector(2 downto 0);
  
  signal x, y: unsigned(9 downto 0);  -- Estímulos

begin

  -- Instanciar un generador de objetos con pared
  unidad_gen_obj: entity work.gen_obj(pared)
    port map(
             obj_on  => pared_on,
             pixel_x => px_x,
             pixel_y => px_y,
             obj_rgb => pared_rgb
    );

  -- Instanciar un generador de objetos con barra
  u2_gen_obj: entity work.gen_obj(barra)
    port map(
             obj_on  => bar_on,
             pixel_x => px_x,
             pixel_y => px_y,
             obj_rgb => bar_rgb
    );

  -- Otros estímulos
  process begin

    x <= to_unsigned(0, 10);
    y <= to_unsigned(0, 10);
    wait for 200 ns;

    for j in 1 to 525 loop

      y <= to_unsigned(j-1, 10);
      px_y <= Std_logic_vector(y);

      for i in 1 to 800 loop
        x <= to_unsigned(i-1, 10);
        px_x <= std_logic_vector(x);
        wait for 200 ns;
      end loop;

    end loop;

    -- Terminar simulación
    assert false
      report "Simulación Completada"
    severity failure;

  end process;

end arq_bp;