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
		stg1_operand_1				:	out	std_logic_vector(31 downto 0);
		stg1_operand_2				:	out	std_logic_vector(31 downto 0);
		stg1_d 						:	out 	std_logic_vector(0 to 7);
		stg1_d_abs 					: 	out	std_logic_vector(0 to 7);
		
		-- Debug stage 2
		stg2_sum						:	out	std_logic_vector(31 downto 0);
		stg2_operand_1				:	out	std_logic_vector(31 downto 0);
		stg2_operand_1_shifted	:	out	std_logic_vector(31 downto 0);
		stg2_operand_2				:	out	std_logic_vector(31 downto 0);
		stg2_d 						:	out 	std_logic_vector(0 to 7);
		stg2_d_abs 					: 	out	std_logic_vector(0 to 7)
	);
end Main;

architecture Behavioral of Main is
	
	-- Temporary signals
	signal stage1_operand_1	:	std_logic_vector(31 downto 0);	-- Operand with the highest exponent
	signal stage1_operand_2	:	std_logic_vector(31 downto 0);	-- Operand with the lowest exponent
	signal stage1_d 			: 	std_logic_vector(0 to 7); 			-- Difference between operand A and operand B exponents
	signal stage1_d_abs 		: 	std_logic_vector(0 to 7); 			-- Difference between the highest exponent and the lowest exponent
	
	signal stage2_sum			:	std_logic_vector(31 downto 0);	-- Operand 1 + Operand 2
	
	-- Stage 1
	component StageOne
		port (
			CLK						:	in		std_logic;
			a, b						:	in		std_logic_vector(31 downto 0);
			operand_1				:	out	std_logic_vector(31 downto 0);
			operand_2				:	out	std_logic_vector(31 downto 0);
			exp_difference			:	out	std_logic_vector(0 to 7);
			exp_difference_abs	:	out	std_logic_vector(0 to 7)
		);
	end component;
	
	-- Stage 2
	component StageTwo
		port (
			CLK							:	in		std_logic;
			operand_1_in				:	in		std_logic_vector(31 downto 0);
			operand_2_in				:	in		std_logic_vector(31 downto 0);
			exp_difference_in			:	in		std_logic_vector(0 to 7);
			exp_difference_abs_in	:	in		std_logic_vector(0 to 7);
			sum							:	out	std_logic_vector(31 downto 0);
			operand_1_out				:	out	std_logic_vector(31 downto 0);
			operand_1_shifted			:	out	std_logic_vector(31 downto 0);
			operand_2_out				:	out	std_logic_vector(31 downto 0);
			exp_difference_out		:	out	std_logic_vector(0 to 7);
			exp_difference_abs_out	:	out	std_logic_vector(0 to 7)
		);
	end component;
	
begin

	-- Stage 1
	stage_one: StageOne
		port map (
			CLK 						=> CLK,
			a							=>	a,
			b							=>	b,
			operand_1				=>	stage1_operand_1,
			operand_2				=>	stage1_operand_2,
			exp_difference			=>	stage1_d,
			exp_difference_abs	=>	stage1_d_abs
		);
	
	-- Stage 2
	stage_two: StageTwo
		port map (
			CLK 							=>	CLK,
			operand_1_in 				=>	stage1_operand_1,
			operand_2_in 				=>	stage1_operand_2,
			exp_difference_in			=>	stage1_d,
			exp_difference_abs_in 	=> stage1_d_abs,
			sum							=>	stage2_sum,
			operand_1_out				=>	stg2_operand_1,
			operand_1_shifted			=>	stg2_operand_1_shifted,
			operand_2_out				=>	stg2_operand_2,
			exp_difference_out		=>	stg2_d,
			exp_difference_abs_out	=>	stg2_d_abs
		);
	
	result <= stage2_sum;
	
	-- Debug signals
	stg1_operand_1				<=	stage1_operand_1;
	stg1_operand_2				<=	stage1_operand_2;
	stg1_d						<=	stage1_d;
	stg1_d_abs 					<=	stage1_d_abs;
	
	stg2_sum						<=	stage2_sum;

end Behavioral;