----------------------------------------------------------------------------------
-- Module Name:    	HalfAdder
-- Project Name: 		32 bit floating point adder
-- Description: 		1-bit half adder
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity HalfAdder is
	port (
		x, y	: in	std_logic;			-- Operands
		s		: out std_logic;			-- Result
		c1		: out	std_logic			-- Output carry
	);
end HalfAdder;

architecture Behavioral of HalfAdder is

begin

	s <= x xor y;
	c1 <= (x and y);
	
end Behavioral;