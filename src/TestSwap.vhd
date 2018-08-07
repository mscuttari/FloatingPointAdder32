--------------------------------------------------------------------------------
-- Module Name:   TestSwap
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module Swap
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestSwap is
end TestSwap;
 
architecture behavior of TestSwap is 
	
	component Swap
		generic (
			n : integer
		);
		port (
			swap 	: in  	std_logic;
			x, y 	: in  	std_logic_vector(0 to n-1);
			a, b	: out 	std_logic_vector(0 to n-1)
		);
	end component;
    
   -- Inputs
   signal enable		:	std_logic;
   signal x				:	std_logic_vector(0 to 4);
   signal y				:	std_logic_vector(0 to 4);

 	-- Outputs
   signal a				:	std_logic_vector(0 to 4);
   signal b				:	std_logic_vector(0 to 4);
	
	signal a_expected	:	std_logic_vector(0 to 4);
	signal b_expected	:	std_logic_vector(0 to 4);
	
	signal check		:	std_logic;

begin

   uut: Swap
		generic map (
			n => 5
		)
		port map (
			swap	=> enable,
         x		=> x,
         y		=> y,
         a		=> a,
         b		=> b
		);
		
	test:	check <= '1' when a = a_expected and
									b = b_expected
						else '0';

   stim_proc: process
   begin
	
		enable		<= '0';
		x				<= "00000";
		y				<= "11111";
		a_expected	<= "00000";
		b_expected	<= "11111";
		
		
		wait for 500 ns;
		
		enable		<= '1';
		x				<= "00000";
		y				<= "11111";
		a_expected	<= "11111";
		b_expected	<= "00000";
      
		wait;
		
   end process;
end;