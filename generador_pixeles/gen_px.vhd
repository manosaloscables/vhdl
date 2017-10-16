-- *********************************
-- * Circuito para generar píxeles *
-- *********************************

library ieee;
use ieee.std_logic_1164.all;

entity gen_px is
  port(
    clk  , rst   : in  std_logic;
    rgb          : out std_logic_vector(2 downto 0);
    hsinc, vsinc : out std_logic
  );
end gen_px;

architecture arq of gen_px is

  signal px_tick, video_on: std_logic;
  signal px_x, px_y: std_logic_vector(9 downto 0);
  signal pared_on, bar_on, bola_on: std_logic;
  signal pared_rgb, bar_rgb, bola_rgb, rgb_reg, rgb_next:
          std_logic_vector(2 downto 0);

begin

  -- Instanciar un circuito de sincronización VGA
  unidad_vga_sinc: entity work.vga_sinc(arq)
    port map(
             clk      => clk,
             rst      => rst,
             px_tick  => px_tick,
             video_on => video_on,
             pixel_x  => px_x,
             pixel_y  => px_y,
             hsinc    => hsinc,
             vsinc    => vsinc
    );

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

  -- Instanciar un generador de objetos con bola
  u3_gen_obj: entity work.gen_obj(bola)
    port map(
             obj_on  => bola_on,
             pixel_x => px_x,
             pixel_y => px_y,
             obj_rgb => bola_rgb
    );

  -----------------------------------------
  -- Circuito multiplexor de objetos RGB --
  -----------------------------------------

  -- Revisar las entradas (sensitivy list)
  process(video_on, pared_on, bar_on, pared_rgb, bar_rgb) begin

    if video_on = '0' then
      rgb_next <= "000";  -- Apagado

    else

      if pared_on = '1' then
        rgb_next <= pared_rgb;

      elsif bar_on = '1' then
        rgb_next <= bar_rgb;

      elsif bola_on = '1' then
        rgb_next <= bola_rgb;

      else
        rgb_next <= "111";  -- Fondo blanco

      end if;

    end if;

  end process;

  -- Búfer RGB
  process(clk, rst) begin

    if rst = '0' then
      rgb_reg <= (others => '0');
    
    elsif(rising_edge(clk)) then

      if px_tick = '1' then
        rgb_reg <= rgb_next;
      end if;

    end if;

  end process;
  
  rgb <= rgb_reg;

end arq;