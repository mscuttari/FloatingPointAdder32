--------------------------------------------------------------------------------
-- Module Name:   TestExtender
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module Extender
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestExtender is
end TestExtender;
 
architecture behavior of TestExtender is 
	component Extender
		generic (
			n : integer;
			s : integer
		);
		port (
			x	: in  	std_logic_vector(0 to n-1);
			y	: out 	std_logic_vector(0 to s-1)
		);
	end component;
   
   -- Inputs
   signal x 	: std_logic_vector(0 to 7) := (others => '0');

 	-- Outputs
	signal y 	: std_logic_vector(0 to 15);

begin
   uut: Extender
		generic map(
			n => 8,
			s => 16
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