----------------------------------------------------------------------------------
-- Module Name:    	SwapN
-- Project Name: 		32 bit Floating point adder
-- Description: 		Swap two n-bit values according to a control signal
--							(0 = don't swap, 1 = swap)
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity SwapN is
	generic ( n : integer := 23);						-- Data size. Default size: 23 (mantissa size)
	port (
		swap	: in	std_logic;							-- Control signal
		x, y	: in 	std_logic_vector(0 to n-1);	-- Input data
		a, b	: out	std_logic_vector(0 to n-1)		-- Output data
	);
end SwapN;

architecture Behavioral of SwapN is
begin
	a <= y when swap='1' else
		  x;
	b <= x when swap='1' else
		  y;
end Behavioral;