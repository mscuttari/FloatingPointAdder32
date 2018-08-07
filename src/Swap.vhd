----------------------------------------------------------------------------------
-- Module Name:    	Swap
-- Project Name: 		32 bit floating point adder
-- Description: 		Swap two n-bit values according to a control signal
--							(0 = don't swap, 1 = swap)
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Swap is
	generic (
		n : integer											-- Data size
	);
	port (
		swap	: in	std_logic;							-- Control signal
		x, y	: in 	std_logic_vector(0 to n-1);	-- Input data
		a, b	: out	std_logic_vector(0 to n-1)		-- Output data
	);
end Swap;

architecture Behavioral of Swap is
begin

	a <= y when swap = '1' else
		  x;
	b <= x when swap = '1' else
		  y;

end Behavioral;