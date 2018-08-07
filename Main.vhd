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
		stage1_special_case_flag		:	out	std_logic;
		stage1_special_case_result		:	out	std_logic_vector(31 downto 0);
		stage1_operand_1					:	out	std_logic_vector(31 downto 0);
		stage1_operand_2					:	out	std_logic_vector(31 downto 0);
		stage1_mantissa_shift_amount	: 	out	std_logic_vector(0 to 7);
		
		-- Debug stage 2
		stage2_special_case_flag		:	out	std_logic;
		stage2_special_case_result		:	out	std_logic_vector(31 downto 0);
		stage2_sum							:	out	std_logic_vector(36 downto 0);
		
		-- Debug stage 3
		stage3_special_case_flag		:	out	std_logic
	);
end Main;

architecture Behavioral of Main is
	
	-- Temporary signals
	signal stg1_special_case_flag			:	std_logic;
	signal stg1_special_case_result		:	std_logic_vector(31 downto 0);
	signal stg1_operand_1					:	std_logic_vector(31 downto 0);
	signal stg1_operand_2					:	std_logic_vector(31 downto 0);
	signal stg1_mantissa_shift_amount	: 	std_logic_vector(0 to 7); 
	
	signal stg2_special_case_flag			:	std_logic;
	signal stg2_special_case_result		:	std_logic_vector(31 downto 0);
	signal stg2_sum							:	std_logic_vector(36 downto 0);
	
	signal stg3_result						:	std_logic_vector(31 downto 0);
	signal stg3_special_case_flag			:	std_logic;
	
	-- Registers
	signal D1, Q1 : std_logic_vector(0 to 104);
	signal D2, Q2 : std_logic_vector(0 to 69);
	signal D3, Q3 : std_logic_vector(0 to 32);
	
	component Registers
		generic (
			n : integer
		);
		port (
			CLK	:	in		std_logic;
			D		: 	in 	std_logic_vector(0 to n-1);
			Q		: 	out	std_logic_vector(0 to n-1)
		);
	end component;
	
	-- Stage 1
	component StageOne
		port (
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
			special_case_flag				:	in		std_logic;
			special_case_result			:	in		std_logic_vector(31 downto 0);
			value								:	in		std_logic_vector(36 downto 0);
			result							:	out	std_logic_vector(31 downto 0);
			special_case_flag_out		:	out	std_logic
		);
	end component;
	
begin

	-- Stage 1
	stage_1: StageOne
		port map (
			a								=>	a,
			b								=>	b,
			special_case_flag			=>	stg1_special_case_flag,
			special_case_result		=>	stg1_special_case_result,
			operand_1					=>	stg1_operand_1,
			operand_2					=>	stg1_operand_2,
			mantissa_shift_amount	=>	stg1_mantissa_shift_amount
		);
	
	D1	<=	stg1_special_case_flag &
			stg1_special_case_result &
			stg1_operand_1 &
			stg1_operand_2 &
			stg1_mantissa_shift_amount;
	
	registers_1: Registers
		generic map (
			n => 105
		)
		port map (
			CLK 	=>	CLK,
			D		=>	D1,
			Q		=>	Q1
		);
	
	-- Stage 2
	stage_2: StageTwo
		port map (
			special_case_flag_in			=>	Q1(0),
			special_case_result_in		=>	Q1(1 to 32),
			operand_1 						=>	Q1(33 to 64),
			operand_2 						=>	Q1(65 to 96),
			mantissa_shift_amount	 	=> Q1(97 to 104),
			special_case_flag_out		=>	stg2_special_case_flag,
			special_case_result_out		=>	stg2_special_case_result,
			sum								=>	stg2_sum
		);
	
	D2 <= stg2_special_case_flag &
			stg2_special_case_result &
			stg2_sum;
	
	registers_2: Registers
		generic map (
			n => 70
		)
		port map (
			CLK 	=>	CLK,
			D		=>	D2,
			Q		=>	Q2
		);
	
	-- Stage 3
	stage_3: StageThree
		port map (
			special_case_flag				=>	Q2(0),
			special_case_result			=>	Q2(1 to 32),
			value								=>	Q2(33 to 69),
			result							=>	stg3_result,
			special_case_flag_out		=>	stg3_special_case_flag
		);
	
	D3 <= stg3_result &
			stg3_special_case_flag;
	
	registers_3: Registers
		generic map (
			n => 33
		)
		port map (
			CLK 	=>	CLK,
			D		=>	D3,
			Q		=>	Q3
		);
	
	result <= Q3(0 to 31);
	
	-- Debug signals
	stage1_special_case_flag		<=	Q1(0);
	stage1_special_case_result		<=	Q1(1 to 32);
	stage1_operand_1 					<=	Q1(33 to 64);
	stage1_operand_2 					<=	Q1(65 to 96);
	stage1_mantissa_shift_amount	<= Q1(97 to 104);
	
	stage2_special_case_flag		<=	Q2(0);
	stage2_special_case_result		<=	Q2(1 to 32);
	stage2_sum							<=	Q2(33 to 69);
	
	stage3_special_case_flag		<=	Q3(32);

end Behavioral;