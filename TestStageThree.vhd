--------------------------------------------------------------------------------
-- Module Name:   TestStageThree
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module StageThree
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestStageThree is
end TestStageThree;

architecture behavior of TestStageThree is 
	component StageThree
		port (
			special_case_flag				:	in		std_logic;
			special_case_result			:	in		std_logic_vector(31 downto 0);
			value								:	in		std_logic_vector(36 downto 0);
			result							:	out	std_logic_vector(31 downto 0);
			special_case_flag_out		:	out	std_logic
		);
	end component;
	
	-- Data signals
	signal special_case_flag						:	std_logic;
	signal special_case_result						:	std_logic_vector(31 downto 0);
	signal value										:	std_logic_vector(36 downto 0);
	signal result										:	std_logic_vector(31 downto 0);
	signal special_case_flag_out					:	std_logic;
	
	signal result_expected							:	std_logic_vector(31 downto 0);
	signal special_case_flag_out_expected		:	std_logic;
	
	signal check	:	std_logic;
	
begin
	
	uut: StageThree
		port map (
			special_case_flag				=>	special_case_flag,
			special_case_result			=>	special_case_result,
			value								=>	value,
			result							=>	result,
			special_case_flag_out		=>	special_case_flag_out
		);
		
	test: check <= '1' when result = result_expected and
									special_case_flag_out = special_case_flag_out_expected
						else '0';
	
   stim_proc: process
   begin
		
		--	Exp = 0 & #z = 0
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0000000001011001000101101001001100000";
		result_expected							<=	"00000000101100100010110100100110";
		special_case_flag_out_expected		<=	'0';
		
		wait for 100 ns;
		
		--	Exp = 0 & #z != 0
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0000000000011001000101101001001100000";
		result_expected							<=	"00000000001100100010110100100110";
		special_case_flag_out_expected		<=	'0';
		
		wait for 100 ns;
		
		--	Exp != 0 & exp > #z
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0100101100011001000101101001001100000";
		result_expected							<=	"01001010010010001011010010011000";
		special_case_flag_out_expected		<=	'0';
		
		wait for 100 ns;
		
		--	Exp != 0 & exp = #z
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0000000100011001000101101001001100000";
		result_expected							<=	"00000000011001000101101001001100";
		special_case_flag_out_expected		<=	'0';
		
		wait for 100 ns;
		
		--	Exp != 0 & exp < #z
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0000000100001100100010110100100110000";
		result_expected							<=	"00000000001100100010110100100110";
		special_case_flag_out_expected		<=	'0';
		
		wait for 100 ns;
		
		--	No rounding
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0100101101011001000101101001001100000";
		result_expected							<=	"01001011001100100010110100100110";
		special_case_flag_out_expected		<=	'0';
		
		wait for 100 ns;
		
		--	Rounding without overflow
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0100101101011001000101101001001101000";
		result_expected							<=	"01001011001100100010110100100111";
		special_case_flag_out_expected		<=	'0';
		
		wait for 100 ns;
		
		--	Rounding with overflow but no special case
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0100101101111111111111111111111111000";
		result_expected							<=	"01001011100000000000000000000000";
		special_case_flag_out_expected		<=	'0';
		
		wait for 100 ns;
		
		--	Rounding with overflow and special case
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0111111101111111111111111111111111000";
		result_expected							<=	"01111111100000000000000000000000";
		special_case_flag_out_expected		<=	'1';
		
		wait for 100 ns;
		
		--	Special case propagation
		special_case_flag							<=	'1';
		special_case_result						<= "11111111100000000000000000000000";
		value											<=	"-------------------------------------";
		result_expected							<=	"11111111100000000000000000000000";
		special_case_flag_out_expected		<=	'1';
		
		wait;
		
	end process;
end;
