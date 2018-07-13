--------------------------------------------------------------------------------
-- Module Name:   TestMantissaExtender
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module MantissaExtender
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity TestMantissaExtender is
end TestMantissaExtender;
 
architecture behavior of TestMantissaExtender is 
 
    component MantissaExtender
		 generic (
				i	:	integer;
				g	:	integer
		 );
		 port(
				input_mantissa 	: 	in  	std_logic_vector(i-1 downto 0);
				normalized			:	in  	std_logic;
				output_mantissa 	: 	out  	std_logic_vector(i+g downto 0)
		 );
    end component;
    

   --Inputs
   signal input_mantissa 	: 	std_logic_vector(22 downto 0) := (others => '0');
   signal normalized 		: 	std_logic := '0';

 	--Outputs
   signal output_mantissa : std_logic_vector(27 downto 0);
 
begin
 
   uut: MantissaExtender
	generic map (
		i => 23,
		g => 4
	)
	port map (
          input_mantissa => input_mantissa,
          normalized => normalized,
          output_mantissa => output_mantissa
   );
	
   stim_proc: process
   begin		
      wait for 100 ns;
		input_mantissa <= "01010101010101010101011";
		normalized <= '1';
		wait for 100 ns;
		input_mantissa <= "10101010101010101010101";
		wait for 100 ns;
		normalized <= '0';
		wait;
   end process;

END;
