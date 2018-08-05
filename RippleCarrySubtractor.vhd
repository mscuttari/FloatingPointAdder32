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
		result		: out std_logic_vector(n-1 downto 0);	-- Result
		result_sign	: out	std_logic								-- Result sign
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
	
	-- Extended signals
	signal x_extended			:	std_logic_vector(n downto 0);
	signal y_extended			:	std_logic_vector(n downto 0);
	signal result_extended	:	std_logic_vector(n downto 0);
	
	-- Vector of carries
	signal carries : std_logic_vector(n+1 downto 0);

begin

	x_extended <= '0' & x;
	y_extended <= '0' & y;

	carries(0) <= '1';
	
	gen_adder:
	for i in 0 to n generate
		adder: FullAdder
			port map (
				x => x_extended(i),
				y => not y_extended(i),
				c0 => carries(i),
				s => result_extended(i),
				c1 => carries(i+1)
			);
	
	end generate gen_adder;
	
	result <= result_extended(n-1 downto 0);
	result_sign <= result_extended(n);
	
end Behavioral;