--------------------------------------------------------------------------------
-- Module Name:   TestMantissaRightShifter
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module MantissaRightShifter
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestMantissaRightShifter is
end TestMantissaRightShifter;
 
architecture behavior of TestMantissaRightShifter is 
	 
    component MantissaRightShifter
		port (
         x		:	in 	std_logic_vector(27 downto 0);
			pos	:	in 	std_logic_vector(7 downto 0);
			y		:	out	std_logic_vector(27 downto 0)
       );
    end component;
    
   -- Inputs
   signal x 	: 	std_logic_vector(27 downto 0);
   signal pos 	: 	std_logic_vector(7 downto 0);

 	-- Outputs
   signal y : std_logic_vector(27 downto 0);
	
	signal y_expected	:	std_logic_vector(27 downto 0);
	
	signal check	:	std_logic;

begin

   uut: MantissaRightShifter
		port map (
          x 	=>	x,
          pos 	=>	pos,
          y 	=>	y
        );
		  
	test:	check <= '1' when y = y_expected else '0';

   stim_proc: process
   begin
	
		x				<= "1111111111111111111111111111";
		pos			<= "00000000";
		y_expected	<=	"1111111111111111111111111111";
		
		wait for 200 ns;
		
		x				<= "1111111111111111111111111111";
		pos			<= "00000001";
		y_expected	<=	"0111111111111111111111111111";
		
		wait for 200 ns;
		
		x				<= "1111111111111111111111111111";
		pos			<= "00011011";
		y_expected	<=	"0000000000000000000000000001";
		
		wait for 200 ns;
		
		x				<= "1111111111111111111111111111";
		pos			<= "00011100";
		y_expected	<=	"0000000000000000000000000000";
		
		wait for 200 ns;
		
		x				<= "1111111111111111111111111111";
		pos			<= "00011101";
		y_expected	<=	"0000000000000000000000000000";
		
      wait;
		
   end process;
end;