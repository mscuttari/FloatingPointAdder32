----------------------------------------------------------------------------------
-- Module Name:    	MantissaExtender
-- Project Name: 		32 bit floating point adder
-- Description: 		Extends an input mantissa, adding a starting implicit bit and ending guard bits
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;

entity MantissaExtender is
	port (
		input_mantissa		:	in		std_logic_vector(22 downto 0);
		normalized			:	in		std_logic;
		output_mantissa	:	out	std_logic_vector(27 downto 0)
	);
end MantissaExtender;

architecture Behavioral of MantissaExtender is

	component RightExtender
		generic (
			n, s	:	integer							-- Input and output length
		);
		port (
			x	: in 	std_logic_vector(0 to n-1);	-- Input data
			y	: out	std_logic_vector(0 to s-1)		-- Output data
		);
	end component;

begin

	output_mantissa(27) <= normalized;

	mantissa_extender: RightExtender
		generic map (
			n => 23,
			s => 27
		)
		port map (
			x => input_mantissa,
			y => output_mantissa(26 downto 0)
		);

end Behavioral;

