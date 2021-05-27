library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
USE WORK.types.ALL;


--definition of "Gestion_dialogue" entity
--Definition of an entity to manage the control signals
ENTITY Gestion_dialogue IS
	PORT (A0, CS : IN std_logic;
			RD, WR : IN Boolean; 
			d_buf_out : IN hexa;
			
			d_buf_in : OUT hexa;
			s_out : OUT std_logic;
			Latch_d, charge_d : OUT boolean;
			D : INOUT byte);
END Gestion_dialogue;
	
	
--architecture gestion_dialogue	
ARCHITECTURE behavior_dialogue OF Gestion_dialogue IS

--definition of the internal signals
SIGNAL RW_op : Poids;
SIGNAL Etat_r : Etat;
SIGNAL Etat_w : Etat;

BEGIN	

	PROCESS (CS) 
	BEGIN
 
		IF (CS = '1') THEN
		
			--Conditions to satisfy a command to process a control command
			--reception controle
			IF(WR = true AND RD = false AND A0 = '1') THEN 
			
				IF(Poids'val(to_integer(unsigned(D(5 downto 4)))) = Latch) THEN
					Latch_d <= true;
				ELSE 							--test MSB
					RW_op <= Poids'val(to_integer(unsigned(D(5 downto 4))));
					Latch_d <= false;
					s_out <= '0';
					IF (Poids'val(to_integer(unsigned(D(5 downto 4)))) = Most) THEN
						Etat_r <= M;
						Etat_w <= M;
					ELSE
						Etat_r <= L;
						Etat_w <= L;
					END IF;
				END IF;
			
			--Conditions to satisfy a command to receive data in buffer_in from D
			--reception data
			ELSIF (WR = true AND RD = false AND A0 = '0') THEN 
				
				s_out <= '0';
				
				IF (Etat_w = L) THEN
					d_buf_in (7 downto 0) <= D;
					IF (RW_op = LeastMost) THEN 
						Etat_w <= M;
					ELSIF(RW_op = Least) THEN
						d_buf_in (15 downto 8) <= "00000000";
						charge_d <= true;
					END IF;
				
				ELSIF (Etat_w = M) THEN
					d_buf_in (15 downto 8) <= D;
					IF (RW_op = LeastMost) THEN
						Etat_w <= L;
						charge_d <= true;
					ELSIF (RW_op = Most) THEN
						d_buf_in (7 downto 0) <= "00000000";
						charge_d <= true;
					END IF;
				END IF;
		
			--Conditions to satisfy a command to send the data stored in buffer_out to D
			--envoi data
			ELSIF (WR = false AND RD = true AND A0 = '0') THEN 
				IF (Etat_r = L) THEN
					D <= d_buf_out (7 downto 0);
					IF (RW_op = LeastMost) THEN
						Etat_r <= M;
					ELSIF (RW_op = Least) THEN
						Latch_d <= false;
					END IF;
					
					
				ELSIF (Etat_r = M) THEN
					D <= d_buf_out (15 downto 8);
					IF (RW_op = LeastMost) THEN
						Etat_r <= L;
						Latch_d <= false;
					ELSIF (RW_op = Most) THEN
						Latch_d <= false;
					END IF;
				END IF;
			END IF;
		else
			latch_d <= true;
			charge_d <= false;
			--Put in High impedance mode when IT isn't on control command
			D <= "ZZZZZZZZ";
		END IF;
	END PROCESS;
	
END behavior_dialogue;