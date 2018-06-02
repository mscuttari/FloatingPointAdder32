----------------------------------------------------------------------------------
-- Module Name:    	RippleCarryAdder
-- Project Name: 		32 bit floating point adder
-- Description: 		1-bit ripple carry adder
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity RippleCarryAdderN is
	generic ( n : integer := 8 );								-- Data size
	port (
		x, y	: in	std_logic_vector(0 to n-1);		-- Operands
		c0		: in 	std_logic;								-- Input carry
		s		: out std_logic_vector(0 to n-1);		-- Result
		c1		: out	std_logic								-- Output carry
	);
end RippleCarryAdderN;

architecture Behavioral of RippleCarryAdderN is

	component RippleCarryAdder
		port (
			x, y	: in	std_logic;			-- Operands
			c0		: in 	std_logic;			-- Input carry
			s		: out std_logic;			-- Result
			c1		: out	std_logic			-- Output carry
		);
	end component;

	signal carries : std_logic_vector(0 to n) := (others => '0');

begin

	carries(n) <= c0;

	gen_adder: 
	for i in 0 to n-1 generate
		 adder: RippleCarryAdder
			port map(
				x => x(i),
				y => y(i),
				c0 => carries(i+1),
				s => s(i),
				c1 => carries(i)
			);
   end generate gen_adder;
	
	c1 <= carries(0);
	
end Behavioral;