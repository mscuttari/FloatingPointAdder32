----------------------------------------------------------------------------------
-- Module Name:    	RightShifter
-- Project Name: 		32 bit floating point adder
-- Description: 		s positions right shifter of a n-bit input
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity RightShifter is
	generic (
		n 	: 	integer;			-- Data size
		s 	:	integer			-- Shift amount
	);					
	port (
		x	:	in 	std_logic_vector(n-1 downto 0);	-- Input data
		y	:	out	std_logic_vector(n-1 downto 0)	-- Output data
	);
end RightShifter;

architecture Behavioral of RightShifter is

	constant zero : std_logic_vector(n-1 downto 0) := (others => '0');
	
begin

	process(x)
	begin
		if (s = 0) then
			y <= x;
		elsif (s >= n) then
			y <= zero;
		else
			y <= zero(s-1 downto 0) & x(n-1 downto s);
		end if;
	end process;
	
end Behavioral;

