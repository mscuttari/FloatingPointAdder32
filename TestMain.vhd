--------------------------------------------------------------------------------
-- Module Name:   TestMain
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module Main
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestMain is
end TestMain;
 
architecture behavior of TestMain is 
	component Main
		generic (
			exponent_size	:	integer;				-- Exponent size
			mantissa_size	:	integer				-- Mantissa size
		);
		port (
			a, b			: in	std_logic_vector(31 downto 0);		-- Input
			result		: out	std_logic_vector(31 downto 0);		-- Output
			prova			: out std_logic_vector(0 to 7)
		);
	end component;
	
	   -- Inputs
   signal a, b 	: std_logic_vector(31 downto 0) := (others => '0');
	signal result 	: std_logic_vector(31 downto 0);
	signal prova	: std_logic_vector(0 to 7);
	
begin
	uut: Main
		generic map (
			exponent_size => 8,
			mantissa_size => 23
		)
		port map (
			a => a,
         b => b,
         result => result,
         prova => prova
		);

	stim_proc: process
   begin
		a <= "11000001101110101000000000000000";
		b <= "11000011101110101000000000000000";
      wait;
   end process;

end;
