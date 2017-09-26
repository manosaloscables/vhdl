-- **********************************
-- * Circuito de sincronización VGA *
-- **********************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sinc is

  port(
    clk: in  std_logic;  -- Reloj de 50 MHz 
    rst: in  std_logic;
    px_tick : out std_logic;
    pixel_x : out std_logic_vector(9 downto 0);
    hsinc   : out std_logic
  );

end vga_sinc;

architecture arq of vga_sinc is

  -- Parámetros de sincronización VGA 640x480
  constant HD: integer := 640;  -- Área horizontal de pantalla (display)
  constant HF: integer := 16;   -- Portal frontal horizontal (borde derecho)
  constant HB: integer := 48;   -- Portal trasero horizontal (borde izquierdo)
  constant HP: integer := 96;   -- Pulso de sinc. horizontal (nueva línea)

  -- Contador módulo 2
  signal mod2_reg, mod2_next: std_logic;

  -- Contadores de sincronización
  signal h_cont_reg, h_cont_next: unsigned(9 downto 0);

  -- Búfer de salida
  signal h_sinc_reg, h_sinc_next: std_logic;

  -- Señal de estado
    signal pixel_tick, h_fin: std_logic;

begin
  -- Registro
  process(clk, rst) begin
  
    if rst = '0' then
      mod2_reg <= '0';
      h_cont_reg <= (others => '0');
      h_sinc_reg <= '0';

    elsif(rising_edge(clk)) then
      mod2_reg <= mod2_next;
      h_cont_reg <= h_cont_next;
      h_sinc_reg <= h_sinc_next;
    end if;

  end process;
  
  -- Circuito de módulo 2 para generar el tick de activación de 25 MHz
  mod2_next <= not mod2_reg;
  
  -- Pixel tick de 25 MHz
  pixel_tick <= mod2_reg;

  -- Estado
  h_fin <=  -- Final del contador horizontal
    '1' when h_cont_reg = (HD + HF + HB + HP - 1) else -- 799
    '0';

  -- Contador de sincronización horizontal módulo 800
  process(h_cont_reg, h_fin, pixel_tick) begin

    if pixel_tick = '1' then  -- 25 MHz tick

      if h_fin = '1' then
        h_cont_next <= (others => '0');

      else
        h_cont_next <= h_cont_reg + 1;
      end if;

    else
      h_cont_next <= h_cont_reg;
    end if;

  end process;

  -- Búfer para la sincronización horizontal y vertical para evitar fallas
  h_sinc_next <=
    '1' when (h_cont_reg < (HD + HF))               -- 656
         or  (h_cont_reg >= (HD + HF + HP -1)) else -- 751
    '0';
  
  -- Señal de salida
  px_tick <= pixel_tick;
  pixel_x <= std_logic_vector(h_cont_reg);
  hsinc   <= h_sinc_reg;

end arq;
