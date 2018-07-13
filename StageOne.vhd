----------------------------------------------------------------------------------
-- Module Name:    	StageOne
-- Project Name: 		32 bit floating point adder
-- Description: 		Stage one of the pipeline
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity StageOne is
	port (
		CLK						: 	in		std_logic;								-- Clock signal
		a, b						: 	in		std_logic_vector(31 downto 0);	-- Operands
		special_case_flag		:	out	std_logic;								-- Whether the operands leads to a special case
		special_case_result	:	out	std_logic_vector(31 downto 0);	-- Special case result
		operand_1				: 	out	std_logic_vector(36 downto 0);	-- Operand with the lowest exponent
		operand_2				: 	out	std_logic_vector(36 downto 0);	-- Operand with the highest exponent
		exp_difference			: 	out 	std_logic_vector(0 to 7);			-- Difference between operand A and operand B exponents
		exp_difference_abs	: 	out	std_logic_vector(0 to 7)			-- Difference between the highest and the lowest exponent
	);
end StageOne;

architecture Behavioral of StageOne is
	
	constant registers_number : integer := 123;

	-- Temporary signals
	-- "_dff" is used to indicate the signal before entering the registers
	signal special_case_flag_dff		:	std_logic;								-- Whether the operands leads to a special case
	signal special_case_result_dff	:	std_logic_vector(31 downto 0);	-- Special case result
	signal normalized_a_flag			:	std_logic;								--	Whether the first value is normalized
	signal normalized_b_flag			:	std_logic;								--	Whether the second value is normalized
	signal exponent_a_to_sub			:	std_logic_vector(7 downto 0);		--	Exponent a to subtract
	signal exponent_b_to_sub			:	std_logic_vector(7 downto 0);		--	Exponent b to subtract
	signal operand_1_before_swap		:	std_logic_vector(36 downto 0);	--	Operand a before swap
	signal operand_2_before_swap		:	std_logic_vector(36 downto 0);	--	Operand b before swap
	signal operand_1_dff					:	std_logic_vector(36 downto 0);	-- Operand with the lowest exponent
	signal operand_2_dff					:	std_logic_vector(36 downto 0);	-- Operand with the highest exponent
	signal exp_difference_dff			: 	std_logic_vector(0 to 7);			-- Difference between operand A and operand B exponents
	signal exp_difference_norm			:	std_logic_vector(7 downto 0);		--	Effective difference between operand A and B exponents (considering denormalized numbers too)
	signal exp_difference_sign			:	std_logic;								--	Sign of the difference between exponents
	signal exp_difference_abs_dff		:	std_logic_vector(0 to 7);			-- Absolute value of exp_difference_dff
	signal mantissa_extended_a			:	std_logic_vector(27 downto 0);	--	Extended mantissa a
	signal mantissa_extended_b			:	std_logic_vector(27 downto 0);	--	Extended mantissa b
	
	-- Operand A
	alias sign_A is a(31);
	alias exponent_A is a(30 downto 23);
	alias mantissa_A is a(22 downto 0);
	
	-- Operand B
	alias sign_B is b(31);
	alias exponent_B is b(30 downto 23);
	alias mantissa_B is b(22 downto 0);
	
	-- Registers
	signal D, Q : std_logic_vector(0 to registers_number - 1);
	
	component RegisterN
		generic (
			n : integer
		);
		port (
			CLK	:	in		std_logic;
			D		: 	in 	std_logic_vector(0 to n-1);
			Q		: 	out	std_logic_vector(0 to n-1)
		);
	end component;
	
	-- Particular cases
	component ParticularCaseAssignation
		port (
			a					:	in 	std_logic_vector(31 downto 0);
			b					:	in 	std_logic_vector(31 downto 0);
			enable			:	out	std_logic;
			result			:	out	std_logic_vector(31 downto 0);
			normalized_a	:	out	std_logic;
			normalized_b	:	out	std_logic
		);
	end component;
	
	-- Mantissa extender
	component MantissaExtender
		generic (
			i	:	integer;
			g	:	integer
		);
		port (
			input_mantissa		:	in		std_logic_vector(i-1 downto 0);
			normalized			:	in		std_logic;
			output_mantissa	:	out	std_logic_vector(i+g downto 0)
		);
	end component;
	
	-- Ripple carry subtractor
	component RippleCarrySubtractor
		generic (
			n : integer
		);
		port (
			x, y 			: in  	std_logic_vector(0 to n-1);
			s				: out		std_logic_vector(0 to n-1);
			result_sign	: out		std_logic
		);
	end component;
	
	-- Swap module
	component SwapN
		generic (
			n : integer
		);
		port (
			swap	: in	std_logic;
			x, y	: in 	std_logic_vector(0 to n-1);
			a, b	: out	std_logic_vector(0 to n-1)
		);
	end component;
	
	-- Absolute value module
	component AbsoluteValue
		generic (
			n : integer
		);
		port (
			x	: 	in 	std_logic_vector(0 to n-1);
			y	: 	out	std_logic_vector(0 to n-1)
		);
	end component;

