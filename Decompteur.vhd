library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
USE WORK.types.ALL;


--definition of the entity Decompteur

ENTITY Decompteur IS
	PORT (CLK : IN std_logic;
			charge_d_in : IN boolean;
			gate : IN boolean;
			d_buf_in : IN hexa;
			count_val : OUT hexa;
			charge_d_out: OUT boolean;
			s_out : OUT std_logic
			);
END Decompteur;


--architecture decompteur
--Manage the decounter for each rising edge clock
--If the decounter reaches 0, then output goes to 1
ARCHITECTURE behavior_decompteur OF Decompteur IS
SIGNAL compteur : unsigned(15 downto 0);

BEGIN
	PROCESS(CLK)
	BEGIN
		IF (rising_edge(CLK)) THEN				
			IF(charge_d_in = false) THEN
				charge_d_out <= true;
				IF (gate = true) THEN
					compteur <= compteur - 1;
					IF (compteur = 0) THEN		
						s_out <= '1';
					END IF;
				END IF;
			ELSE 										
				compteur <= unsigned(d_buf_in);
				charge_d_out <= false;
			END IF;
		END IF;		
	
	END PROCESS;
	count_val <= hexa(compteur);
END behavior_decompteur;
	