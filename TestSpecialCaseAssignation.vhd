--------------------------------------------------------------------------------
-- Module Name:   TestSpecialCaseAssignation
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module SpecialCaseAssignation
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestSpecialCaseAssignation is
end TestSpecialCaseAssignation;
 
architecture behavior of TestSpecialCaseAssignation is 
	component SpecialCaseAssignation
		port (
			a					:	in 	std_logic_vector(31 downto 0);
			b					:	in 	std_logic_vector(31 downto 0);
			enable			:	out	std_logic;
			result			:	out	std_logic_vector(31 downto 0)
		);
	end component;
   
   -- Inputs
   signal a 	:	std_logic_vector(31 downto 0);
   signal b 	:	std_logic_vector(31 downto 0);

 	-- Outputs
	signal enable				:	std_logic;
	signal result				:	std_logic_vector(31 downto 0);
	
	signal enable_expected	:	std_logic;
	signal result_expected	:	std_logic_vector(31 downto 0);
	
	signal check				:	std_logic;

begin

   uut: SpecialCaseAssignation
		port map (
         a => a,
         b => b,
			enable => enable,
			result => result
		);

	test:	check <= '1' when enable = enable_expected and
									result = result_expected
						else '0';

   stim_proc: process
   begin
	
		-- Zero + anything = anything
		a						<=	"00000000000000000000000000000000";
		b						<=	"01101011001101001001001110100101";
		enable_expected	<=	'1';
		result_expected 	<=	"01101011001101001001001110100101";
		
		wait for 80 ns;
		
		-- Anything + zero = anything
		a						<=	"01101011001101001001001110100101";
		b						<=	"00000000000000000000000000000000";
		enable_expected	<=	'1';
		result_expected 	<=	"01101011001101001001001110100101";
		
		wait for 80 ns;
		
		-- + Infinity + Infinity = + Infinity
		a						<=	"01111111100000000000000000000000";
		b						<=	"01111111100000000000000000000000";
		enable_expected	<=	'1';
		result_expected 	<=	"01111111100000000000000000000000";
		
		wait for 80 ns;
		
		-- - Infinity - Infinity = - Infinity
		a						<=	"11111111100000000000000000000000";
		b						<=	"11111111100000000000000000000000";
		enable_expected	<=	'1';
		result_expected 	<=	"11111111100000000000000000000000";
		
		wait for 80 ns;
		
		-- + Infinity - Infinity = NaN
		a						<=	"01111111100000000000000000000000";
		b						<=	"11111111100000000000000000000000";
		enable_expected	<=	'1';
		result_expected 	<=	"01111111100000000000000000000001";
		
		wait for 80 ns;
		
		-- - Infinity + Infinity = NaN
		a						<=	"11111111100000000000000000000000";
		b						<=	"01111111100000000000000000000000";
		enable_expected	<=	'1';
		result_expected 	<=	"01111111100000000000000000000001";
		
		wait for 80 ns;
		
		-- Infinity + anything (different from NaN) = Infinity
		a						<= "01111111100000000000000000000000";
		b						<=	"11101011001101001001001110100101";
		enable_expected	<= '1';
		result_expected	<=	"01111111100000000000000000000000";
		
		wait for 80 ns;
		
		-- Anything (different from NaN) + Infinity = Infinity
		a						<= "01101011001101001001001110100101";
		b						<=	"01111111100000000000000000000000";
		enable_expected	<= '1';
		result_expected	<=	"01111111100000000000000000000000";
		
		wait for 80 ns;
		
		-- Nan + anything = NaN
		a						<=	"01111111100000000000000000000001";
		b						<=	"01101011001101001001001110100101";
		enable_expected	<=	'1';
		result_expected 	<=	"01111111100000000000000000000001";
		
		wait for 80 ns;
		
		-- Anything + Nan = NaN
		a						<=	"01101011001101001001001110100101";
		b						<=	"01111111100000000000000000000001";
		enable_expected	<=	'1';
		result_expected 	<=	"01111111100000000000000000000001";
		
		wait for 80 ns;
		
		-- Opposite values
		a						<=	"01101011001101001001001110100101";
		b						<=	"11101011001101001001001110100101";
		enable_expected	<=	'1';
		result_expected 	<=	"00000000000000000000000000000000";
		
		wait for 80 ns;
		
		-- No special cases found
		a						<=	"01101011001101001001001110100101";
		b						<=	"01101011001101001001001110100101";
		enable_expected	<=	'0';
		result_expected 	<=	"--------------------------------";

		wait;	
		
   end process;
end;