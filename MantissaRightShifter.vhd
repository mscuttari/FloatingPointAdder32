----------------------------------------------------------------------------------
-- Module Name:    	MantissaRightShifter
-- Project Name: 		32 bit floating point adder
-- Description: 		Right shift the mantissa up to 23 positions
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity MantissaRightShifter is
	port (
		x		: in 	std_logic_vector(0 to 22);		-- Original mantissa
		pos	: in	std_logic_vector(0 to 4);		-- Shift amount
		y		: out	std_logic_vector(0 to 22)		-- Shifted mantissa
	);
end MantissaRightShifter;

architecture Behavioral of MantissaRightShifter is

	-- Generic s-positions right shifter of a 23 bit value
	component RightShifter
		generic (
			n : integer := 23;
			s : integer
		);
		port (
			x 	: in  	std_logic_vector(0 to n-1);
			y	: out 	std_logic_vector(0 to n-1)
		);
	end component;
	
	
	
	
begin

	-- Instantiation of 23 shifters with incremental shift amounts
	--gen_shift: 
	--for i in 0 to 22 generate
	--	REGX : RightShifter
	--		generic map(s => i)
	--		port map(
	--			x => x,
	--		);
   --end generate gen_shift;
	
	
end Behavioral;

