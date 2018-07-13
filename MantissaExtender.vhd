----------------------------------------------------------------------------------
-- Module Name:    	MantissaExtender
-- Project Name: 		32 bit floating point adder
-- Description: 		extends an input mantissa, adding a starting implicit bit and ending guard bits
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;

entity MantissaExtender is
	generic (
		i	:	integer;									-- Input length
		g	:	integer									--	Guard bits
	);
	port (
		input_mantissa		:	in		std_logic_vector(i-1 downto 0);
		normalized			:	in		std_logic;
		output_mantissa	:	out	std_logic_vector(i+g downto 0)
	);
end MantissaExtender;

architecture Behavioral of MantissaExtender is

	component Extender
		generic (
			n, s	:	integer							-- Input and output length
		);
		port (
			x	: in 	std_logic_vector(0 to n-1);	-- Input data
			y	: out	std_logic_vector(0 to s-1)		-- Output data
		);
	end component;

begin

	output_mantissa(i+g) <= normalized;

	mantissa_extender: Extender
		generic map (
			n => i,
			s => i+g
		)
		port map (
			x => input_mantissa,
			y => output_mantissa(i+g-1 downto 0)
		);

end Behavioral;

