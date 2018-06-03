--------------------------------------------------------------------------------
-- Module Name:   TestAbsoluteValue
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module AbsoluteValue
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestAbsoluteValue is
end TestAbsoluteValue;
 
architecture behavior of TestAbsoluteValue is 
	component AbsoluteValue
		generic ( n : integer );
		port (
			x	: 	in 	std_logic_vector(0 to n-1);
			y	: 	out	std_logic_vector(0 to n-1)
		);
	end component;
   
   signal x, y 	: 	std_logic_vector(0 to 7);

begin
   uut: AbsoluteValue
		generic map( n => 8 )
		port map (
         x => x,
         y => y
		);

   stim_proc: process
   begin
		-- Expected result: 00000000
		x <= "00000000";
      wait for 100 ns;
		
		-- Expected result: 00000001
		x <= "00000001";
		wait for 100 ns;
		
		-- Expected result: 01111111
		x <= "01111111";
      wait for 100 ns;
		
		-- Expected result: 10000000
		x <= "10000000";
		wait for 100 ns;
		
		-- Expected result: 00000001
		x <= "11111111";
		wait for 100 ns;
		
		-- Expected result: 01110001
		x <= "10001111";
		wait for 100 ns;
		
		-- Expected result: 01010110
		x <= "10101010";
		wait for 100 ns;
		
		-- Expected result: 01010101
		x <= "01010101";
      wait;
		
   end process;

end;