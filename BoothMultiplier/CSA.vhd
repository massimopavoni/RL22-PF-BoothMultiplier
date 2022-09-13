
library ieee;
use ieee.std_logic_1164.all;

-- Carry-save adder entity
entity CSA is
	generic(
		N : natural := 16
	);
	port(
		X : in	std_logic_vector(N-1 downto 0);
		Y : in	std_logic_vector(N-1 downto 0);
		Z : in	std_logic_vector(N-1 downto 0);
		A : out	std_logic_vector(N-1 downto 0);
		B : out	std_logic_vector(N-1 downto 0)
	);	
end CSA;

-- Carry-save adder architecture
architecture STRUCT of CSA is
	component FA is
		port(
			X		: in	std_logic;
			Y		: in	std_logic;
			CIN	: in	std_logic;
			S		: out	std_logic;
			COUT	: out	std_logic
		);
	end component;
	
begin
	GEN: for I in 0 to N-1 generate
		U : FA port map(
			X		=> X(I),
			Y		=> Y(I),
			CIN	=> Z(I),
			S		=> A(I),
			COUT	=> B(I)
		);
	end generate;
end STRUCT;