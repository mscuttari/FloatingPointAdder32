----------------------------------------------------------------------------------
-- Module Name:    	StageOne
-- Project Name: 		32 bit floating point adder
-- Description: 		Stage one of the pipeline
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity StageOne is
	port (
		CLK							: 	in		std_logic;								-- Clock signal
		a, b							: 	in		std_logic_vector(31 downto 0);	-- Operands
		special_case_flag			:	out	std_logic;								-- Whether the operands leads to a special case
		special_case_result		:	out	std_logic_vector(31 downto 0);	-- Special case result
		operand_1					: 	out	std_logic_vector(31 downto 0);	-- Operand with the lowest exponent
		operand_2					: 	out	std_logic_vector(31 downto 0);	-- Operand with the highest exponent
		mantissa_shift_amount	: 	out	std_logic_vector(0 to 7)			-- Shift amount for the lowest exponent operand
	);
end StageOne;

architecture Behavioral of StageOne is
	
	constant registers_number : integer := 105;

	-- Temporary signals
	-- "_dff" is used to indicate the signal before entering the registers
	signal special_case_flag_dff			:	std_logic;								-- Whether the operands leads to a special case
	signal special_case_result_dff		:	std_logic_vector(31 downto 0);	-- Special case result
	signal exponent_A_real					:	std_logic_vector(7 downto 0);		--	Real exponent A
	signal exponent_B_real					:	std_logic_vector(7 downto 0);		--	Real exponent B
	signal operand_1_normal					:	std_logic_vector(31 downto 0);	-- Normally calculated operand with the lowest exponent
	signal operand_2_normal					:	std_logic_vector(31 downto 0);	-- Normally calculated operand with the highest exponent
	signal operand_1_dff						:	std_logic_vector(31 downto 0);	-- Operand with the lowest exponent
	signal operand_2_dff						:	std_logic_vector(31 downto 0);	-- Operand with the highest exponent
	signal exp_difference					:	std_logic_vector(8 downto 0);		--	Effective difference between operand A and B exponents (considering denormalized numbers too)
	signal real_exp_difference_sign		:	std_logic;								--	Sign of the difference between exponents
	signal mantissa_shift_amount_normal	:	std_logic_vector(0 to 7);			-- Normally calculated shift amount for the lowest exponent operand
	signal mantissa_shift_amount_dff		:	std_logic_vector(0 to 7);			-- Shift amount for the lowest exponent operand
	
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
	
	-- Special cases
	component SpecialCaseAssignation
		port (
			a					:	in 	std_logic_vector(31 downto 0);
			b					:	in 	std_logic_vector(31 downto 0);
			enable			:	out	std_logic;
			result			:	out	std_logic_vector(31 downto 0)
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
	
	-- Swap module
	component Swap
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
			y	: 	out	std_logic_vector(0 to n-2)
		);
	end component;

begin
	
	-- Special cases management
	special_cases: SpecialCaseAssignation
		port map (
         a 					=>	a,
			b 					=>	b,
			enable 			=>	special_case_flag_dff,
			result 			=>	special_case_result_dff
		);
	
	-- Difference between exponents (result value will be used in the swap module)
	sub_exp: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x 				=> exponent_A,
			y 				=> exponent_B,
			result_sign	=> real_exp_difference_sign
		);
	
	-- Swap if needed
	swap_operands: Swap
		generic map (
			n => 32
		)
		port map (
			swap	=> real_exp_difference_sign,
			x 		=> a,
			y 		=> b,
			a 		=> operand_2_normal,
			b 		=> operand_1_normal
		);
	
	operand_1_dff <= operand_1_normal when special_case_flag_dff = '0' else
						  "--------------------------------";
	
	operand_2_dff <= operand_2_normal when special_case_flag_dff = '0' else
						  "--------------------------------";
	
	--	Check the real exponents of the operands
	-- (this is used to calculate the real difference between the two exponents)
	exponent_A_real <= "00000001" when exponent_A = "00000000" else exponent_A;
	exponent_B_real <= "00000001" when exponent_B = "00000000" else exponent_B;
		
	sub_exp_norm: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x				=> exponent_A_real,
			y 				=> exponent_B_real,
			result		=> exp_difference(7 downto 0),
			result_sign	=> exp_difference(8)
		);
	
	-- Calculate |d|
	abs_d: AbsoluteValue
		generic map (
			n => 9
		)
		port map (
         x => exp_difference,
			y => mantissa_shift_amount_normal
		);
	
	mantissa_shift_amount_dff <= mantissa_shift_amount_normal when special_case_flag_dff = '0' else
										  "--------";
	
	-- Connect the registers
	reg: Registers
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
			mantissa_shift_amount_dff;
	
	special_case_flag <= Q(0);
	special_case_result <= Q(1 to 32);
	operand_1 <= Q(33 to 64);
	operand_2 <= Q(65 to 96);
	mantissa_shift_amount <= Q(97 to 104);
	
end Behavioral;