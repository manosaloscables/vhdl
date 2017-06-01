-- *************************
-- Circuitos combinacionales
-- *************************

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY comb_circuits IS 
	PORT
	(
		e1:  IN   STD_LOGIC;
		e2:  IN   STD_LOGIC;
      ig:  OUT  STD_LOGIC;
      
		a1:     IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
		b1:     IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
      aigb1:  OUT  STD_LOGIC;
      
      a2:     IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
		b2:     IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
      aigb2:  OUT  STD_LOGIC
		
	);
END comb_circuits;

ARCHITECTURE arq_est OF comb_circuits IS
BEGIN
   unidad_ig1_1: entity work.ig1(arq_sdp)
      port map(
         e1=>e1,
         e2=>e2,
         ig=>ig
      );
      
   uni_ig2_1: entity work.ig2(arq_sdp)  -- Arquitectura de suma de productos
      port map(
         a=>a1,
         b=>b1,
         aigb=>aigb1
      );

   uni_ig2_2: entity work.ig2(arq_est) -- Arquitectura estructural
      port map(
         a=>a2,
         b=>b2,
         aigb=>aigb2
      );

END arq_est;