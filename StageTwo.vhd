----------------------------------------------------------------------------------
-- Module Name:    	StageTwo
-- Project Name: 		32 bit floating point adder
-- Description: 		Stage two of the pipeline
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity StageTwo is
	port (
		CLK								:	in		std_logic;								-- Clock signal
		special_case_flag_in			:	in		std_logic;								-- Whether the operands leads to a special case
		special_case_result_in		:	in		std_logic_vector(31 downto 0);	-- Special case result
		operand_1						:	in		std_logic_vector(31 downto 0);	-- Operand with the lowest exponent
		operand_2						:	in		std_logic_vector(31 downto 0);	-- Operand with the highest exponent
		mantissa_shift_amount		:	in		std_logic_vector(0 to 7);			-- Difference between the highest and the lowest exponent
		special_case_flag_out		:	out	std_logic;								-- Whether there is a special case or not
		special_case_result_out		:	out	std_logic_vector(31 downto 0);	-- Special case result
		sum								:	out	std_logic_vector(36 downto 0)		-- Sum between the two operands
	);
end StageTwo;

architecture Behavioral of StageTwo is
	
	constant registers_number : integer := 70;
	
	-- Operands with extended mantissa
	signal operand_1_extended	:	std_logic_vector(36 downto 0);
	signal operand_2_extended	:	std_logic_vector(36 downto 0);
	
	-- Operand with the lowest exponent
	alias sign_1		is operand_1_extended(36);
	alias exponent_1	is operand_1_extended(35 downto 28);
	alias mantissa_1	is operand_1_extended(27 downto 0);
		
	-- Operand with the highest exponent
	alias sign_2		is operand_2_extended(36);
	alias exponent_2	is operand_2_extended(35 downto 28);
	alias mantissa_2	is operand_2_extended(27 downto 0);
	
	-- Temporary signals
	-- "_dff" is used to indicate the signal before entering the registers
	
	signal normalized_1_flag	:	std_logic;								--	Whether the first value is normalized
	signal normalized_2_flag	:	std_logic;								--	Whether the second value is normalized
	
	-- Mantissa of the operand with the lowest exponent
	signal mantissa_1_dff	:	std_logic_vector(27 downto 0);
	
	-- Sum between the two operands
	signal sum_dff				:	std_logic_vector(36 downto 0);
	signal sum_normal_dff	:	std_logic_vector(36 downto 0);
	alias sign_sum_dff		is sum_normal_dff(36);
	alias exponent_sum_dff	is sum_normal_dff(35 downto 28);
	alias mantissa_sum_dff	is sum_normal_dff(27 downto 0);
	
	--	Sum overflow
	signal sum_overflow	:	std_logic;
	signal overflow_dff	:	std_logic;
	
	signal M1_M2_sum						:	std_logic_vector(27 downto 0);		-- M1 + M2
	signal overflow						:	std_logic;									--	M1 + M2 overflow signal
	signal M1_M2_difference				:	std_logic_vector(27 downto 0);		-- M1 - M2
	signal mantissa_difference_sign	:	std_logic;									-- Sign of the difference between M1 and M2
	signal M2_M1_difference				:	std_logic_vector(27 downto 0);		-- M2 - M1
	
	--	Intermediate results
	signal mantissa_sum					:	std_logic_vector(27 downto 0);		-- Intermediate mantissa result
	signal exponent_sum					:	std_logic_vector(7 downto 0);			--	Intermediate exponent result
	
	--	Results used with positive overflow signal
	signal mantissa_after_sum_shift	:	std_logic_vector(27 downto 0);		--	1-position shifted mantissa (after sum)
	signal mantissa_after_overflow	:	std_logic_vector(27 downto 0);		--	Mantissa with positive overflow
	signal exponent_after_sum_shift	:	std_logic_vector(7 downto 0);			--	Exponent with positive overflow
	
	-- Special cases
	signal sum_infinite_check			:	std_logic;
	signal special_case_flag_dff		:	std_logic;
	signal special_case_result_dff	:	std_logic_vector(31 downto 0);
	
	-- Registers
	signal D, Q : std_logic_vector(0 to registers_number - 1);
	
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
	
	-- Mantissa extender
	component MantissaExtender
		port (
			input_mantissa		:	in		std_logic_vector(22 downto 0);
			normalized			:	in		std_logic;
			output_mantissa	:	out	std_logic_vector(27 downto 0)
		);
	end component;
	
	-- Mantissa right shifter
	component MantissaRightShifter
		port (
			x				:	in 	std_logic_vector(27 downto 0);
			pos			:	in		std_logic_vector(7 downto 0);
			y				:	out	std_logic_vector(27 downto 0)
		);
	end component;
	
	-- Ripple carry adder
	component RippleCarryAdder
		generic (
			n : integer
		);
		port (
			x, y 		: in  	std_logic_vector(n-1 downto 0);
			result	: out		std_logic_vector(n-1 downto 0);
			overflow	: out		std_logic
		);
	end component;
	
	-- Ripple carry subtractor
	component RippleCarrySubtractor
		generic (
			n : integer
		);
		port (
			x, y 			: in  	std_logic_vector(n-1 downto 0);
			result		: out		std_logic_vector(n-1 downto 0);
			result_sign	: out		std_logic
		);
	end component;
	
	-- Right shifter
	component RightShifter
		generic (
			n : integer;
			s : integer
		);
		port (
			x 	: in  	std_logic_vector(n-1 downto 0);
			y	: out 	std_logic_vector(n-1 downto 0)
		);
	end component;

