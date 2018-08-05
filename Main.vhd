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
		stg1_special_case_flag				:	out	std_logic;
		stg1_special_case_result			:	out	std_logic_vector(31 downto 0);
		stg1_operand_1							:	out	std_logic_vector(31 downto 0);
		stg1_operand_2							:	out	std_logic_vector(31 downto 0);
		stg1_mantissa_shift_amount			: 	out	std_logic_vector(0 to 7);
		
		-- Debug stage 2
		stg2_special_case_flag				:	out	std_logic;
		stg2_special_case_result			:	out	std_logic_vector(31 downto 0);
		stg2_sum									:	out	std_logic_vector(36 downto 0);
		
		-- Debug stage 3
		stg3_special_case_flag				:	out	std_logic
	);
end Main;

architecture Behavioral of Main is
	
	-- Temporary signals
	signal stage1_special_case_flag		:	std_logic;								-- Whether the operands leads to a special case
	signal stage1_special_case_result	:	std_logic_vector(31 downto 0);	-- Special case result
	signal stage1_operand_1					:	std_logic_vector(31 downto 0);	-- Operand with the highest exponent
	signal stage1_operand_2					:	std_logic_vector(31 downto 0);	-- Operand with the lowest exponent
	signal stage1_mantissa_shift_amount	: 	std_logic_vector(0 to 7); 			-- Shift amount for the lowest exponent operand
	
	signal stage2_special_case_flag		:	std_logic;								-- Whether the operands leads to a special case
	signal stage2_special_case_result	:	std_logic_vector(31 downto 0);	-- Special case result
	signal stage2_sum							:	std_logic_vector(36 downto 0);	-- Operand 1 + Operand 2
	
	-- Stage 1
	component StageOne
		port (
			CLK							: 	in		std_logic;
			a, b							: 	in		std_logic_vector(31 downto 0);
			special_case_flag			:	out	std_logic;
			special_case_result		:	out	std_logic_vector(31 downto 0);
			operand_1					: 	out	std_logic_vector(31 downto 0);
			operand_2					: 	out	std_logic_vector(31 downto 0);
			mantissa_shift_amount	: 	out	std_logic_vector(0 to 7)
		);
	end component;
	
	-- Stage 2
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
	
	-- Stage 3
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
	
begin

	-- Stage 1
	stage_one: StageOne
		port map (
			CLK 							=> CLK,
			a								=>	a,
			b								=>	b,
			special_case_flag			=>	stage1_special_case_flag,
			special_case_result		=>	stage1_special_case_result,
			operand_1					=>	stage1_operand_1,
			operand_2					=>	stage1_operand_2,
			mantissa_shift_amount	=>	stage1_mantissa_shift_amount
		);
	
	-- Stage 2
	stage_two: StageTwo
		port map (
			CLK 								=>	CLK,
			special_case_flag_in			=>	stage1_special_case_flag,
			special_case_result_in		=>	stage1_special_case_result,
			operand_1 						=>	stage1_operand_1,
			operand_2 						=>	stage1_operand_2,
			mantissa_shift_amount	 	=> stage1_mantissa_shift_amount,
			special_case_flag_out		=>	stage2_special_case_flag,
			special_case_result_out		=>	stage2_special_case_result,
			sum								=>	stage2_sum
		);
	
	-- Stage 3
	stage_three: StageThree
		port map (
			CLK 								=> CLK,
			special_case_flag				=>	stage2_special_case_flag,
			special_case_result			=>	stage2_special_case_result,
			value								=>	stage2_sum,
			result							=>	result,
			special_case_flag_out		=>	stg3_special_case_flag
		);
	
	-- Debug signals
	stg1_special_case_flag		<=	stage1_special_case_flag;
	stg1_special_case_result	<=	stage1_special_case_result;
	stg1_operand_1					<=	stage1_operand_1;
	stg1_operand_2					<=	stage1_operand_2;
	stg1_mantissa_shift_amount <=	stage1_mantissa_shift_amount;
	
	stg2_special_case_flag		<=	stage2_special_case_flag;
	stg2_special_case_result	<=	stage2_special_case_result;
	stg2_sum							<= stage2_sum;

end Behavioral;