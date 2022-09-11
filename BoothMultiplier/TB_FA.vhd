
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
 
entity TB_FA is
end TB_FA;
 
architecture BEHAVIOR of TB_FA is
	-- Component Declaration for the Unit Under Test (UUT)
	component FA	 
		port(
			X		: in	std_logic;
			Y		: in	std_logic;
			CIN	: in	std_logic;
			S		: out	std_logic;
			COUT	: out	std_logic
		);				
	end component;

   -- Inputs
	signal X		: std_logic;
	signal Y		: std_logic;
	signal CIN	: std_logic;

 	-- Outputs
	signal S		: std_logic;
	signal COUT : std_logic;
	
	-- Simulation files
	file FILE_IN		: text;
	file FILE_SIM	: text;
 
begin 
	-- Instantiate the Unit Under Test (UUT)
   UUT: FA port map (
		X		=> X,
		Y		=> Y,
		CIN	=> CIN,
		S		=> S,
		COUT	=> COUT
	); 

   -- Stimulus process
   STIM_PROC: process
		variable LINE_IN		: line;
		variable LINE_OUT		: line;
		variable CHR_SPACE	: character;
		variable X_IN			: std_logic;
		variable Y_IN			: std_logic;
		variable CIN_IN		: std_logic;
		
   begin
		file_open(FILE_IN, "test_gen/fa_in.txt", read_mode);
		file_open(FILE_SIM, "test_gen/fa_sim.txt", write_mode);
		
		while not endfile(FILE_IN) loop
			readline(FILE_IN, LINE_IN);
			read(LINE_IN, X_IN);
			read(LINE_IN, CHR_SPACE);
			read(LINE_IN, Y_IN);
			read(LINE_IN, CHR_SPACE);
			read(LINE_IN, CIN_IN);
			
			X		<= X_IN;
			Y		<= Y_IN;
			CIN	<= CIN_IN;
			
			wait for 10ns;
			
			write(LINE_OUT, S, left, 2);
			write(LINE_OUT, COUT, left, 1);
			writeline(FILE_SIM, LINE_OUT);
		end loop;
		
		file_close(FILE_IN);
		file_close(FILE_SIM);
		
		wait;
   end process;
end;
