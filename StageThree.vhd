----------------------------------------------------------------------------------
-- Module Name:    	StageThree
-- Project Name: 		32 bit floating point adder
-- Description: 		Stage three of the pipeline
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity StageThree is
	port (
		CLK							:	in		std_logic;								-- Clock signal
		special_case_flag			:	in		std_logic;								-- Whether the operands leads to a special case
		special_case_result		:	in		std_logic_vector(31 downto 0);	-- Special case result
		value							:	in		std_logic_vector(31 downto 0);	-- Result of the sum between the two operands
		normalized_value			:	out	std_logic_vector(31 downto 0);	-- Normalized result
		
		-- Debug
		mantissa_shift				:	out	std_logic_vector(4 downto 0);
		exponent_increase			:	out	std_logic_vector(7 downto 0)
	);
end StageThree;

architecture Behavioral of StageThree is
	
	constant registers_number : integer := 45;
	
	alias sign is value(31);
	alias exponent is value(30 downto 23);
	alias mantissa is value(22 downto 0);
	
	-- Temporary signals
	-- "_dff" is used to indicate the signal before entering the registers
	signal normal_result_dff : std_logic_vector(31 downto 0);
	alias sign_normal_result_dff is normal_result_dff(31);
	alias exponent_normal_result_dff is normal_result_dff(30 downto 23);
	alias mantissa_normal_result_dff is normal_result_dff(22 downto 0);
	
	signal mantissa_shift_amount 		:	std_logic_vector(4 downto 0);
	signal exponent_increase_amount	:	std_logic_vector(7 downto 0);
	
	signal result_dff : std_logic_vector(31 downto 0);
	
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
	
	-- Zero counter
	component ZeroCounter
		port (
			mantissa		:	in		std_logic_vector(22 downto 0);
			count			:	out	std_logic_vector(4 downto 0)
		);
	end component;
	
	-- Extender
	component Extender
		generic (
			n 	: 	integer;
			s 	:	integer
		);					
		port (
			x	: in 	std_logic_vector(0 to n-1);
			y	: out	std_logic_vector(0 to s-1)
		);
	end component;
	
	-- Mantissa left shifter
	component MantissaLeftShifter
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
	
begin
	
	-- Copy result sign
	sign_normal_result_dff <= sign;
	
	-- Count the initial zeros of the mantissa
	zero_counter: ZeroCounter
		port map (
         mantissa	=>	mantissa,
			count		=>	mantissa_shift_amount
		);
	
	-- Extend the mantisa shift amount in order to have the exponent increase amount
	shift_amount_extender: Extender
		generic map (
			n => 5,
			s => 8
		)
		port map (
         x => mantissa_shift_amount,
			y => exponent_increase_amount
		);
	
	-- Mantissa left shift
	mantissa_left_shifter: MantissaLeftShifter
		port map (
			x 		=> mantissa,
			pos 	=> mantissa_shift_amount,
			y 		=> mantissa_normal_result_dff
		);
	
	-- Increment the exponent
	exponent_adjust: RippleCarryAdder
		generic map (
			n => 8
		)
		port map (
         x => exponent,
			y => exponent_increase_amount,
			s => exponent_normal_result_dff
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
	
	result_dff <= 	special_case_result when special_case_flag = '1' else
						normal_result_dff;
	
	D <=	result_dff &
			mantissa_shift_amount &
			exponent_increase_amount;
	
	normalized_value <= Q(0 to 31);
	mantissa_shift <= Q(32 to 36);
	exponent_increase <= Q(37 to 44);
	
end Behavioral;