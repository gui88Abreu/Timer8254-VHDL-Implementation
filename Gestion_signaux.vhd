library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
USE WORK.types.ALL;


--In the diagram we can see that the signals "charge_d" and "out" 
--can be accessed by more than one component in a writting process.
--So here, we define an entity to manage these signal in order to solve
--the double writting concurrence.

ENTITY Gestion_signaux IS
	PORT(s_out_decompteur : IN std_logic;
			s_out_dialogue : IN std_logic;
			charge_d_decompteur : IN boolean;
			charge_d_dialogue : IN boolean;
			sortie : OUT std_logic;
			charge_d_final : OUT boolean);
			
END Gestion_signaux;

--Definition of an architecture to manage the signals that can have a double write concurrence
ARCHITECTURE behavior_gestion_signaux OF Gestion_signaux IS

BEGIN

	PROCESS(s_out_decompteur, s_out_dialogue, charge_d_decompteur, charge_d_dialogue)
	BEGIN
	
	--The component "Gestion_dialogue" have higher priority over "Decompteur"
	--when we are writting over "charge_d"
	charge_d_final <= charge_d_dialogue and charge_d_decompteur;
	
	--The component "Decompteur" have higher priority over "Dialogue"
	--when we are writting over "out"
	IF (s_out_decompteur = '1') THEN --priorite au decompteur
		sortie <= '1';
	ELSE
		sortie <= s_out_dialogue;
	END IF;
	
	END PROCESS;
	
END behavior_gestion_signaux;
			