----------------------------------------------------------------------------------
-- Module Name:    	RightExtender
-- Project Name: 		32 bit floating point adder
-- Description: 		extends an input n-bit vector to an output s-bit vector
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;

entity RightExtender is
	generic (
		n 	: 	integer;					-- Input vector size
		s 	:	integer					-- Output vector size
	);					
	port (
		x	: in 	std_logic_vector(0 to n-1);	-- Input data
		y	: out	std_logic_vector(0 to s-1)		-- Output data
	);
end RightExtender;

architecture Behavioral of RightExtender is

	constant zero : std_logic_vector(0 to s-1) := (others => '0');
	
begin

	y <= x(0 to n-1) & zero(0 to s-n-1);
	
end Behavioral;