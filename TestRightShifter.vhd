--------------------------------------------------------------------------------
-- Module Name:   TestRightShifter
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module RightShifter
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestRightShifter is
end TestRightShifter;
 
architecture behavior of TestRightShifter is 
	component RightShifter
		generic (
			n : integer;
			s : integer
		);
		port (
			x	: in  	std_logic_vector(0 to n-1);
			y	: out 	std_logic_vector(0 to n-1)
		);
	end component;
   
   -- Inputs
   signal x 	: std_logic_vector(0 to 7) := (others => '0');

 	-- Outputs
	signal y 	: std_logic_vector(0 to 7);

begin
   uut: RightShifter
		generic map(
			n => 8,
			s => 3
		)
		port map (
         x => x,
         y => y
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