begin
	
	-- Special cases management
	special_cases: ParticularCaseAssignation
		port map (
         a 					=>	a,
			b 					=>	b,
			enable 			=>	special_case_flag_dff,
			result 			=>	special_case_result_dff,
			normalized_a	=>	normalized_a_flag,
			normalized_b	=>	normalized_b_flag
		);
		
	--	Extend mantissa a
	mantissa_extender_a:	MantissaExtender
		generic map (
			i	=> 23,
			g	=> 4
		)
		port map (
			input_mantissa		=>	mantissa_A,
			normalized			=>	normalized_a_flag,
			output_mantissa	=> mantissa_extended_a
		);
		
	operand_1_before_swap(36) 				<= sign_A;
	operand_1_before_swap(35 downto 28) <= exponent_A;
	operand_1_before_swap(27 downto 0) 	<= mantissa_extended_a;
		
	--	Extend mantissa b
	mantissa_extender_b:	MantissaExtender
		generic map (
			i	=> 23,
			g	=> 4
		)
		port map (
			input_mantissa		=>	mantissa_B,
			normalized			=>	normalized_b_flag,
			output_mantissa	=> mantissa_extended_b
		);
		
	operand_2_before_swap(36) 				<= sign_B;
	operand_2_before_swap(35 downto 28) <= exponent_B;
	operand_2_before_swap(27 downto 0) 	<= mantissa_extended_b;
	
	exponent_a_to_sub <=	exponent_A	when	normalized_a_flag = '1'	else
								"00000001";
								
	exponent_b_to_sub	<=	exponent_B	when	normalized_b_flag = '1'	else
								"00000001";
	
	-- Difference between exponents (Result value used in swap module)
	sub_exp: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x => exponent_A,
			y => exponent_B,
			s => exp_difference_dff,
			result_sign => exp_difference_sign
		);
		
	sub_exp_norm: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x => exponent_a_to_sub,
			y => exponent_b_to_sub,
			s => exp_difference_norm
		);
	
	-- Swap if needed
	swap_operands: SwapN
		generic map (
			n => 37
		)
		port map (
			swap => exp_difference_sign,
			x => operand_1_before_swap,
			y => operand_2_before_swap,
			a => operand_2_dff,
			b => operand_1_dff
		);
	
	-- Calculate |d|
	abs_d: AbsoluteValue
		generic map (
			n => 8
		)
		port map (
         x => exp_difference_norm,
			y => exp_difference_abs_dff
		);
	
	-- Connect the registers
	registers: RegisterN
		generic map (
			n => registers_number
		)
		port map (
         CLK => CLK,
			D => D,
			Q => Q
		);
	
	D <= 	special_case_flag_dff &
			special_case_result_dff &
			operand_1_dff &
			operand_2_dff &
			exp_difference_dff &
			exp_difference_abs_dff;
	
	special_case_flag <= Q(0);
	special_case_result <= Q(1 to 32);
	operand_1 <= Q(33 to 69);
	operand_2 <= Q(70 to 106);
	exp_difference <= Q(107 to 114);
	exp_difference_abs <= Q(115 to 122);
	
end Behavioral;