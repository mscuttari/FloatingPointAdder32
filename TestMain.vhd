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
		port (
			a, b			: in	std_logic_vector(31 downto 0);
			result		: out	std_logic_vector(31 downto 0)
		);
	end component;
	
	-- Inputs
   signal a, b 	: std_logic_vector(31 downto 0) := (others => '0');
	signal result 	: std_logic_vector(31 downto 0);
	
begin
	uut: Main
		port map (
			a => a,
         b => b,
         result => result
		);

	stim_proc: process
   begin
		a <= "11000001101110101000000000000000";
		b <= "11000011101110101000000000111111";
      wait;
   end process;

end;
