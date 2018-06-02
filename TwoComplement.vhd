----------------------------------------------------------------------------------
-- Module Name:    	TwoComplement
-- Project Name: 		32 bit floating point adder
-- Description: 		Two complement of a n-bit value
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TwoComplement is
	generic ( n : integer);										-- Data size
	port (
		x			: 	in 	std_logic_vector(0 to n-1);	-- Input data
		y			: 	out	std_logic_vector(0 to n-1);	-- Output data
		overflow	:	out	std_logic							-- Overflow signal
	);
end TwoComplement;

architecture Behavioral of TwoComplement is

	component RippleCarryAdder
		generic ( n : integer );
		port (
			x, y 		: in  	std_logic_vector(0 to n-1);
			s			: out		std_logic_vector(0 to n-1);
			overflow	: out		std_logic
		);
	end component;
	
	signal one 	: std_logic_vector(0 to n-1) := (others => '0');

begin
	-- Create signal with value 1
	one <= one(0 to n-2) & '1';
	
	-- Add 1 to the one complement to get the two complement
	adder: RippleCarryAdder
		generic map(
			n => n
		)
		port map (
         x => not x,
			y => one,
			s => y,
			overflow => overflow
		);
	
end Behavioral;