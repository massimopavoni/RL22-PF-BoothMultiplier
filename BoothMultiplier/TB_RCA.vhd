
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
 
entity TB_RCA is
end TB_RCA;
 
architecture BEHAVIOR of TB_RCA is	
	constant N : natural := 16;
	
	-- Component Declaration for the Unit Under Test (UUT)
	component RCA
		port(
			X		: in	std_logic_vector(N-1 downto 0);
			Y		: in	std_logic_vector(N-1 downto 0);
			CIN	: in	std_logic;
			S		: out	std_logic_vector(N-1 downto 0);
			COUT	: out	std_logic
		);				
	end component;

   -- Inputs
	signal X		: std_logic_vector(N-1 downto 0);
	signal Y		: std_logic_vector(N-1 downto 0);
	signal CIN	: std_logic;

 	-- Outputs
	signal S		: std_logic_vector(N-1 downto 0);
	signal COUT : std_logic;
	
	-- Simulation files
	file FILE_IN		: text;
	file FILE_SIM	: text;
 
begin 
	-- Instantiate the Unit Under Test (UUT)
   UUT: RCA port map (
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
		variable X_IN			: std_logic_vector(N-1 downto 0);
		variable Y_IN			: std_logic_vector(N-1 downto 0);
		
   begin
		file_open(FILE_IN, "test_gen/rca_in.txt", read_mode);
		file_open(FILE_SIM, "test_gen/rca_sim.txt", write_mode);
		
		CIN <= '0';
		
		while not endfile(FILE_IN) loop
			readline(FILE_IN, LINE_IN);
			read(LINE_IN, X_IN);
			read(LINE_IN, CHR_SPACE);
			read(LINE_IN, Y_IN);
			
			X <= X_IN;
			Y <= Y_IN;
			
			wait for 30ns;
			
			write(LINE_OUT, S, left, 16);
			writeline(FILE_SIM, LINE_OUT);
		end loop;
		
		file_close(FILE_IN);
		file_close(FILE_SIM);
		
		wait;
   end process;
end;
