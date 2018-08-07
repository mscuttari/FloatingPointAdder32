--------------------------------------------------------------------------------
-- Module Name:   TestMain
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module Main
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestMain is
end TestMain;

architecture behavior of TestMain is
	component Main
		port (
			CLK									: 	in		std_logic;
			a, b									: 	in		std_logic_vector(31 downto 0);
			result								: 	out	std_logic_vector(31 downto 0);
			
			stage1_special_case_flag		:	out	std_logic;
			stage1_special_case_result		:	out	std_logic_vector(31 downto 0);
			stage1_operand_1					:	out	std_logic_vector(31 downto 0);
			stage1_operand_2					:	out	std_logic_vector(31 downto 0);
			stage1_mantissa_shift_amount	: 	out	std_logic_vector(0 to 7);
			
			stage2_special_case_flag		:	out	std_logic;
			stage2_special_case_result		:	out	std_logic_vector(31 downto 0);
			stage2_sum							:	out	std_logic_vector(36 downto 0);
			
			stage3_special_case_flag		:	out	std_logic
		);
	end component;
	
	-- Data signals
	signal CLK 		: std_logic;
   signal a, b 	: std_logic_vector(31 downto 0);
	signal result 	: std_logic_vector(31 downto 0);
	
	signal result_expected						:	std_logic_vector(31 downto 0);
	
	signal check									:	std_logic;
	
	-- Debug
	signal stage1_special_case_flag			:	std_logic;
	signal stage1_special_case_result		:	std_logic_vector(31 downto 0);
	signal stage1_operand_1						:	std_logic_vector(31 downto 0);
	signal stage1_operand_2						:	std_logic_vector(31 downto 0);
	signal stage1_mantissa_shift_amount		: 	std_logic_vector(0 to 7); 
	
	signal stage2_special_case_flag			:	std_logic;
	signal stage2_special_case_result		:	std_logic_vector(31 downto 0);
	signal stage2_sum								:	std_logic_vector(36 downto 0);
	
	signal stage3_special_case_flag			:	std_logic;
	
   -- Clock period
   constant CLK_period : time := 80 ns;
	
