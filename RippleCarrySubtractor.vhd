----------------------------------------------------------------------------------
-- Module Name:    	RippleCarrySubtractor
-- Project Name: 		32 bit floating point adder
-- Description: 		n-bit ripple carry subtractor
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity RippleCarrySubtractor is
	generic (
		n : integer														-- Data size
	);
	port (
		x, y			: in	std_logic_vector(n-1 downto 0);	-- Operands
		s				: out std_logic_vector(n-1 downto 0);	-- Result
		underflow	: out	std_logic								-- Underflow
	);
end RippleCarrySubtractor;

architecture Behavioral of RippleCarrySubtractor is
	
	-- Full adder: used for all the other bits
	component FullAdder
		port (
			x, y	: in	std_logic;			-- Operands
			c0		: in 	std_logic;			-- Input carry
			s		: out std_logic;			-- Result
			c1		: out	std_logic			-- Output carry
		);
	end component;
	
	-- Vector of carries
	signal carries 	: 	std_logic_vector(n downto 0);

begin

	carries(0) <= '1';
	
	gen_adder:
	for i in 0 to n-1 generate
		adder: FullAdder
			port map (
				x => x(i),
				y => not y(i),
				c0 => carries(i),
				s => s(i),
				c1 => carries(i+1)
			);
	
	end generate gen_adder;
	
	underflow <= carries(n);
	
end Behavioral;