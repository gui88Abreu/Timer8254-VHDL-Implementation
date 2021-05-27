library ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
USE WORK.types.ALL;


--definition of the entity Gestion_buffer
--Here we manage the storage of count_val in buffer_out
ENTITY Gestion_buffer IS
		PORT(Latch_d : IN boolean;
				count_val :  IN hexa;
				d_buf_out : OUT hexa
				);
END Gestion_buffer;

--architecture of gestion_buffer
ARCHITECTURE behavior_buffer OF Gestion_buffer IS
BEGIN
	
	PROCESS(Latch_d)
	BEGIN	

		IF (Latch_d = FALSE) THEN
			d_buf_out <= count_val;
		END IF;
	
	END PROCESS;
	
END behavior_buffer;

