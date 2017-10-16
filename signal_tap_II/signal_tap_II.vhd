-- ******************************************
-- * Circuito de ejemplo para Signal Tap II *
-- ******************************************
-- Conecta 2 botones, cuyo estado se almacena en un registro en el flanco de 
-- subida del reloj, a 2 LEDs.

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY signal_tap_II IS

   PORT(
      CLOCK_50 : IN  STD_LOGIC;  -- Reloj 50 MHz
      KEY      : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);  -- Botones
      LED      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)   -- LEDs
   );
   
END signal_tap_II;

ARCHITECTURE arq OF signal_tap_II IS
BEGIN

   PROCESS (CLOCK_50) BEGIN
   
      IF(RISING_EDGE(CLOCK_50)) THEN
         LED <= KEY;
      END IF;
      
   END PROCESS;

END arq;