
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
 
entity TB_MBED is
end TB_MBED;
 
architecture BEHAVIOR of TB_MBED is
	-- Component Declaration for the Unit Under Test (UUT)
	component MBED	 
		port(
			X	: in	std_logic_vector(1 downto 0);
			Y	: in	std_logic_vector(2 downto 0);
			PP	: out	std_logic
		);				
	end component;

   -- Inputs
	signal X		: std_logic_vector(1 downto 0);
	signal Y		: std_logic_vector(2 downto 0);

 	-- Outputs
	signal PP	: std_logic;
	
	-- Simulation files
	file FILE_IN		: text;
	file FILE_SIM	: text;
 
begin 
	-- Instantiate the Unit Under Test (UUT)
   UUT: MBED port map (
		X	=> X,
		Y	=> Y,
		PP	=> PP
	); 

   -- Stimulus process
   STIM_PROC: process
		variable LINE_IN		: line;
		variable LINE_OUT		: line;
		variable CHR_SPACE	: character;
		variable X_IN			: std_logic_vector(1 downto 0);
		variable Y_IN			: std_logic_vector(2 downto 0);
		
   begin
		file_open(FILE_IN, "test_gen/mbed_in.txt", read_mode);
		file_open(FILE_SIM, "test_gen/mbed_sim.txt", write_mode);
		
		while not endfile(FILE_IN) loop
			readline(FILE_IN, LINE_IN);
			read(LINE_IN, X_IN);
			read(LINE_IN, CHR_SPACE);
			read(LINE_IN, Y_IN);
			
			X <= X_IN;
			Y <= Y_IN;
			
			wait for 10ns;
			
			write(LINE_OUT, PP, left, 1);
			writeline(FILE_SIM, LINE_OUT);
		end loop;
		
		file_close(FILE_IN);
		file_close(FILE_SIM);
		
		wait;
   end process;
end;