begin

	-- Clock definition
   CLK_process: process
   begin
		CLK <= '0';
		wait for CLK_period / 2;
		CLK <= '1';
		wait for CLK_period / 2;
   end process;
	
	uut: Main
		port map (
			CLK 		=> CLK,
			a 			=> a,
         b 			=> b,
         result	=> result,
			
			stage1_special_case_flag		=>	stage1_special_case_flag,
			stage1_special_case_result		=>	stage1_special_case_result,
			stage1_operand_1					=>	stage1_operand_1,
			stage1_operand_2					=>	stage1_operand_2,
			stage1_mantissa_shift_amount 	=>	stage1_mantissa_shift_amount,
			
			stage2_special_case_flag		=>	stage2_special_case_flag,
			stage2_special_case_result		=>	stage2_special_case_result,
			stage2_sum							=>	stage2_sum,
			
			stage3_special_case_flag		=>	stage3_special_case_flag
		);
		
	test:	check <= '1' when result = result_expected
						else '0';
	
   stim_proc: process
   begin
	
		result_expected <= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
	
		wait for CLK_period * 4;
		
		-- Test 1
		a <= "00000000000000000000000000000000";
		b <= "01111110110101010101010101010101";
		
		wait for CLK_period / 2;
		wait for CLK_period / 2;
		
		-- Test 2
		a <= "01111111010101010101010101010101";
		b <= "11111111100000000000000000000000";
		
		wait for CLK_period / 2;
		wait for CLK_period / 2;
		
		-- Test 3
		a <= "11111111100000000000000000000000";
		b <= "11111111100000000000000000000000";
		
		wait for CLK_period / 2;
		wait for CLK_period / 2;
		
		-- Test 4
		a <= "11111111100000000000000000000000";
		b <= "01111111100000000000000000000000";
		
		wait for CLK_period / 2;
		
		-- Result test 1
		result_expected <= "01111110110101010101010101010101";
		
		wait for CLK_period / 2;
		
		-- Test 5
		a <= "11111111100000000000000000000000";
		b <= "01111111110101010101010101010101";
		
		wait for CLK_period / 2;
		
		-- Result test 2
		result_expected <= "11111111100000000000000000000000";
		
		wait for CLK_period / 2;
		
		-- Test 6
		a <= "01111110110101010101010101010101";
		b <= "11111110110101010101010101010001";
		
		wait for CLK_period / 2;
		
		-- Result test 3
		result_expected <= "11111111100000000000000000000000";
		
		wait for CLK_period / 2;
		
		-- Test 7
		a <= "01111010101010100101010110101010";
		b <= "11111010110101010101010101010101";
		
		wait for CLK_period / 2;
		
		-- Result test 4
		result_expected <= "01111111100000000000000000000001";
		
		wait for CLK_period / 2;
		
		-- Test 8
		a <= "11111101010011001100110011001100";
		b <= "01111101001010100101010110101010";
		
		wait for CLK_period / 2;
		
		-- Result test 5
		result_expected <= "01111111100000000000000000000001";
		
		wait for CLK_period / 2;
		
		-- Test 9
		a <= "11111000010111011101110111011101";
		b <= "11111000010111001101110011011100";
		
		wait for CLK_period / 2;
		
		-- Result test 6
		result_expected <= "01110100000000000000000000000000";
		
		wait for CLK_period / 2;
		
		-- Test 10
		a <= "01111100110111011101110111011101";
		b <= "01111011110111001101110011011100";
		
		wait for CLK_period / 2;
		
		-- Result test 7
		result_expected <= "11111001101010111111111010101100";
		
		wait for CLK_period / 2;
		
		-- Test 11
		a <= "00000000010101010101010101010001";
		b <= "00000000010101010101010101010101";
		
		wait for CLK_period / 2;
		
		-- Result test 8
		result_expected <= "11111100000010011101110010001000";
		
		wait for CLK_period / 2;
		
		-- Test 12
		a <= "00000000011111111111111111111111";
		b <= "10000000001010100101010110101010";
		
		wait for CLK_period / 2;
		
		-- Result test 9
		result_expected <= "11111000110111010101110101011101";
		
		wait for CLK_period / 2;
		
		-- Test 13
		a <= "00000000001010100101010110101010";
		b <= "10000000011111111111111111111111";
		
		wait for CLK_period / 2;
		
		-- Result test 10
		result_expected <= "01111101000010101000101010001010";
		
		wait for CLK_period / 2;
		
		-- Test 14
		a <= "10000000010111011101110111011101";
		b <= "00000000000111011101110111011101";
		
		wait for CLK_period / 2;
		
		-- Result test 11
		result_expected <= "00000000101010101010101010100110";
		
		wait for CLK_period / 2;
		
		-- Test 15
		a <= "10000000010111001101110011011100";
		b <= "10000000010111011101110111011101";
		
		wait for CLK_period / 2;
		
		-- Result test 12
		result_expected <= "00000000010101011010101001010101";
		
		wait for CLK_period / 2;
		
		-- Test 16
		a <= "00000010010101010101010101010001";
		b <= "00000000010101010101010101010101";
		
		wait for CLK_period / 2;
		
		-- Result test 13
		result_expected <= "10000000010101011010101001010101";
		
		wait for CLK_period / 2;
		
		-- Test 17
		a <= "10000100010101010101010101010101";
		b <= "10000000010101010101010101010101";
		
		wait for CLK_period / 2;
		
		-- Result test 14
		result_expected <= "10000000010000000000000000000000";
		
		wait for CLK_period / 2;
		
		-- Test 18
		a <= "00000101001010100101010110101010";
		b <= "00000000011111111111111111111111";
		
		wait for CLK_period / 2;
		
		-- Result test 15
		result_expected <= "10000000101110101011101010111001";
		
		wait for CLK_period / 2;
		
		-- Test 19
		a <= "10000000010101010101010101010101";
		b <= "00000010100111011101110111011101";
		
		wait for CLK_period / 2;
		
		-- Result test 16
		result_expected <= "00000010010111111111111111111100";
		
		wait for CLK_period / 2;
		
		-- Test 20
		a <= "10000000010101010101010101010101";
		b <= "00000111101010101010101010101010";
		
		wait for CLK_period / 2;
		
		-- Result test 17
		result_expected <= "10000100010101100000000000000000";
		
		wait for CLK_period / 2;
		
		wait for CLK_period / 2;
		
		-- Result test 18
		result_expected <= "00000101001010101001010110101010";
		
		wait for CLK_period / 2;
		
		wait for CLK_period / 2;
		
		-- Result test 19
		result_expected <= "00000010100110001000100010001000";
		
		wait for CLK_period / 2;
		
		wait for CLK_period / 2;
		
		-- Result test 20
		result_expected <= "00000111101010101010100101010101";
		
		wait for CLK_period / 2;
		
		wait;
		
   end process;
end;
