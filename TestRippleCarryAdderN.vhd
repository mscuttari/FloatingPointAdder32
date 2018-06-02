--------------------------------------------------------------------------------
-- Module Name:   TestRippleCarryAdderN
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module RippleCarryAdderN
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestRippleCarryAdderN is
end TestRippleCarryAdderN;
 
architecture behavior of TestRippleCarryAdderN is 
	component RippleCarryAdderN
		generic ( n : integer);									-- Data size
		port (
			x, y	: in	std_logic_vector(0 to n-1);		-- Operands
			c0		: in 	std_logic;								-- Input carry
			s		: out std_logic_vector(0 to n-1);		-- Result
			c1		: out	std_logic								-- Output carry
		);
	end component;
   
	-- Input data
   signal x, y	: std_logic_vector(0 to 7) := "00000000";
	signal c0	: std_logic	:= '0';
	
	-- Output data
	signal s		: std_logic_vector(0 to 7);
	signal c1	: std_logic;

begin
   uut: RippleCarryAdderN
		generic map ( n => 8 )
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
		
		x <= "00000000";
		y <= "00000000";
		c0 <= '1';
		wait for 100 ns;
		
		x <= "01111110";
		y <= "00000001";
		c0 <= '0';
		wait for 100 ns;
		
		x <= "01111110";
		y <= "00000001";
		c0 <= '1';
		wait for 100 ns;
		
		x <= "01111111";
		y <= "01111111";
		c0 <= '0';
		wait for 100 ns;
		
		x <= "01111111";
		y <= "01111111";
		c0 <= '1';
		wait for 100 ns;
		
		x <= "11111111";
		y <= "11111111";
		c0 <= '0';
		wait for 100 ns;
		
		x <= "11111111";
		y <= "11111111";
		c0 <= '1';
      wait;
   end process;

end;
