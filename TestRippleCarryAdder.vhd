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
		port (
			x, y	: in	std_logic;			-- Operands
			c0		: in 	std_logic;			-- Input carry
			s		: out std_logic;			-- Result
			c1		: out	std_logic			-- Output carry
		);
	end component;
   
   signal x, y, c0 : std_logic := '0';	-- Input data
	signal s, c1 : std_logic;				-- Output data

begin
   uut: RippleCarryAdder
		port map (
         x => x,
         y => y,
			c0 => c0,
			s => s,
			c1 => c1
		);

   stim_proc: process
   begin
		wait for 100 ns;
		
		x <= '0';
		y <= '0';
		c0 <= '1';
		wait for 100 ns;
		
		x <= '0';
		y <= '1';
		c0 <= '0';
		wait for 100 ns;
		
		x <= '0';
		y <= '1';
		c0 <= '1';
		wait for 100 ns;
		
		x <= '1';
		y <= '0';
		c0 <= '0';
		wait for 100 ns;
		
		x <= '1';
		y <= '0';
		c0 <= '1';
		wait for 100 ns;
		
		x <= '1';
		y <= '1';
		c0 <= '0';
		wait for 100 ns;
		
		x <= '1';
		y <= '1';
		c0 <= '1';
      wait;
   end process;

end;
