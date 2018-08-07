--------------------------------------------------------------------------------
-- Module Name:   TestRippleCarrySubtractor
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module RippleCarrySubtractor
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestRippleCarrySubtractor is
end TestRippleCarrySubtractor;
 
architecture behavior of TestRippleCarrySubtractor is 
	component RippleCarrySubtractor
		generic (
			n	: integer
		);
		port (
			x, y			: in	std_logic_vector(n-1 downto 0);
			result		: out std_logic_vector(n-1 downto 0);
			result_sign	: out	std_logic
		);
	end component;
   
	-- Input data
   signal x, y			: std_logic_vector(7 downto 0);
	
	-- Output data
	signal result			: std_logic_vector(7 downto 0);
	signal result_sign	: std_logic;
	
	signal result_expected			:	std_logic_vector(7 downto 0);
	signal result_sign_expected	:	std_logic;
	
	signal check	:	std_logic;

begin
   uut: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x 				=> x,
         y 				=> y,
			result		=> result,
			result_sign => result_sign
		);
		
	test:	check <= '1' when result = result_expected and
									result_sign = result_sign_expected
						else '0';

   stim_proc: process
   begin
		
		x							<= "00000000";
		y							<= "00000000";
		result_expected		<=	"00000000";
		result_sign_expected	<=	'0';
		
		wait for 250 ns;
		
		x							<= "00111001";
		y							<= "00010111";
		result_expected		<=	"00100010";
		result_sign_expected	<=	'0';
		
		wait for 250 ns;
		
		x							<= "00010111";
		y							<= "00111001";
		result_expected		<=	"11011110";
		result_sign_expected	<=	'1';

		wait for 250 ns;
		
		x							<= "11111111";
		y							<= "11111111";
		result_expected		<=	"00000000";
		result_sign_expected	<=	'0';		
      
		wait;
		
   end process;
end;