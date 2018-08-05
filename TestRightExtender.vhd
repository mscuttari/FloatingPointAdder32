--------------------------------------------------------------------------------
-- Module Name:   TestRightExtender
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module RightExtender
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestRightExtender is
end TestRightExtender;
 
architecture behavior of TestRightExtender is 
	component RightExtender
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
   signal x 	: std_logic_vector(0 to 7);

 	-- Outputs
	signal y0 	: std_logic_vector(0 to 7);
	signal y1 	: std_logic_vector(0 to 8);
	signal y3 	: std_logic_vector(0 to 10);
	signal y8 	: std_logic_vector(0 to 15);
	
	signal y0_expected	:	std_logic_vector(0 to 7);
	signal y1_expected	:	std_logic_vector(0 to 8);
	signal y3_expected	:	std_logic_vector(0 to 10);
	signal y8_expected	:	std_logic_vector(0 to 15);
	
	signal check	:	std_logic;

begin
   uut0: RightExtender
		generic map(
			n => 8,
			s => 8
		)
		port map (
         x => x,
         y => y0
		);
		
	uut1: RightExtender
		generic map(
			n => 8,
			s => 9
		)
		port map (
         x => x,
         y => y1
		);
		
	uut3: RightExtender
		generic map(
			n => 8,
			s => 11
		)
		port map (
         x => x,
         y => y3
		);
		
	uut8: RightExtender
		generic map(
			n => 8,
			s => 16
		)
		port map (
         x => x,
         y => y8
		);
		
	test:	check <=	'1' when	y0 = y0_expected and
									y1 = y1_expected and
									y3 = y3_expected and
									y8 = y8_expected
						else '0';
						
   stim_proc: process
   begin

		x 				<= "11111111";
      y0_expected <= "11111111";
      y1_expected <= "111111110";
      y3_expected <= "11111111000";
      y8_expected <= "1111111100000000";
      
		wait;
		
   end process;
	
end;