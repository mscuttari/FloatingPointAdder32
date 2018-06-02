--------------------------------------------------------------------------------
-- Module Name:   TestRippleCarryAdder
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module RippleCarryAdder
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestRippleCarryAdder is
end TestRippleCarryAdder;
 
architecture behavior of TestRippleCarryAdder is 
	component RippleCarryAdder
		generic (
			n	: integer													-- Data size
		);
		port (
			x, y			: in	std_logic_vector(0 to n-1);		-- Operands
			s				: out std_logic_vector(0 to n-1);		-- Result
			overflow		: out	std_logic								-- Overflow signal
		);
	end component;
   
   
	-- Input data
   signal x, y	: std_logic_vector(0 to 7) := "00000000";
	
	-- Output data
	signal s				: std_logic_vector(0 to 7);
	signal overflow	: std_logic;

begin
   uut: RippleCarryAdder
		generic map (
			n => 8
		)
		port map (
         x => x,
         y => y,
			s => s,
			overflow => overflow
		);

   stim_proc: process
   begin
		wait for 100 ns;
		
		x <= "01111110";
		y <= "00000001";
		wait for 100 ns;
		
		x <= "01111111";
		y <= "01111111";
		wait for 100 ns;
		
		x <= "11111111";
		y <= "01111111";
      wait for 100 ns;
		
		x <= "11111111";
		y <= "11111111";
      wait;
   end process;

end;
