----------------------------------------------------------------------------------
-- Module Name:    	TwoComplement
-- Project Name: 		32 bit floating point adder
-- Description: 		Two complement of a n-bit value
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TwoComplement is
	generic (
		n : integer											-- Data size
	);
	port (
		x	: 	in 	std_logic_vector(0 to n-1);	-- Input data
		y	: 	out	std_logic_vector(0 to n-1)		-- Output data
	);
end TwoComplement;

architecture Behavioral of TwoComplement is

	component RippleCarryAdder
		generic (
			n : integer
		);
		port (
			x, y 		: in  	std_logic_vector(n-1 downto 0);
			result	: out		std_logic_vector(n-1 downto 0)
		);
	end component;
	
	constant one : std_logic_vector(n-1 downto 0) := (0 => '1', others => '0');

begin
	
	-- Add 1 to the one complement to get the two complement
	adder: RippleCarryAdder
		generic map (
			n => n
		)
		port map (
         x			=> not x,
			y			=> one,
			result	=> y
		);
	
end Behavioral;