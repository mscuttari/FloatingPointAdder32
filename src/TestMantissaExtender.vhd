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
		 port (
				input_mantissa 	: 	in  	std_logic_vector(22 downto 0);
				normalized			:	in  	std_logic;
				output_mantissa 	: 	out  	std_logic_vector(27 downto 0)
		 );
    end component;

   -- Inputs
   signal input_mantissa 	: 	std_logic_vector(22 downto 0);
   signal normalized 		: 	std_logic;

 	-- Outputs
   signal output_mantissa : std_logic_vector(27 downto 0);
	
	signal output_mantissa_expected	:	std_logic_vector(27 downto 0);
	
	signal check	:	std_logic;
 
begin
 
   uut: MantissaExtender
		port map (
          input_mantissa	=> input_mantissa,
          normalized			=> normalized,
          output_mantissa	=> output_mantissa
		);
		
	test:	check <= '1' when output_mantissa = output_mantissa_expected else '0';
	
   stim_proc: process
	
   begin		
      
		input_mantissa <= "10000000000000000000001";
		normalized <= '0';
		output_mantissa_expected <= "0100000000000000000000010000";
		
		wait for 500 ns;
		
		input_mantissa <= "00000000000000000000001";
		normalized <= '1';
		output_mantissa_expected <= "1000000000000000000000010000";
		
		wait;
		
   end process;
end;