-- **********************************************
-- * Banco de pruebas para SRAM de doble puerto *
-- **********************************************

library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sram_dp_tb is
  generic(
    DIR_ANCHO  : integer:=2;
    DATOS_ANCHO: integer:=8
  );
end sram_dp_tb;

architecture arq_bp of sram_dp_tb is

  constant T: time := 20 ns;  -- Período del Reloj
  signal clk, we: std_logic;
  signal w_dir, r_dir: std_logic_vector(DIR_ANCHO-1 downto 0);
  signal d, q: std_logic_vector(DATOS_ANCHO-1 downto 0);

begin

  -- =============
  -- Instanciación
  -- =============
  unidad_sram_dp: entity work.sram_dp(arq_dir_reg)

    generic map(DIR_ANCHO   => DIR_ANCHO,
                DATOS_ANCHO => DATOS_ANCHO)

    port map(
             clk   => clk,
             we    => we,
             w_dir => w_dir,
             r_dir => r_dir,
             d     => d,
             q     => q
    );

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

    -- Inicialización de la primera dirección en 0
    we <= '1';  -- Activar escritura
    w_dir <= (others => '0');
    r_dir <= (others => '0');
    d <= (others => '0');
    wait until falling_edge(clk);

    -- Escribir en la última dirección (la escritura áun está activada)
    w_dir <= (others => '1');
    d <= (others => '1');  -- Escribir el valor máximo
    wait until falling_edge(clk);

    -- Escribir en la tercera dirección (la escritura áun está activada)
    w_dir <= "10";
    d <= (others => '0');
    wait until falling_edge(clk);

    -- Leer la última dirección
    we <= '0'; -- Desactivar escritura
    r_dir <= (others => '1');
    d <= "00001111"; -- no debería almacenarse en la dirección w_dir anterior
    wait until falling_edge(clk);

    -- Leer la tercera dirección
    -- (la escritura no está activada)
    r_dir <= "10";
    wait until falling_edge(clk);

    -- Sobrescribir y leer la memoria completa
    for i in 0 to 2**DIR_ANCHO-1 loop

      we <= '1'; -- Escritura activada
      w_dir <= std_logic_vector(to_unsigned(i, DIR_ANCHO));
      d <= std_logic_vector(to_unsigned(i+8, DATOS_ANCHO));

      r_dir <= std_logic_vector(to_unsigned(i, DIR_ANCHO));
      wait until falling_edge(clk);

    end loop;

    -- Leer toda la memoria
    for i in 0 to 2**DIR_ANCHO-1 loop

      we <= '0'; -- Escritura desactivada
      r_dir <= std_logic_vector(to_unsigned(i, DIR_ANCHO));

      -- En w_dir no debería almacenarse d
      w_dir <= std_logic_vector(to_unsigned(i, DIR_ANCHO));
      d <= std_logic_vector(to_unsigned(i+4, DATOS_ANCHO));
      wait until falling_edge(clk);

    end loop;

    -- ===================
    -- Terminar simulación
    -- ===================
    assert false
      report "Simulación Completada"
    severity failure;

   end process;

end arq_bp;
