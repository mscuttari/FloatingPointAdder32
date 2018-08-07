--------------------------------------------------------------------------------
-- Module Name:   TestRippleCarryAdder
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module RippleCarryAdder
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestRippleCarryAdder is
end TestRippleCarryAdder;
 
architecture behavior of TestRippleCarryAdder is 
	component RippleCarryAdder
		generic (
			n	: integer
		);
		port (
			x, y			: in	std_logic_vector(n-1 downto 0);
			result		: out std_logic_vector(n-1 downto 0);
			overflow		: out	std_logic
		);
	end component;
   
	-- Input data
   signal x, y			: std_logic_vector(7 downto 0);
	
	-- Output data
	signal result		: std_logic_vector(7 downto 0);
	signal overflow	: std_logic;
	
	signal result_expected		:	std_logic_vector(7 downto 0);
	signal overflow_expected	:	std_logic;
	
	signal check	:	std_logic;

begin
   uut: RippleCarryAdder
		generic map (
			n => 8
		)
		port map (
         x 			=> x,
         y 			=> y,
			result	=> result,
			overflow => overflow
		);
		
	test:	check <= '1' when result = result_expected and
									overflow = overflow_expected
						else '0';

   stim_proc: process
   begin
		
		x						<= "00000000";
		y						<= "00000000";
		result_expected	<=	"00000000";
		overflow_expected	<=	'0';
		
		wait for 250 ns;
		
		x						<= "00111001";
		y						<= "00010111";
		result_expected	<=	"01010000";
		overflow_expected	<=	'0';
		
		wait for 250 ns;
		
		x						<= "11100100";
		y						<= "01011100";
		result_expected	<=	"01000000";
		overflow_expected	<=	'1';

		wait for 250 ns;
		
		x						<= "11111111";
		y						<= "11111111";
		result_expected	<=	"11111110";
		overflow_expected	<=	'1';		
      
		wait;
		
   end process;
end;