----------------------------------------------------------------------------------
-- Module Name:    	ZeroCounter
-- Project Name: 		32 bit floating point adder
-- Description: 		Zero-bit counter for the mantissa
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity ZeroCounter is
	port (
		mantissa		:	in		std_logic_vector(27 downto 0);	-- Mantissa
		count			:	out	std_logic_vector(4 downto 0)		-- Counter (value up to 27)
	);
end ZeroCounter;

architecture Behavioral of ZeroCounter is
	signal zero : std_logic_vector(27 downto 0) := (others => '0');
begin
	
	count <= "11100" when mantissa(27 downto 0)	= zero(27 downto 0)	else
				"11011" when mantissa(27 downto 1)	= zero(27 downto 1)	else
				"11010" when mantissa(27 downto 2)	= zero(27 downto 2)	else
				"11001" when mantissa(27 downto 3)	= zero(27 downto 3)	else	
				"11000" when mantissa(27 downto 4) 	= zero(27 downto 4) 	else
				"10111" when mantissa(27 downto 5) 	= zero(27 downto 5) 	else
				"10110" when mantissa(27 downto 6) 	= zero(27 downto 6) 	else
				"10101" when mantissa(27 downto 7) 	= zero(27 downto 7) 	else
				"10100" when mantissa(27 downto 8) 	= zero(27 downto 8) 	else
				"10011" when mantissa(27 downto 9) 	= zero(27 downto 9) 	else
				"10010" when mantissa(27 downto 10) = zero(27 downto 10) else
				"10001" when mantissa(27 downto 11) = zero(27 downto 11) else
				"10000" when mantissa(27 downto 12) = zero(27 downto 12) else
				"01111" when mantissa(27 downto 13) = zero(27 downto 13) else
				"01110" when mantissa(27 downto 14) = zero(27 downto 14) else
				"01101" when mantissa(27 downto 15) = zero(27 downto 15) else
				"01100" when mantissa(27 downto 16) = zero(27 downto 16) else
				"01011" when mantissa(27 downto 17) = zero(27 downto 17) else
				"01010" when mantissa(27 downto 18) = zero(27 downto 18) else
				"01001" when mantissa(27 downto 19) = zero(27 downto 19) else
				"01000" when mantissa(27 downto 20) = zero(27 downto 20) else
				"00111" when mantissa(27 downto 21) = zero(27 downto 21) else
				"00110" when mantissa(27 downto 22) = zero(27 downto 22) else
				"00101" when mantissa(27 downto 23) = zero(27 downto 23) else
				"00100" when mantissa(27 downto 24) = zero(27 downto 24) else
				"00011" when mantissa(27 downto 25) = zero(27 downto 25) else
				"00010" when mantissa(27 downto 26) = zero(27 downto 26) else
				"00001" when mantissa(27 downto 27) = zero(27 downto 27) else
				"00000";
	
end Behavioral;