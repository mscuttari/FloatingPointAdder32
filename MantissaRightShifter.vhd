----------------------------------------------------------------------------------
-- Module Name:    	MantissaRightShifter
-- Project Name: 		32 bit floating point adder
-- Description: 		Right shift the mantissa up to 23 positions
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity MantissaRightShifter is
	port (
		x		:	in 	std_logic_vector(22 downto 0);	-- Original mantissa
		pos	:	in		std_logic_vector(4 downto 0);		-- Shift amount
		y		:	out	std_logic_vector(22 downto 0)		-- Shifted mantissa
	);
end MantissaRightShifter;

architecture Behavioral of MantissaRightShifter is

	signal x_extended : std_logic_vector(23 downto 0);

	-- Generic s-positions right shifter of a n-bit value
	component RightShifter
		generic (
			n : integer;
			s : integer
		);
		port (
			x 	: in  	std_logic_vector(n-1 downto 0);
			y	: out 	std_logic_vector(n-1 downto 0)
		);
	end component;
	
	type vector24 is array (natural range <>) of std_logic_vector(23 downto 0);
	signal shiftsVector : vector24(23 downto 0);
	
begin

	-- Add the initial 1.
	x_extended <= '1' & x;

	-- Instantiation of 23 shifters with incremental shift amounts
	gen_shift: 
	for i in 0 to 22 generate
		 shifter: RightShifter
			generic map(
				n => 24,
				s => i
			)
			port map(
				x => x_extended,
				y => shiftsVector(i)
			);
   end generate gen_shift;
	
	-- Select the right output
	y <=  shiftsVector(0)(22 downto 0) when pos = "00000" else
			shiftsVector(1)(22 downto 0) when pos = "00001" else
			shiftsVector(2)(22 downto 0) when pos = "00010" else
			shiftsVector(3)(22 downto 0) when pos = "00011" else
			shiftsVector(4)(22 downto 0) when pos = "00100" else
			shiftsVector(5)(22 downto 0) when pos = "00101" else
			shiftsVector(6)(22 downto 0) when pos = "00110" else
			shiftsVector(7)(22 downto 0) when pos = "00111" else
			shiftsVector(8)(22 downto 0) when pos = "01000" else
			shiftsVector(9)(22 downto 0) when pos = "01001" else
			shiftsVector(10)(22 downto 0) when pos = "01010" else
			shiftsVector(11)(22 downto 0) when pos = "01011" else
			shiftsVector(12)(22 downto 0) when pos = "01100" else
			shiftsVector(13)(22 downto 0) when pos = "01101" else
			shiftsVector(14)(22 downto 0) when pos = "01110" else
			shiftsVector(15)(22 downto 0) when pos = "01111" else
			shiftsVector(16)(22 downto 0) when pos = "10000" else
			shiftsVector(17)(22 downto 0) when pos = "10001" else
			shiftsVector(18)(22 downto 0) when pos = "10010" else
			shiftsVector(19)(22 downto 0) when pos = "10011" else
			shiftsVector(20)(22 downto 0) when pos = "10100" else
			shiftsVector(21)(22 downto 0) when pos = "10101" else
			shiftsVector(22)(22 downto 0) when pos = "10110" else
			shiftsVector(23)(22 downto 0);
	
end Behavioral;

