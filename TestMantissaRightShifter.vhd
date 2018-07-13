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
         x 		: in		std_logic_vector(27 downto 0);
         pos 	: in  	std_logic_vector(4 downto 0);
         y 		: out  	std_logic_vector(27 downto 0)
        );
    end component;
    
   -- Inputs
   signal x 	: 	std_logic_vector(27 downto 0) 	:=	(others => '0');
   signal pos 	: 	std_logic_vector(4 downto 0) 	:=	(others => '0');

 	-- Outputs
   signal y : std_logic_vector(27 downto 0);

begin
   uut: MantissaRightShifter
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
