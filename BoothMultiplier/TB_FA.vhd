
library ieee;
use ieee.std_logic_1164.all;
 
entity TB_FA is
end TB_FA;
 
architecture behavior of TB_FA is
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
	signal S : std_logic;
	signal COUT : std_logic;
 
begin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FA port map (
		X => X,
		Y => Y,
		CIN => CIN,
		S => S,
		COUT => COUT
		); 

   -- Stimulus process
   stim_proc: process
   begin
   end process;
end;
