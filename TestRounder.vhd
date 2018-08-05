--------------------------------------------------------------------------------
-- Module Name:   TestRounder
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module Rounder
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity TestRounder is
end TestRounder;
 
architecture behavior of TestRounder is 

    component Rounder
		port (
         x	:	in		std_logic_vector(3 downto 0);
         y	:	out	std_logic
      );
    end component;
    
   -- Inputs
   signal x : std_logic_vector(3 downto 0);

 	-- Outputs
   signal y : std_logic;
	
	signal y_expected : std_logic;
	
	signal check : std_logic;
	
begin
 
	uut: Rounder
		port map (
			x => x,
			y => y
		);

	test: check <= '1' when y = y_expected else '0';

   stim_proc: process
   begin
		
		x <= "0111";
		y_expected <= '0';
		
		wait for 500 ns;
		
		x <= "1000";
		y_expected <= '1';
		
		wait;
		
   end process;
end;