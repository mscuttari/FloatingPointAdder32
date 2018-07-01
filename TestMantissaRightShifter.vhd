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
    port(
         x 				:	in		std_logic_vector(0 to 22);
         pos 			:	in  	std_logic_vector(0 to 4);
			normalized	:	in		std_logic;
         y 				:	out  	std_logic_vector(0 to 22)
        );
    end component;
    
   -- Inputs
   signal x 				: 	std_logic_vector(0 to 22) 	:=	(others => '0');
   signal pos 				: 	std_logic_vector(0 to 4) 	:=	(others => '0');
	signal normalized		:	std_logic						:= '0';

 	-- Outputs
   signal y : std_logic_vector(0 to 22);

begin
   uut: MantissaRightShifter
		port map (
          x 			=>	x,
          pos 			=>	pos,
			 normalized	=>	normalized,
          y 			=>	y
        );

   stim_proc: process
   begin
		x <= "01010100010111101010010";
		
		pos <= "00000";
		normalized <= '1';
		wait for 100 ns;
		
		pos <= "00000";
		normalized <= '0';
		wait for 100 ns;
		
		pos <= "00001";
		normalized <= '1';
		wait for 100 ns;
		
		pos <= "00001";
		normalized <= '0';
		wait for 100 ns;
		
		pos <= "00101";
		normalized <= '1';
		wait for 100 ns;
		
		pos <= "00101";
		normalized <= '0';
		wait for 100 ns;
		
		pos <= "10101";
		normalized <= '1';
		wait for 100 ns;
		
		pos <= "10101";
		normalized <= '0';
		wait for 100 ns;
		
		pos <= "10110";
		normalized <= '1';
		wait for 100 ns;
		
		pos <= "10110";
		normalized <= '0';
      wait;
   end process;

end;
