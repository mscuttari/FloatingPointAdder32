--------------------------------------------------------------------------------
-- Module Name:   TestLeftShifter
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module LeftShifter
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity TestLeftShifter is
end TestLeftShifter;
 
architecture behavior of TestLeftShifter is 
 
    component LeftShifter
		generic (
			n	: integer;
			s	: integer
		);
		port(
         x	:	in		std_logic_vector(n-1 downto 0);
         y	:	out	std_logic_vector(n-1 downto 0)
       );
    end component;
    

   --Inputs
   signal x	: std_logic_vector(22 downto 0);

 	--Outputs
   signal y0	: std_logic_vector(22 downto 0);
   signal y1	: std_logic_vector(22 downto 0);
   signal y22	: std_logic_vector(22 downto 0);
   signal y23	: std_logic_vector(22 downto 0);
   signal y24	: std_logic_vector(22 downto 0);
	
	signal y0_expected	:	std_logic_vector(22 downto 0);
	signal y1_expected	:	std_logic_vector(22 downto 0);
	signal y22_expected	:	std_logic_vector(22 downto 0);
	signal y23_expected	:	std_logic_vector(22 downto 0);
	signal y24_expected	:	std_logic_vector(22 downto 0);
	
	signal check	:	std_logic;
 
begin

	uut0: LeftShifter 
		generic map (
			n => 23,
			s => 0
		)
		port map (
         x => x,
         y => y0
      );
		
	uut1: LeftShifter 
		generic map (
			n => 23,
			s => 1
		)
		port map (
         x => x,
         y => y1
      );
		
	uut22: LeftShifter 
		generic map (
			n => 23,
			s => 22
		)
		port map (
         x => x,
         y => y22
      );
		
	uut23: LeftShifter 
		generic map (
			n => 23,
			s => 23
		)
		port map (
         x => x,
         y => y23
      );
		
	uut24: LeftShifter 
		generic map (
			n => 23,
			s => 24
		)
		port map (
         x => x,
         y => y24
      );
		
	test:	check <=	'1' when	y0		=	y0_expected		and
									y1		=	y1_expected		and
									y22	=	y22_expected	and
									y23	=	y23_expected	and
									y24	=	y24_expected
						else '0';
		
   stim_proc: process
   begin
	
		x					<=	"11111111111111111111111";
		y0_expected		<=	"11111111111111111111111";
		y1_expected		<=	"11111111111111111111110";
		y22_expected	<=	"10000000000000000000000";
		y23_expected	<=	"00000000000000000000000";
		y24_expected	<=	"00000000000000000000000";
      
		wait;
		
   end process;
end;
