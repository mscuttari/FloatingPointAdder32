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
		generic (
			n : integer
		);
		port (
			x	: 	in 	std_logic_vector(0 to n-1);
			y	: 	out	std_logic_vector(0 to n-2)
		);
	end component;
   
   signal x				:	std_logic_vector(0 to 8);
	signal y				:	std_logic_vector(0 to 7);
	
	signal y_expected	:	std_logic_vector(0 to 7);
	
	signal check		:	std_logic;

begin

   uut: AbsoluteValue
		generic map (
			n => 9
		)
		port map (
         x	=>	x,
         y	=> y
		);
		
	test: check <= '1' when y = y_expected else '0';

   stim_proc: process
   begin
	
		--	Positive value
		x				<=	"010010110";
		y_expected	<=	 "10010110";
		
		wait for 250 ns;
		
		--	Negative value
		x				<=	"110010110";
		y_expected	<=	 "01101010";
		
		wait for 250 ns;
		
		--	Zero value with positive sign
		x				<=	"000000000";
		y_expected	<=	 "00000000";
		
		wait for 250 ns;
		
		--	Zero value with negative sign
		x				<=	"100000000";
		y_expected	<=	 "00000000";
		
		wait;
		
	end process;
	
end;