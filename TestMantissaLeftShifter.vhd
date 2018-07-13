--------------------------------------------------------------------------------
-- Module Name:   TestLeftShifter
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module LeftShifter
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestMantissaLeftShifter is
end TestMantissaLeftShifter;
 
architecture behavior of TestMantissaLeftShifter is 
	 
    component MantissaLeftShifter
    port(
         x 		: in		std_logic_vector(0 to 27);
         pos 	: in  	std_logic_vector(0 to 4);
         y 		: out  	std_logic_vector(0 to 27)
        );
    end component;
    
   -- Inputs
   signal x 	: 	std_logic_vector(0 to 27) 	:=	(others => '0');
   signal pos 	: 	std_logic_vector(0 to 4) 	:=	(others => '0');

 	-- Outputs
   signal y : std_logic_vector(0 to 27);

begin
   uut: MantissaLeftShifter
		port map (
          x 	=>	x,
          pos 	=>	pos,
          y 	=>	y
        );

   stim_proc: process
   begin
		x <= "0101010001011110101001001101";
		
		pos <= "00000";
		wait for 100 ns;
		
		pos <= "00001";
		wait for 100 ns;
		
		pos <= "00101";
		wait for 100 ns;
		
		pos <= "10101";
		wait for 100 ns;
		
		pos <= "10110";
      wait;
   end process;

end;
