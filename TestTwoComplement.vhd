--------------------------------------------------------------------------------
-- Module Name:   TestRightShifter
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module RightShifter
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestTwoComplement is
end TestTwoComplement;
 
architecture behavior of TestTwoComplement is 
	component TwoComplement
		generic ( n : integer );
		port (
			x			: in  	std_logic_vector(0 to n-1);
			y			: out 	std_logic_vector(0 to n-1);
			overflow	: out		std_logic
		);
	end component;
   
   -- Inputs
   signal x : std_logic_vector(0 to 7) := (others => '0');

 	-- Outputs
	signal y 			: std_logic_vector(0 to 7);
	signal overflow	: std_logic;

begin
   uut: TwoComplement
		generic map( n => 8 )
		port map (
         x => x,
         y => y,
			overflow => overflow
		);

   stim_proc: process
   begin
		wait for 100 ns;
		
		x <= "11111111";
      wait for 100 ns;
		
		x <= "00000000";
		wait for 100 ns;
		
		x <= "01100100";
      wait for 100 ns;
		
		x <= "01110101";
		wait for 100 ns;
		
		x <= "00001000";
      wait for 100 ns;
		
		x <= "10101010";
      wait for 100 ns;
		
		x <= "00100100";
      wait;
   end process;

end;
