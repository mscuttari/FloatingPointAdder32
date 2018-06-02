----------------------------------------------------------------------------------
-- Module Name:    	RippleCarryAdder
-- Project Name: 		32 bit floating point adder
-- Description: 		1-bit ripple carry adder
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity RippleCarryAdder is
	port (
		x, y	: in	std_logic;			-- Operands
		c0		: in 	std_logic;			-- Input carry
		s		: out std_logic;			-- Result
		c1		: out	std_logic			-- Output carry
	);
end RippleCarryAdder;

architecture Behavioral of RippleCarryAdder is
begin
	s <= x xor y xor c0;
	c1 <= (x and y) or (x and c0) or (y and c0);
end Behavioral;