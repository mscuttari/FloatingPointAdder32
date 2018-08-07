----------------------------------------------------------------------------------
-- Module Name:    	Rounder
-- Project Name: 		32 bit floating point adder
-- Description: 		Round g-input bits to a single rounded output bit
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;

entity Rounder is
	port (
		x	:	in		std_logic_vector(3 downto 0);		--	Input vector
		y	:	out	std_logic								--	Round
	);
end Rounder;

architecture Behavioral of Rounder is

begin

	y <=	x(3);
	
end Behavioral;