begin
	
	-- Copy signs and exponents
	sign_1 		<= operand_1(31);
	exponent_1 	<= operand_1(30 downto 23);
	sign_2 		<= operand_2(31);
	exponent_2 	<= operand_2(30 downto 23);
	

	--	Check whether input values are normalized
	normalized_1_flag	<=	'0' when exponent_1 = "00000000" else '1';
	normalized_2_flag	<=	'0' when exponent_2 = "00000000" else '1';
	
	-- Mantissa 1 extension
	mantissa_1_extender:	MantissaExtender
		port map (
			input_mantissa		=>	operand_1(22 downto 0),
			normalized			=>	normalized_1_flag,
			output_mantissa	=> mantissa_1
		);
	
	-- Mantissa 2 extension
	mantissa_extender_2:	MantissaExtender
		port map (
			input_mantissa		=>	operand_2(22 downto 0),
			normalized			=>	normalized_2_flag,
			output_mantissa	=> mantissa_2
		);
	
	-- Mantissa right shifter
	mantissa_right_shifter: MantissaRightShifter
		port map (
			x 		=> mantissa_1,
			pos 	=> mantissa_shift_amount,
			y 		=> mantissa_1_dff
		);
	
	-- M1 + M2
	mantissa_sum_component: RippleCarryAdder
		generic map (
			n => 28
		)
		port map (
         x 				=> mantissa_1_dff,
			y 				=> mantissa_2,
			result		=> M1_M2_sum,
			overflow 	=> sum_overflow
		);
	
	-- M1 - M2
	mantissa_sub_1: RippleCarrySubtractor
		generic map (
			n => 28
		)
		port map (
         x 				=> mantissa_1_dff,
			y 				=> mantissa_2,
			result		=> M1_M2_difference,
			result_sign	=>	mantissa_difference_sign
		);
	
	-- M2 - M1
	mantissa_sub_2: RippleCarrySubtractor
		generic map (
			n => 28
		)
		port map (
         x			=> mantissa_2,
			y			=> mantissa_1_dff,
			result	=> M2_M1_difference
		);
	
	-- Sign
	sign_sum_dff <= sign_2 when mantissa_difference_sign = '1' else sign_1;
	
	-- Mantissa
	mantissa_sum <=	M1_M2_sum			when	sign_1 = sign_2						else
							M1_M2_difference	when	mantissa_difference_sign = '0'	else
							M2_M1_difference	when	mantissa_difference_sign = '1'	else
							(others => '-');
	
	-- Exponent
	exponent_sum <= exponent_2;
	
	-- Overflow
	overflow_dff <= '1' when (sum_overflow = '1' and sign_1 = sign_2) else '0';
										
	--	If the sum produced an overflow, insert a '1' as the most significant bit
	right_shifter_sum: RightShifter
		generic map (
			n	=> 28,
			s	=> 1
		)
		port map (
			x 	=> mantissa_sum,
			y 	=> mantissa_after_sum_shift
		);
	
	mantissa_after_overflow <= '1' & mantissa_after_sum_shift(26 downto 0);
		
	-- If the sum produced an overflow, increase the exponent by 1	
	exponent_increase_sum: RippleCarryAdder
		generic map (
			n => 8
		)
		port map (
         x			=> exponent_sum,
			y			=> "00000001",
			result	=> exponent_after_sum_shift
		);
	
	mantissa_sum_dff <= mantissa_after_overflow	when overflow_dff = '1' else mantissa_sum;
	exponent_sum_dff <= exponent_after_sum_shift when overflow_dff = '1' else exponent_sum;
												
	-- Check if the sum produces an infinite value
	sum_infinite_check <= '1' when overflow_dff = '1' and exponent_2 = "11111110" else '0';
										
	special_case_flag_dff <= '1' when (special_case_flag_in = '1') or (sum_infinite_check = '1') else '0';

	special_case_result_dff	<=	sign_sum_dff & "1111111100000000000000000000000" when (sum_infinite_check = '1' and special_case_flag_in = '0') else
										special_case_result_in;
	
	
	sum_dff <= sum_normal_dff when special_case_flag_dff = '0' else
				  "-------------------------------------";
										
	-- Connect the registers
	reg: Registers
		generic map (
			n => registers_number
		)
		port map (
         CLK	=> CLK,
			D		=> D,
			Q		=> Q
		);
	
	D <= 	special_case_flag_dff &
			special_case_result_dff &
			sum_dff;
	
	special_case_flag_out <= Q(0);
	special_case_result_out <= Q(1 to 32);
	sum <= Q(33 to 69);
	
end Behavioral;