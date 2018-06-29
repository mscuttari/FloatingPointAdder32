----------------------------------------------------------------------------------
-- Module Name:    	Stage2
-- Project Name: 		32 bit floating point adder
-- Description: 		Stage two of the pipeline
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity StageTwo is
	port (
		CLK							:	in		std_logic;								-- Clock signal
		operand_1_in				:	in		std_logic_vector(31 downto 0);	-- Operand with the lowest exponent
		operand_2_in				:	in		std_logic_vector(31 downto 0);	-- Operand with the highest exponent
		exp_difference_in			:	in		std_logic_vector(0 to 7);			-- Difference between operand A and operand B exponents
		exp_difference_abs_in	:	in		std_logic_vector(0 to 7);			-- Difference between the highest and the lowest exponent
		sum							:	out	std_logic_vector(31 downto 0);	-- Sum between the two operands
		
		-- Debug
		operand_1_out				:	out	std_logic_vector(31 downto 0);	-- operand_1_in
		operand_1_shifted			:	out	std_logic_vector(31 downto 0);	-- operand_1_in with shifted mantissa
		operand_2_out				:	out	std_logic_vector(31 downto 0);	-- operand_2_in
		exp_difference_out		:	out	std_logic_vector(0 to 7);			-- exp_difference_in
		exp_difference_abs_out	:	out	std_logic_vector(0 to 7)			-- exp_difference_abs_in
	);
end StageTwo;

architecture Behavioral of StageTwo is
	
	constant registers_number : integer := 144;
	
	-- Operand with the lowest exponent
	alias sign_1_in is operand_1_in(31);
	alias exponent_1_in is operand_1_in(30 downto 23);
	alias mantissa_1_in is operand_1_in(22 downto 0);
	
	-- Temporary signals
	-- "_dff" is used to indicate the signal before entering the registers
	
	-- Operand with the lowest exponent
	signal operand_1_dff	:	std_logic_vector(31 downto 0);
	alias sign_1_dff is operand_1_dff(31);
	alias exponent_1_dff is operand_1_dff(30 downto 23);
	alias mantissa_1_dff is operand_1_dff(22 downto 0);
	
	-- Operand with the highest exponent
	signal operand_2_dff	:	std_logic_vector(31 downto 0);
	alias sign_2_dff is operand_2_dff(31);
	alias exponent_2_dff is operand_2_dff(30 downto 23);
	alias mantissa_2_dff is operand_2_dff(22 downto 0);
	
	-- Sum between the two operands
	signal sum_dff	:	std_logic_vector(31 downto 0);
	alias sign_sum_dff is sum_dff(31);
	alias exponent_sum_dff is sum_dff(30 downto 23);
	alias mantissa_sum_dff is sum_dff(22 downto 0);
	
	-- Difference between M1 and M2
	signal M1_M2_difference	:	std_logic_vector(0 to 22);
	
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
	
	-- Mantissa right shifter
	component MantissaRightShifter
		port (
			x		: in 	std_logic_vector(0 to 22);
			pos	: in	std_logic_vector(0 to 4);
			y		: out	std_logic_vector(0 to 22)
		);
	end component;
	
	-- Ripple carry adder
	component RippleCarryAdder
		generic (
			n : integer
		);
		port (
			x, y 		: in  	std_logic_vector(0 to n-1);
			s			: out		std_logic_vector(0 to n-1);
			overflow	: out		std_logic
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

begin

	-- Copy operand 2
	operand_2_dff <= operand_2_in;
	
	-- Copy sign and exponent of O1
	sign_1_dff 		<=	sign_1_in;
	exponent_1_dff <=	exponent_1_in;
	
	-- Mantissa right shifter
	mantissa_right_shifter: MantissaRightShifter
		port map (
			x 		=> mantissa_1_in,
			pos 	=> exp_difference_abs_in(3 to 7),
			y 		=> mantissa_1_dff
		);
	
	-- M1 - M2
	mantissa_sub: RippleCarrySubtractor
		generic map (
			n => 23
		)
		port map (
         x => mantissa_1_dff,
			y => mantissa_2_dff,
			s => M1_M2_difference
		);
	
	-- Sign
	sign_sum_dff <= sign_2_dff when M1_M2_difference(0) = '1' else
						 sign_1_dff;
	
	-- Exponent
	exponent_sum_dff <= exponent_2_dff;
	
	-- Mantissa (M1 + M2)
	mantissa_adder: RippleCarryAdder
		generic map (
			n => 23
		)
		port map (
         x => mantissa_1_dff,
			y => mantissa_2_dff,
			s => mantissa_sum_dff
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
	
	D <= 	sum_dff &
			operand_1_in &
			operand_1_dff &
			operand_2_dff &
			exp_difference_in &
			exp_difference_abs_in;
	
	sum <= Q(0 to 31);
	operand_1_out <= Q(32 to 63);
	operand_1_shifted <= Q(64 to 95);
	operand_2_out <= Q(96 to 127);
	exp_difference_out <= Q(128 to 135);
	exp_difference_abs_out <= Q(136 to 143);
	
end Behavioral;