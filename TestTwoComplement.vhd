--------------------------------------------------------------------------------
-- Module Name:   TestTwoComplement
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module TwoComplement
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestTwoComplement is
end TestTwoComplement;
 
architecture behavior of TestTwoComplement is 
	component TwoComplement
		generic (
			n : integer
		);
		port (
			x			: in  	std_logic_vector(0 to n-1);
			y			: out 	std_logic_vector(0 to n-1)
		);
	end component;
   
   -- Inputs
   signal x : std_logic_vector(0 to 7);

 	-- Outputs
	signal y : std_logic_vector(0 to 7);
	
	signal y_expected	:	std_logic_vector(0 to 7);
	
	signal check		:	std_logic;

begin
   uut: TwoComplement
		generic map (
			n => 8
		)
		port map (
         x 			=> x,
         y 			=> y
		);
		
	test: check <= '1' when y = y_expected
						else '0';

   stim_proc: process
   begin
		
		-- All '0' bits
		x				<= "00000000";
		y_expected	<= "00000000";
		
		wait for 250 ns;
		
		--	Generic value
		x				<= "10101010";
		y_expected	<= "01010110";
		
		wait for 250 ns;
		
		-- Only one '1' bit
		x				<= "00000001";
		y_expected	<= "11111111";
		
		wait for 250 ns;
		
		-- All '1' bits
		x				<= "11111111";
		y_expected	<= "00000001";
		
		wait;
		
   end process;
end;