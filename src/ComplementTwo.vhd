----------------------------------------------------------------------------------
-- Module Name:    	SwapN
-- Project Name: 		32 bit floating point adder
-- Description: 		Swap two n-bit values according to a control signal
--							(0 = don't swap, 1 = swap)
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ComplementTwo is
	generic ( n : integer);							-- Data size
	port (
		x	: in 	std_logic_vector(0 to n-1);	-- Input data
		y	: out	std_logic_vector(0 to n-1)		-- Output data
	);
end SwapN;

architecture Behavioral of ComplementTwo is
begin
	
end Behavioral;