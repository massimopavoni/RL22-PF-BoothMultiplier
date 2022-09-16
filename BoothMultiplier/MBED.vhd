
library ieee;
use ieee.std_logic_1164.all;

-- Modified Booth encoder decoder entity
entity MBED is
	port(
		X	: in	std_logic_vector(1 downto 0);
		Y	: in	std_logic_vector(2 downto 0);
		PP	: out	std_logic
	);
end MBED;

-- Modified Booth encoder decoder architecture
architecture RTL of MBED is
begin
	PP <= '0'		when Y = "000" or Y = "111" else 
			X(1)		when Y = "001" or Y = "010" else 
			not X(1)	when Y = "101" or Y = "110" else 
			X(0)		when Y = "011" else 
			not X(0);
end RTL;