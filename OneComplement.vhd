----------------------------------------------------------------------------------
-- Module Name:    	OneComplement
-- Project Name: 		32 bit floating point adder
-- Description: 		One complement of a n-bit value
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity OneComplement is
	generic ( n : integer);							-- Data size
	port (
		x	: in 	std_logic_vector(0 to n-1);	-- Input data
		y	: out	std_logic_vector(0 to n-1)		-- Output data
	);
end SwapN;

architecture Behavioral of OneComplement is
begin
	y <= not x;
end Behavioral;