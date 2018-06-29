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
		operand_1				: 	out	std_logic_vector(31 downto 0);	-- Operand with the lowest exponent
		operand_2				: 	out	std_logic_vector(31 downto 0);	-- Operand with the highest exponent
		exp_difference			: 	out 	std_logic_vector(0 to 7);			-- Difference between operand A and operand B exponents
		exp_difference_abs	: 	out	std_logic_vector(0 to 7)			-- Difference between the highest and the lowest exponent
	);
end StageOne;

architecture Behavioral of StageOne is
	
	constant registers_number : integer := 113;

	-- Temporary signals
	-- "_dff" is used to indicate the signal before entering the registers
	signal special_case_flag_dff		:	std_logic;								-- Whether the operands leads to a special case
	signal special_case_result_dff	:	std_logic_vector(31 downto 0);	-- Special case result
	signal operand_1_dff					:	std_logic_vector(31 downto 0);	-- Operand with the lowest exponent
	signal operand_2_dff					:	std_logic_vector(31 downto 0);	-- Operand with the highest exponent
	signal exp_difference_dff			: 	std_logic_vector(0 to 7);			-- Difference between operand A and operand B exponents
	signal exp_difference_abs_dff		:	std_logic_vector(0 to 7);			-- Absolute value of exp_difference_dff
	
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
			a			:	in 	std_logic_vector(31 downto 0);
			b			:	in 	std_logic_vector(31 downto 0);
			enable	:	out	std_logic;
			result	:	out	std_logic_vector(31 downto 0)
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
			underflow	: out		std_logic
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
         a 			=>	a,
			b 			=>	b,
			enable 	=>	special_case_flag_dff,
			result 	=>	special_case_result_dff
		);
	
	-- Difference between exponents
	sub_exp: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x => exponent_A,
			y => exponent_B,
			s => exp_difference_dff
		);
	
	-- Swap if needed
	swap_operands: SwapN
		generic map (
			n => 32
		)
		port map (
			swap => exp_difference_dff(0),
			x => a,
			y => b,
			a => operand_2_dff,
			b => operand_1_dff
		);
	
	-- Calculate |d|
	abs_d: AbsoluteValue
		generic map (
			n => 8
		)
		port map (
         x => exp_difference_dff,
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
	operand_1 <= Q(33 to 64);
	operand_2 <= Q(65 to 96);
	exp_difference <= Q(97 to 104);
	exp_difference_abs <= Q(105 to 112);
	
end Behavioral;