
library ieee;
use ieee.std_logic_1164.all;

-- Radix-4 Booth multiplier entity
entity RX4BOOTHMULT is
	generic(
		OP	: natural := 8
	);
	port(
		A : in	std_logic_vector(OP-1 downto 0);
		B : in	std_logic_vector(OP-1 downto 0);
		P : out	std_logic_vector(2*OP-1 downto 0)
	);	
end RX4BOOTHMULT;

-- Radix-4 Booth multiplier architecture
architecture STRUCT of RX4BOOTHMULT is
	component RCA is
		generic(
			N : natural
		);
		port(
			X		: in	std_logic_vector(N-1 downto 0);
			Y		: in	std_logic_vector(N-1 downto 0);
			CIN	: in	std_logic;
			S		: out	std_logic_vector(N-1 downto 0);
			COUT	: out	std_logic
		);
	end component;
	component MBED is
		port(
			X	: in	std_logic_vector(1 downto 0);
			Y	: in	std_logic_vector(2 downto 0);
			PP	: out	std_logic
		);
	end component;
	
	-- Number of partial products
	constant PPN		: natural := OP/2;
	-- Intermediate adders' width
	constant ADDERW	: natural := OP+4;
	
	-- Modified multiplicand input for Booth decoding
	signal MA	: std_logic_vector(OP+1 downto 0);
	-- Modified multiplier input for Booth encoding
	signal MB	: std_logic_vector(OP downto 0);
	-- Partial products outputs for Booth encoding/decoding
	type PPS_ARRAY is array(PPN-1 downto 0) of std_logic_vector(OP downto 0);
	signal PPS	: PPS_ARRAY;
	-- Adders' inputs
	type AI_ARRAY is array(PPN-2 downto 0) of std_logic_vector(ADDERW-1 downto 0);
	signal AXS	: AI_ARRAY;
	signal AYS	: AI_ARRAY;
	-- Adders' input carries
	signal ACS	: std_logic_vector(PPN-1 downto 0);
	-- Intermediate adders' sums
	type AS_ARRAY is array(PPN-2 downto 0) of std_logic_vector(ADDERW downto 0);
	signal AS	: AS_ARRAY;
begin
	--------------------------------------------------------------------------------------------------------------------------------

	-- Booth encoding/decoding network generation
	MBEDGEN : for I in 0 to (PPN*(OP+1))-1 generate
		ED : MBED port map(
			X	=> MA((I mod (OP+1))+1 downto (I mod (OP+1))),
			Y	=> MB((I/(OP+1))*2+2 downto (I/(OP+1))*2),
			PP	=> PPS(I/(OP+1))(I mod (OP+1))
		);
	end generate;
	-- MBEDGEN signals
	-- Duplicate last multiplicand bit for sign correction and pad LSB with 0
	MA(OP+1 downto 0)	<= A(OP-1) & A & '0';
	-- Pad multiplier LSB with 0 (for radix 4 grouping)
	MB(OP downto 0)	<= B & '0';
	
	--------------------------------------------------------------------------------------------------------------------------------
	
	-- First peculiar adder
	FIRSTADDER : RCA generic map(OP+4)
		port map(
			X		=> AXS(0),
			Y		=> AYS(0),
			CIN	=> ACS(0),
			-- Sum goes at the start of intermediate sum
			S		=> AS(0)(ADDERW-1 downto 0),
			-- Output carry goes next in intermediate sum
			COUT	=> AS(0)(ADDERW)
		);
	-- FIRSTADDER signals
	-- 0 on last FA, negate sign correction bit, copy sign correction bit, add first PP
	AXS(0) <= "0" & not PPS(0)(OP) & PPS(0)(OP) & PPS(0)(OP downto 0);
	-- 1 on last FA, negate sign correction bit, add second PP, pad 2 LSBs with zeros
	AYS(0) <= "1" & not PPS(1)(OP) & PPS(1)(OP-1 downto 0) & "00";
	-- Add 2's complement bit if grouping identifies negative (but not for adding 0)
	ACS(0) <= MB(2) and (MB(1) nand MB(0));
	-- 2 LSBs of sum already goes into output product
	P(1 downto 0) <= AS(0)(1 downto 0);
	
	--------------------------------------------------------------------------------------------------------------------------------
	
	-- Subsequent adders generation
	ADDERGEN : for I in 1 to PPN-2 generate
		ADDER : RCA generic map(OP+4)
		port map(
			X		=> AXS(I),
			Y		=>	AYS(I),
			CIN	=> ACS(I),
			-- Sum goes at the start of intermediate sum
			S		=> AS(I)(ADDERW-1 downto 0),
			-- Output carry goes next in intermediate sum
			COUT	=> AS(I)(ADDERW)
		);		
		-- ADDERGEN signals
		-- 1 on last FA, negate sign correction bit, add PP, pad 2 LSBs with zeros
		AXS(I) <= "0" & not PPS(I+1)(OP) & PPS(I+1)(OP-1 downto 0) & "00";
		-- Previous intermediate sum
		AYS(I) <= "1" & AS(I-1)(ADDERW downto 2);
		-- Add 2's complement bit if grouping identifies negative (but not for adding 0)
		ACS(I) <= MB(I*2+2) and (MB(I*2+1) nand MB(I*2));
		-- 2 LSBs of sum already goes into output product
		P((I*2+1) downto (I*2)) <= AS(I)(1 downto 0);
	end generate;
	
	--------------------------------------------------------------------------------------------------------------------------------
	
	-- Last adder for carry propagation
	LASTADDER : RCA generic map(OP+2)
		port map(
			X		=> AS(PPN-2)(ADDERW-1 downto 2),
			Y		=> (OP+1 downto 0 => '0'),
			CIN	=> ACS(PPN-1),
			-- Sum goes into output product
			S		=> P(OP*2-1 downto OP-2),
			-- Discard output carry
			COUT	=> open
		);
	-- LASTADDER signals
	-- Add 2's complement bit if grouping identifies negative (but not for adding 0)
	ACS(PPN-1) <= MB(OP) and (MB(OP-1) nand MB(OP-2));
	
	--------------------------------------------------------------------------------------------------------------------------------
end STRUCT;