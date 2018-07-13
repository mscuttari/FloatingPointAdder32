----------------------------------------------------------------------------------
-- Module Name:    	Main
-- Project Name: 		32 bit floating point adder
-- Description: 		Main module
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Main is
	port (
		CLK			: 	in		std_logic;									-- Clock signal
		a, b			: 	in		std_logic_vector(31 downto 0);		-- Operands to be added
		result		: 	out	std_logic_vector(31 downto 0);		-- Result
		
		-- Debug stage 1
		stg1_special_case_flag		:	out	std_logic;
		stg1_special_case_result	:	out	std_logic_vector(31 downto 0);
		stg1_operand_1					:	out	std_logic_vector(36 downto 0);
		stg1_operand_2					:	out	std_logic_vector(36 downto 0);
		stg1_d 							:	out 	std_logic_vector(0 to 7);
		stg1_d_abs 						: 	out	std_logic_vector(0 to 7);
		
		-- Debug stage 2
		stg2_operand_1					:	out	std_logic_vector(36 downto 0);
		stg2_operand_1_shifted		:	out	std_logic_vector(36 downto 0);
		
		-- Debug stage 3
		stg3_mantissa_shift			:	out	std_logic_vector(0 to 4);
		stg3_exponent_increase		:	out	std_logic_vector(0 to 7)
	);
end Main;

architecture Behavioral of Main is
	
	-- Temporary signals
	signal stage1_special_case_flag		:	std_logic;								-- Whether the operands leads to a special case
	signal stage1_special_case_result	:	std_logic_vector(31 downto 0);	-- Special case result
	signal stage1_operand_1					:	std_logic_vector(36 downto 0);	-- Operand with the highest exponent
	signal stage1_operand_2					:	std_logic_vector(36 downto 0);	-- Operand with the lowest exponent
	signal stage1_d 							: 	std_logic_vector(0 to 7); 			-- Difference between operand A and operand B exponents
	signal stage1_d_abs 						: 	std_logic_vector(0 to 7); 			-- Difference between the highest exponent and the lowest exponent
	
	signal stage2_special_case_flag		:	std_logic;								-- Whether the operands leads to a special case
	signal stage2_special_case_result	:	std_logic_vector(31 downto 0);	-- Special case result
	signal stage2_sum							:	std_logic_vector(36 downto 0);	-- Operand 1 + Operand 2
	signal stage2_overflow					:	std_logic;								--	Overflow of sum between Operand 1 and Operand 2
	
	-- Stage 1
	component StageOne
		port (
			CLK						:	in		std_logic;
			a, b						:	in		std_logic_vector(31 downto 0);
			special_case_flag		:	out	std_logic;
			special_case_result	:	out	std_logic_vector(31 downto 0);
			operand_1				:	out	std_logic_vector(36 downto 0);
			operand_2				:	out	std_logic_vector(36 downto 0);
			exp_difference			:	out	std_logic_vector(0 to 7);
			exp_difference_abs	:	out	std_logic_vector(0 to 7)
		);
	end component;
	
	-- Stage 2
	component StageTwo
		port (
			CLK							:	in		std_logic;
			special_case_flag_in		:	in		std_logic;
			special_case_result_in	:	in		std_logic_vector(31 downto 0);
			operand_1_in				:	in		std_logic_vector(36 downto 0);
			operand_2_in				:	in		std_logic_vector(36 downto 0);
			exp_difference_in			:	in		std_logic_vector(0 to 7);
			exp_difference_abs_in	:	in		std_logic_vector(0 to 7);
			special_case_flag_out	:	out	std_logic;
			special_case_result_out	:	out	std_logic_vector(31 downto 0);
			sum							:	out	std_logic_vector(36 downto 0);
			overflow						:	out	std_logic;
			operand_1_out				:	out	std_logic_vector(36 downto 0);
			operand_1_shifted			:	out	std_logic_vector(36 downto 0)
		);
	end component;
	
	-- Stage 3
	component StageThree
		port (
			CLK						:	in		std_logic;
			special_case_flag		:	in		std_logic;
			special_case_result	:	in		std_logic_vector(31 downto 0);
			value						:	in		std_logic_vector(36 downto 0);
			overflow					:	in		std_logic;
			normalized_value		:	out	std_logic_vector(31 downto 0);
			mantissa_shift			:	out	std_logic_vector(4 downto 0);
			exponent_increase		:	out	std_logic_vector(7 downto 0)
		);
	end component;
	
begin

	-- Stage 1
	stage_one: StageOne
		port map (
			CLK 						=> CLK,
			a							=>	a,
			b							=>	b,
			special_case_flag		=>	stage1_special_case_flag,
			special_case_result	=>	stage1_special_case_result,
			operand_1				=>	stage1_operand_1,
			operand_2				=>	stage1_operand_2,
			exp_difference			=>	stage1_d,
			exp_difference_abs	=>	stage1_d_abs
		);
	
	-- Stage 2
	stage_two: StageTwo
		port map (
			CLK 							=>	CLK,
			special_case_flag_in		=>	stage1_special_case_flag,
			special_case_result_in	=>	stage1_special_case_result,
			operand_1_in 				=>	stage1_operand_1,
			operand_2_in 				=>	stage1_operand_2,
			exp_difference_in			=>	stage1_d,
			exp_difference_abs_in 	=> stage1_d_abs,
			special_case_flag_out	=>	stage2_special_case_flag,
			special_case_result_out	=>	stage2_special_case_result,
			sum							=>	stage2_sum,
			overflow						=> stage2_overflow,
			operand_1_out				=>	stg2_operand_1,
			operand_1_shifted			=>	stg2_operand_1_shifted
		);
	
	-- Stage 3
	stage_three: StageThree
		port map (
			CLK 							=> CLK,
			special_case_flag			=>	stage2_special_case_flag,
			special_case_result		=>	stage2_special_case_result,
			value							=>	stage2_sum,
			overflow						=> stage2_overflow,
			normalized_value			=>	result,
			mantissa_shift				=>	stg3_mantissa_shift,
			exponent_increase			=>	stg3_exponent_increase
		);
	
	-- Debug signals
	stg1_special_case_flag		<=	stage1_special_case_flag;
	stg1_special_case_result	<=	stage1_special_case_result;
	stg1_operand_1					<=	stage1_operand_1;
	stg1_operand_2					<=	stage1_operand_2;
	stg1_d							<=	stage1_d;
	stg1_d_abs 						<=	stage1_d_abs;

end Behavioral;