
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
 
entity TB_RX4BOOTHMULT is
end TB_RX4BOOTHMULT;
 
architecture BEHAVIOR of TB_RX4BOOTHMULT is	
	constant OP : natural := 8;
	
	-- Component Declaration for the Unit Under Test (UUT)
	component RX4BOOTHMULT
		port(
			A : in	std_logic_vector(OP-1 downto 0);
			B : in	std_logic_vector(OP-1 downto 0);
			P : out	std_logic_vector(2*OP-1 downto 0)
		);			
	end component;

   -- Inputs
	signal A : std_logic_vector(OP-1 downto 0);
	signal B : std_logic_vector(OP-1 downto 0);

 	-- Outputs
	signal P : std_logic_vector(2*OP-1 downto 0);
	
	-- Simulation files
	file FILE_IN		: text;
	file FILE_SIM	: text;
 
begin 
	-- Instantiate the Unit Under Test (UUT)
   UUT: TB_RX4BOOTHMULT port map (
		A => A,
		B => B,
		P => P
	); 

   -- Stimulus process
   STIM_PROC: process
		variable LINE_IN		: line;
		variable LINE_OUT		: line;
		variable CHR_SPACE	: character;
		variable A_IN			: std_logic_vector(OP-1 downto 0);
		variable B_IN			: std_logic_vector(OP-1 downto 0);
		
   begin
		file_open(FILE_IN, "test_gen/rx4boothmult_in.txt", read_mode);
		file_open(FILE_SIM, "test_gen/rx4boothmult_sim.txt", write_mode);
		
		while not endfile(FILE_IN) loop
			readline(FILE_IN, LINE_IN);
			read(LINE_IN, A_IN);
			read(LINE_IN, CHR_SPACE);
			read(LINE_IN, B_IN);
			
			A <= A_IN;
			B <= B_IN;
			
			wait for 35ns;
			
			write(LINE_OUT, P, left, 16);
			writeline(FILE_SIM, LINE_OUT);
		end loop;
		
		file_close(FILE_IN);
		file_close(FILE_SIM);
		
		wait;
   end process;
end;
