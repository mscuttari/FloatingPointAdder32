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
		x	:	in 	std_logic_vector(n-1 downto 0);	-- Input data
		y	:	out	std_logic_vector(n-1 downto 0)		-- Output data
	);
end LeftShifter;

architecture Behavioral of LeftShifter is

	constant zero : std_logic_vector(n-1 downto 0) := (others => '0');

begin

	process(x)
	begin
		if (s = 0) then
			y <= x;
		elsif (s >= n) then
			y <= zero;
		else
			y <= x(n-s-1 downto 0) & zero(s-1 downto 0);
		end if;
	end process;

end Behavioral;