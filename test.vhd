library IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE WORK.types.ALL;


--definition du testbench


ENTITY test IS

END test;


ARCHITECTURE behavior_test OF test IS

	COMPONENT description_timer
		PORT (CLK, A0, CS : IN std_logic;
				RD, WR, gate : IN Boolean;
				sortie : OUT std_logic;
				D : INOUT byte);
	END COMPONENT;

	SIGNAL test_D : std_logic_vector(7 downto 0);
	SIGNAL test_A0, test_CS, test_clk, test_sortie : std_logic;
	SIGNAL test_RD, test_WR, test_gate : boolean;

BEGIN

timer : description_timer PORT MAP(test_clk, test_A0, test_CS, test_RD, test_WR, test_gate, test_sortie, test_D);



-- Generateur d'horloge 


	clock_generator : PROCESS
		
	BEGIN

		test_clk <= '0';
		WAIT FOR 50 ns;
		test_clk <= '1';
		WAIT FOR 50 ns;

	END PROCESS clock_generator;


-- Gestion CS

	test_CS <= '0', '1' after 200 ns, '0' after 220 ns, -- control LSB
		       '1' after 400 ns, '0' after 420 ns,	-- writing LSB
		       '1' after 460 ns, '0' after 480 ns,	
		       '1' after 600 ns, '0' after 620 ns,	-- reading LSB

		       '1' after 1000 ns, '0' after 1020 ns,	-- control MSB
		       '1' after 1200 ns, '0' after 1220 ns, 	-- writing MSB
		       '1' after 1400 ns, '0' after 1420 ns, 	-- reading MSB
		      
		       '1' after 1800 ns, '0' after 1820 ns, 	-- control LSB+MSB
		       '1' after 2000 ns, '0' after 2020 ns,	-- writing LSB
		       '1' after 2200 ns, '0' after 2220 ns,	-- writing MSB
		       '1' after 2400 ns, '0' after 2420 ns,	-- reading LSB
		       '1' after 2500 ns, '0' after 2520 ns;	-- reading MSB

	test_RD <= FALSE, 
		       TRUE after 500 ns,

		       FALSE after 900 ns,
		       TRUE after 1300 ns,

		       FALSE after 1700 ns, 
		       TRUE after 2300 ns;

	test_WR <= FALSE, TRUE after 100 ns,
		       FALSE after 500 ns,

		       TRUE after 900 ns,
		       FALSE after 1300 ns,

		       TRUE after 1700 ns,
		       FALSE after 2300 ns; 

	test_A0 <= '0', '1' after 100 ns, 
		       '0' after 300 ns, 
		       '1' after 450 ns,
		       '0' after 500 ns,

		       '1' after 900 ns,
		       '0' after 1100 ns, 
		       
		       '1' after 1700 ns,
		       '0' after 1900 ns;

	test_D <= "00010000", 		--control LSB
		      "10101010" after 300 ns,	-- data
		      "00000000" after 450 ns, 
		      "ZZZZZZZZ" after 480 ns,

		       "00100000" after 900 ns,	-- control MSB
		       "01010101" after 1100 ns,-- data
		       "ZZZZZZZZ" after 1220 ns,

		       "00110000" after 1700 ns,-- control LSB+MSB
		       "00001111" after 1900 ns,-- data LSB
		       "11110000" after 2100 ns,-- data MSB
		       "ZZZZZZZZ" after 2220 ns;

	test_gate <= FALSE;

end behavior_test;


