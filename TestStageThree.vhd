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
			CLK								:	in		std_logic;
			special_case_flag				:	in		std_logic;
			special_case_result			:	in		std_logic_vector(31 downto 0);
			value								:	in		std_logic_vector(36 downto 0);
			result							:	out	std_logic_vector(31 downto 0);
			special_case_flag_out		:	out	std_logic
		);
	end component;
	
	-- Data signals
	signal CLK											:	std_logic;
	signal special_case_flag						:	std_logic;
	signal special_case_result						:	std_logic_vector(31 downto 0);
	signal value										:	std_logic_vector(36 downto 0);
	signal result										:	std_logic_vector(31 downto 0);
	signal special_case_flag_out					:	std_logic;
	
	signal result_expected							:	std_logic_vector(31 downto 0);
	signal special_case_flag_out_expected		:	std_logic;
	
	signal check	:	std_logic;
	
   -- Clock period
   constant CLK_period : time := 55 ns;
	
begin

	-- Clock definition
   CLK_process: process
   begin
		CLK <= '0';
		wait for CLK_period / 2;
		CLK <= '1';
		wait for CLK_period / 2;
   end process;
	
	uut: StageThree
		port map (
			CLK								=>	CLK,
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
	
		result_expected							<=	"UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
		special_case_flag_out_expected		<=	'U';

		--	Exp = 0 & #z = 0
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0000000001011001000101101001001100000";
		
		wait for CLK_period / 2;
		
		result_expected							<=	"00000000101100100010110100100110";
		special_case_flag_out_expected		<=	special_case_flag;
		
		wait for CLK_period / 2;
		
		--	Exp = 0 & #z != 0
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0000000000011001000101101001001100000";
		
		wait for CLK_period / 2;
		
		result_expected							<=	"00000000001100100010110100100110";
		special_case_flag_out_expected		<=	special_case_flag;
		
		wait for CLK_period / 2;
		
		--	Exp != 0 & exp > #z
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0100101100011001000101101001001100000";
		
		wait for CLK_period / 2;
		
		result_expected							<=	"01001010010010001011010010011000";
		special_case_flag_out_expected		<=	special_case_flag;
		
		wait for CLK_period / 2;
		
		--	Exp != 0 & exp = #z
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0000000100011001000101101001001100000";
		
		wait for CLK_period / 2;
		
		result_expected							<=	"00000000011001000101101001001100";
		special_case_flag_out_expected		<=	special_case_flag;
		
		wait for CLK_period / 2;
		
		--	Exp != 0 & exp < #z
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0000000100001100100010110100100110000";
		
		wait for CLK_period / 2;
		
		result_expected							<=	"00000000001100100010110100100110";
		special_case_flag_out_expected		<=	special_case_flag;
		
		wait for CLK_period / 2;
		
		--	No rounding
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0100101101011001000101101001001100000";
		
		wait for CLK_period / 2;
		
		result_expected							<=	"01001011001100100010110100100110";
		special_case_flag_out_expected		<=	special_case_flag;
		
		wait for CLK_period / 2;
		
		--	Rounding without overflow
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0100101101011001000101101001001101000";
		
		wait for CLK_period / 2;
		
		result_expected							<=	"01001011001100100010110100100111";
		special_case_flag_out_expected		<=	special_case_flag;
		
		wait for CLK_period / 2;
		
		--	Rounding with overflow but no special case
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0100101101111111111111111111111111000";
		
		wait for CLK_period / 2;
		
		result_expected							<=	"01001011100000000000000000000000";
		special_case_flag_out_expected		<=	special_case_flag;
		
		wait for CLK_period / 2;
		
		--	Rounding with overflow and special case
		special_case_flag							<=	'0';
		special_case_result						<= "--------------------------------";
		value											<=	"0111111101111111111111111111111111000";
		
		wait for CLK_period / 2;
		
		result_expected							<=	"01111111100000000000000000000000";
		special_case_flag_out_expected		<=	'1';
		
		wait for CLK_period / 2;
		
		--	Special case propagation
		special_case_flag							<=	'1';
		special_case_result						<= "11111111100000000000000000000000";
		value											<=	"-------------------------------------";
		
		wait for CLK_period / 2;
		
		result_expected							<=	"11111111100000000000000000000000";
		special_case_flag_out_expected		<=	'1';
		
		wait;
		
	end process;
end;
