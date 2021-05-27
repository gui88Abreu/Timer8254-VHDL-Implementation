library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;


--definition des types byte, hexa, poids et etat

PACKAGE types IS
	SUBTYPE byte is std_logic_vector(7 DOWNTO 0);
	SUBTYPE hexa is std_logic_vector(15 downto 0);
	TYPE Poids is (Latch, Least, Most, LeastMost);
	TYPE Etat is (L,M);
END types;


library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
USE WORK.types.ALL;



--definition of the entity of the timer
--Here we just link the components defined in the other files
ENTITY timer IS
	PORT (CLK, A0, CS : IN std_logic;
			RD, WR, gate : IN Boolean;
			sortie : OUT std_logic;
			D : INOUT byte);
END timer;



--Architecture of the timer
ARCHITECTURE behavior_timer OF timer IS

--Definition of each component used to manage the timer
COMPONENT Gestion_buffer
	PORT(Latch_d : IN boolean;
			count_val :  IN hexa;
			d_buf_out : OUT hexa
				);
END COMPONENT;

COMPONENT Decompteur
	PORT (CLK : IN std_logic;
			charge_d_in : IN boolean;
			gate : IN boolean;
			d_buf_in : IN hexa;
			count_val : OUT hexa;
			charge_d_out: OUT boolean;
			s_out : OUT std_logic
			);
END COMPONENT;

COMPONENT Gestion_dialogue
	PORT (A0, CS : IN std_logic;
			RD, WR : IN Boolean;
			d_buf_out : IN hexa;
			d_buf_in : OUT hexa;
			s_out : OUT std_logic;
			Latch_d, charge_d : OUT boolean;
			D : INOUT byte);
END COMPONENT;


COMPONENT Gestion_signaux
	PORT(s_out_decompteur, s_out_dialogue : IN std_logic;
			charge_d_decompteur, charge_d_dialogue : IN boolean;
			sortie : OUT std_logic;
			charge_d_final : OUT boolean);
END COMPONENT;



--Definition of the internal signals to link the components
SIGNAL d_buf_in_temp,
		d_buf_out_temp : hexa;
		
SIGNAL charge_d_decompteur_temp,
		charge_d_dialogue_temp,
		charge_d_temp, 
		latch_d_temp : boolean;
		
SIGNAL s_out_decompteur_temp, s_out_dialogue_temp : std_logic;
		
SIGNAL count_val_decompteur_temp : hexa;


BEGIN

--Here we link every input and output of each component as specified in the diagram of the project
Decompteur_timer : Decompteur PORT MAP (CLK,
													charge_d_temp,
													gate, d_buf_in_temp,
													count_val_decompteur_temp,
													charge_d_decompteur_temp,
													s_out_decompteur_temp);

Gestion_buffer_timer : Gestion_buffer PORT MAP(latch_d_temp, 
																count_val_decompteur_temp, 
																d_buf_out_temp);
																
													
Gestion_dialogue_timer : Gestion_dialogue PORT MAP(A0, CS,
																	RD, WR,
																	d_buf_out_temp,
																	d_buf_in_temp,
																	s_out_dialogue_temp,
																	latch_d_temp,
																	charge_d_dialogue_temp,
																	D); 
																	
Gestion_signaux_timer : Gestion_signaux PORT MAP(s_out_decompteur_temp, s_out_dialogue_temp,
																charge_d_decompteur_temp, charge_d_dialogue_temp, 
																sortie,
																charge_d_temp);


END behavior_timer;
