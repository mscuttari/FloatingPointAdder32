--------------------------------------------------------------------------------
-- Module Name:   TestStageTwo
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module StageTwo
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestStageTwo is
end TestStageTwo;

architecture behavior of TestStageTwo is 
	component StageTwo
		port (
			CLK								:	in		std_logic;
			special_case_flag_in			:	in		std_logic;
			special_case_result_in		:	in		std_logic_vector(31 downto 0);
			operand_1						:	in		std_logic_vector(31 downto 0);
			operand_2						:	in		std_logic_vector(31 downto 0);
			mantissa_shift_amount		:	in		std_logic_vector(0 to 7);
			special_case_flag_out		:	out	std_logic;
			special_case_result_out		:	out	std_logic_vector(31 downto 0);
			sum								:	out	std_logic_vector(36 downto 0)
		);
	end component;
	
	-- Data signals
	signal CLK											:	std_logic;
	signal special_case_flag_in					:	std_logic;
	signal special_case_result_in					:	std_logic_vector(31 downto 0);
	signal operand_1									:	std_logic_vector(31 downto 0);
	signal operand_2									:	std_logic_vector(31 downto 0);
	signal mantissa_shift_amount					:	std_logic_vector(0 to 7);
	signal special_case_flag_out					:	std_logic;
	signal special_case_result_out				:	std_logic_vector(31 downto 0);
	signal sum											:	std_logic_vector(36 downto 0);
	
	signal special_case_flag_out_expected		:	std_logic;
	signal special_case_result_out_expected	:	std_logic_vector(31 downto 0);
	signal sum_expected								:	std_logic_vector(36 downto 0);
	
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
	
	uut: StageTwo
		port map (
			CLK								=>	CLK,
			special_case_flag_in			=>	special_case_flag_in,
			special_case_result_in		=>	special_case_result_in,
			operand_1						=>	operand_1,
			operand_2						=>	operand_2,
			mantissa_shift_amount		=>	mantissa_shift_amount,
			special_case_flag_out		=>	special_case_flag_out,
			special_case_result_out		=>	special_case_result_out,
			sum								=>	sum
		);
		
	test: check <= '1' when special_case_flag_out = special_case_flag_out_expected and
									special_case_result_out = special_case_result_out_expected and
									sum = sum_expected
						else '0';
	
   stim_proc: process
   begin
		
		special_case_flag_out_expected	<= 'U';
		special_case_result_out_expected	<= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
		sum_expected							<= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
		
		-- Mantissa shifted by 0 positions, with overflow and without special case assignation
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "01001011010010110110101001001011";
		operand_2								<= "01001011000101001010100101010110";
		mantissa_shift_amount				<= "00000000";
		
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "0100101111011000000001001110100001000";
		
		wait for CLK_period / 2;
		
		-- Mantissa shifted by 10 positions, without overflow and without special case assignation
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "01000110010010110110101001001011";
		operand_2								<= "01001011000101001010100101010110";
		mantissa_shift_amount				<= "00001010";
		
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "0100101101001010011011100001100001001";
		
		wait for CLK_period / 2;
		
		-- Mantissa shifted by 23 positions, without overflow and without special case assignation
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "00111111110010110110101001001011";
		operand_2								<= "01001011000101001010100101010110";
		mantissa_shift_amount				<= "00010111";
		
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "0100101101001010010101001010101111001";
		
		wait for CLK_period / 2;
		
		-- Mantissa shifted by 57 positions, without overflow and without special case assignation
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "00111111110010110110101001001011";
		operand_2								<= "01001011000101001010100101010110";
		mantissa_shift_amount				<= "00111001";
		
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "0100101101001010010101001010101100000";
		
		wait for CLK_period / 2;
		
		-- S1 = +, S2 = +, M1 > M2
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "01001011010010110110101001001011";
		operand_2								<= "01001011000101001010100101010110";
		mantissa_shift_amount				<= "00000000";
		
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "0100101111011000000001001110100001000";
		
		wait for CLK_period / 2;
		
		-- S1 = +, S2 = +, M1 < M2
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "01001011000101001010100101010110";
		operand_2								<= "01001011010010110110101001001011";
		mantissa_shift_amount				<= "00000000";
	
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "0100101111011000000001001110100001000";
		
		wait for CLK_period / 2;
		
		-- S1 = +, S2 = -, M1 > M2
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "01001011010010110110101001001011";
		operand_2								<= "11001011000101001010100101010110";
		mantissa_shift_amount				<= "00000000";
		
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "0100101100011011011000000111101010000";
		
		wait for CLK_period / 2;
		
		-- S1 = +, S2 = -, M1 < M2
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "01001011000101001010100101010110";
		operand_2								<= "11001011010010110110101001001011";
		mantissa_shift_amount				<= "00000000";
		
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "1100101100011011011000000111101010000";
		
		wait for CLK_period / 2;
		
		-- S1 = -, S2 = +, M1 > M2
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "11001011010010110110101001001011";
		operand_2								<= "01001011000101001010100101010110";
		mantissa_shift_amount				<= "00000000";
		
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "1100101100011011011000000111101010000";
		
		wait for CLK_period / 2;
		
		-- S1 = -, S2 = +, M1 < M2
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "11001011000101001010100101010110";
		operand_2								<= "01001011010010110110101001001011";
		mantissa_shift_amount				<= "00000000";
		
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "0100101100011011011000000111101010000";
		
		wait for CLK_period / 2;
		
		-- S1 = -, S2 = -, M1 > M2
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "11001011010010110110101001001011";
		operand_2								<= "11001011000101001010100101010110";
		mantissa_shift_amount				<= "00000000";
		
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "1100101111011000000001001110100001000";
		
		wait for CLK_period / 2;
		
		-- S1 = -, S2 = -, M1 < M2
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "11001011000101001010100101010110";
		operand_2								<= "11001011010010110110101001001011";
		mantissa_shift_amount				<= "00000000";
	
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '0';
		special_case_result_out_expected	<= special_case_result_in;
		sum_expected							<= "1100101111011000000001001110100001000";
		
		wait for CLK_period / 2;
		
		--	Infinite result
		special_case_flag_in					<= '0';
		special_case_result_in				<= "--------------------------------";
		operand_1								<= "01111111000101001010100101010110";
		operand_2								<= "01111111010010110110101001001011";
		mantissa_shift_amount				<= "00000000";
	
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '1';
		special_case_result_out_expected	<= "01111111100000000000000000000000";
		sum_expected							<= "-------------------------------------";
		
		wait for CLK_period / 2;
		
		--	Special case propagation
		special_case_flag_in					<= '1';
		special_case_result_in				<= "11111111100000000000000000000000";
		operand_1								<= "--------------------------------";
		operand_2								<= "--------------------------------";
		mantissa_shift_amount				<= "--------";
	
		wait for CLK_period / 2;
		
		special_case_flag_out_expected	<= '1';
		special_case_result_out_expected	<= "11111111100000000000000000000000";
		sum_expected							<= "-------------------------------------";
		
		wait;
		
   end process;
end;
