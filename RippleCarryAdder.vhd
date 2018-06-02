----------------------------------------------------------------------------------
-- Module Name:    	RippleCarryAdder
-- Project Name: 		32 bit floating point adder
-- Description: 		n-bit ripple carry adder
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity RippleCarryAdder is
	generic (
		n : integer														-- Data size
	);
	port (
		x, y			: in	std_logic_vector(n-1 downto 0);	-- Operands
		s				: out std_logic_vector(n-1 downto 0);	-- Result
		overflow		: out	std_logic								-- Output carry
	);
end RippleCarryAdder;

architecture Behavioral of RippleCarryAdder is

	-- Half adder: used for the least significant bit
	component HalfAdder
		port (
			x, y	: in	std_logic;			-- Operands
			s		: out std_logic;			-- Result
			c1		: out	std_logic			-- Output carry
		);
	end component;
	
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
	signal carries : std_logic_vector(n-1 downto 0) := (others => '0');

begin
	
	gen_adder:
	for i in 0 to n-1 generate
		lower_bit:
		if i=0 generate
			u0: HalfAdder
				port map (
					x => x(i),
					y => y(i),
					s => s(i),
					c1 => carries(i)
				);
		end generate lower_bit;
		
		upper_bits:
		if i>0 generate
			ux: FullAdder
				port map (
					x => x(i),
					y => y(i),
					c0 => carries(i-1),
					s => s(i),
					c1 => carries(i)
				);
		end generate upper_bits;
		
	end generate gen_adder;
	
	overflow <= carries(n-1);
	
end Behavioral;