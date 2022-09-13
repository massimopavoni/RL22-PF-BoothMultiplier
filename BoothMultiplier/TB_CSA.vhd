
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
 
entity TB_CSA is
end TB_CSA;
 
architecture BEHAVIOR of TB_CSA is	
	constant N : natural := 16;
	
	-- Component Declaration for the Unit Under Test (UUT)
	component CSA
		port(
			X : in	std_logic_vector(N-1 downto 0);
			Y : in	std_logic_vector(N-1 downto 0);
			Z : in	std_logic_vector(N-1 downto 0);
			A : out	std_logic_vector(N-1 downto 0);
			B : out	std_logic_vector(N-1 downto 0)
		);				
	end component;

   -- Inputs
	signal X	: std_logic_vector(N-1 downto 0);
	signal Y	: std_logic_vector(N-1 downto 0);
	signal Z	: std_logic_vector(N-1 downto 0);

 	-- Outputs
	signal A	: std_logic_vector(N-1 downto 0);
	signal B : std_logic_vector(N-1 downto 0);
	
	-- Simulation files
	file FILE_IN		: text;
	file FILE_SIM	: text;
 
begin 
	-- Instantiate the Unit Under Test (UUT)
   UUT: CSA port map (
		X => X,
		Y => Y,
		Z => Z,
		A => A,
		B => B
	); 

   -- Stimulus process
   STIM_PROC: process
		variable LINE_IN		: line;
		variable LINE_OUT		: line;
		variable CHR_SPACE	: character;
		variable X_IN			: std_logic_vector(N-1 downto 0);
		variable Y_IN			: std_logic_vector(N-1 downto 0);
		variable Z_IN			: std_logic_vector(N-1 downto 0);
		
   begin
		file_open(FILE_IN, "test_gen/csa_in.txt", read_mode);
		file_open(FILE_SIM, "test_gen/csa_sim.txt", write_mode);
		
		while not endfile(FILE_IN) loop
			readline(FILE_IN, LINE_IN);
			read(LINE_IN, X_IN);
			read(LINE_IN, CHR_SPACE);
			read(LINE_IN, Y_IN);
			read(LINE_IN, CHR_SPACE);
			read(LINE_IN, Z_IN);
			
			X <= X_IN;
			Y <= Y_IN;
			Z <= Z_IN;
			
			wait for 10ns;
			
			write(LINE_OUT, A, left, 17);
			write(LINE_OUT, B, left, 16);
			writeline(FILE_SIM, LINE_OUT);
		end loop;
		
		file_close(FILE_IN);
		file_close(FILE_SIM);
		
		wait;
   end process;
end;
