--------------------------------------------------------------------------------
-- Module Name:   LeftShifter
-- Project Name:  32 bit floating point adder
-- Description:   s positions left shifter of a n-bit input
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity LeftShifter is
	generic (
		n	:	integer;			-- Data size
		s	:	integer			--	Shift amount
	);
	port (
		x	:	in 	std_logic_vector(0 to n-1);	-- Input data
		y	:	out	std_logic_vector(0 to n-1)		-- Output data
	);
end LeftShifter;

architecture Behavioral of LeftShifter is
	signal zero : std_logic_vector(0 to n-1) := (others => '0');
begin
	y <= x(s to n-1) & zero(0 to s-1);
end Behavioral;

