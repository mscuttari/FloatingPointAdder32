----------------------------------------------------------------------------------
-- Module Name:    	RightShifter
-- Project Name: 		32 bit floating point adder
-- Description: 		s positions right shifter of a n-bit input
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity RightShifter is
	generic (
		n 	: 	integer;					-- Data size. Default: 23 (mantissa size)
		s 	:	integer					-- Shift amount. Default: 1
	);					
	port (
		x	: in 	std_logic_vector(0 to n-1);	-- Input data
		y	: out	std_logic_vector(0 to n-1)		-- Output data
	);
end RightShifter;

architecture Behavioral of RightShifter is
	signal zero : std_logic_vector(0 to n-1) := (others => '0');
begin
	y <= zero(0 to s-1) & x(0 to n-s-1);
end Behavioral;

