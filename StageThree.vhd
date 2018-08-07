----------------------------------------------------------------------------------
-- Module Name:    	StageThree
-- Project Name: 		32 bit floating point adder
-- Description: 		Stage three of the pipeline
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity StageThree is
	port (
		special_case_flag				:	in		std_logic;								-- Whether the operands leads to a special case
		special_case_result			:	in		std_logic_vector(31 downto 0);	-- Special case result
		value								:	in		std_logic_vector(36 downto 0);	-- Result of the sum between the two operands
		result							:	out	std_logic_vector(31 downto 0);	-- Normalized result
		
		-- Debug
		special_case_flag_out		:	out	std_logic								-- Whether there is a special case or not
	);
end StageThree;

architecture Behavioral of StageThree is
	
	alias sign is value(36);
	alias exponent is value(35 downto 28);
	alias mantissa is value(27 downto 0);
	
	-- Temporary signals
	signal normal_result 									:	std_logic_vector(31 downto 0);
	alias sign_normal_result 		is normal_result(31);
	alias exponent_normal_result 	is normal_result(30 downto 23);
	alias mantissa_normal_result 	is normal_result(22 downto 0);
	
	signal starting_zeros									:	std_logic_vector(4 downto 0);									-- Number of initial zeros of the mantissa
	signal extended_starting_zeros						:	std_logic_vector(7 downto 0);
	
	signal exponent_subtract_value						:	std_logic_vector(7 downto 0);									--	Exponent - initial zeros value
	signal exponent_subtract_sign							:	std_logic;															--	Exponent - initial zeros sign
	signal shift_amount_not_normalized_case			:	std_logic_vector(7 downto 0);									--	Mantissa shift amount if the result is not normalizable
	
	signal mantissa_shift_amount							:	std_logic_vector(7 downto 0);									--	Effective left shift amount
	signal exponent_after_left_shift						:	std_logic_vector(7 downto 0);									--	Exponent after left shift
	signal mantissa_after_left_shift						:	std_logic_vector(27 downto 0);								--	Mantissa after left shift
	
	signal round												:	std_logic;															--	Rounding of guard bits
	signal extended_round									:	std_logic_vector(23 downto 0);
	signal mantissa_after_round							:	std_logic_vector(23 downto 0);								--	Sum between mantissa and rounded guard bits
	signal round_overflow									:	std_logic;															--	Overflow of sum between mantissa and rounded guard bits
	
	signal mantissa_after_round_shift					:	std_logic_vector(23 downto 0);								--	1-position shifted mantissa (after round)
	signal exponent_after_round_shift					:	std_logic_vector(7 downto 0);									--	Exponent with positive overflow
	
	--	Special cases
	signal round_infinite_check							:	std_logic;
	
	-- Left Extender
	component LeftExtender
		generic (
			n, s	:	integer
		);
		port (
			x	: in 	std_logic_vector(0 to n-1);
			y	: out	std_logic_vector(0 to s-1)
		);
	end component;
	
	-- Right Extender
	component RightExtender
		generic (
			n, s	:	integer
		);
		port (
			x	: in 	std_logic_vector(0 to n-1);
			y	: out	std_logic_vector(0 to s-1)
		);
	end component;
	
	-- Zero counter
	component ZeroCounter
		port (
			mantissa		:	in		std_logic_vector(27 downto 0);
			count			:	out	std_logic_vector(4 downto 0)
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
	
	-- Mantissa left shifter
	component MantissaLeftShifter
		port (
			x		: in 	std_logic_vector(27 downto 0);
			pos	: in	std_logic_vector(7 downto 0);
			y		: out	std_logic_vector(27 downto 0)
		);
	end component;
	
	-- Rounder
	component Rounder
		port (
			x	:	in		std_logic_vector(3 downto 0);
			y	:	out	std_logic
		);
	end component;
	
	-- Ripple carry adder
	component RippleCarryAdder
		generic (
			n : integer
		);
		port (
			x, y			: in	std_logic_vector(n-1 downto 0);
			result		: out std_logic_vector(n-1 downto 0);
			overflow		: out	std_logic
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
	
begin
	
	-- Copy result sign
	sign_normal_result <= sign;
	
	-- Count the initial zeros of the mantissa
	zero_counter: ZeroCounter
		port map (
         mantissa	=>	mantissa,
			count		=>	starting_zeros
		);
	
	-- Extends starting zeros vector
	starting_zero_extender: LeftExtender
		generic map (
			n => 5,
			s => 8
		)
		port map (
			x => starting_zeros,
			y => extended_starting_zeros
		);
	
	-- Exponent - number of starting 0's
	exponent_zero_counter_difference: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x 				=> exponent,
			y 				=> extended_starting_zeros,
			result		=> exponent_subtract_value,
			result_sign	=>	exponent_subtract_sign
		);
	
	-- Exp - 1 (to use if the result is not normalizable)
	shift_left_not_normalized_case: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x 				=> exponent,
			y 				=> "00000001",
			result		=> shift_amount_not_normalized_case
		);
	
	--	Mantissa shift amount assignation
	mantissa_shift_amount <=	"00000000"													when	exponent = "00000000" else
										shift_amount_not_normalized_case(7 downto 0)		when	exponent_subtract_sign = '1' or exponent_subtract_value = "00000000" else
										extended_starting_zeros;
	
	--	Exponent assignation
	exponent_after_left_shift	<=	"00000001"									when	exponent_subtract_value = "00000000" and starting_zeros = "00000"	else
											"00000000"									when	exponent_subtract_sign = '1' or exponent_subtract_value = "00000000" else
											exponent_subtract_value;
	
	-- Mantissa left shift
	mantissa_left_shifter: MantissaLeftShifter
		port map (
          x 	=>	mantissa,
          pos 	=>	mantissa_shift_amount,
          y 	=>	mantissa_after_left_shift
        );
	
	--	Guard bits rounder
	mantissa_rounder:	Rounder
		port map (
			x => mantissa_after_left_shift(3 downto 0),
			y => round
		);
	

	extended_round <= "00000000000000000000000" & round;
	
	-- Mantissa approximation
	round_sum: RippleCarryAdder
		generic map (
			n => 24
		)
		port map (
         x			=> mantissa_after_left_shift(27 downto 4),
			y			=> extended_round,
			result	=> mantissa_after_round,
			overflow	=>	round_overflow
		);
		
	--	If the sum produced an overflow during the rounding process, then right shift the mantissa of 1 position
	right_shifter_round: RightShifter
		generic map (
			n	=>	24,
			s	=> 1
		)
		port map (
			x 		=> mantissa_after_round,
			y		=> mantissa_after_round_shift
		);
		
	-- If the sum produced an overflow during the rounding process, then increase the exponent by 1	
	exponent_increase_round: RippleCarryAdder
		generic map (
			n => 8
		)
		port map (
         x			=> exponent_after_left_shift,
			y			=> "00000001",
			result	=> exponent_after_round_shift
		);
		
	mantissa_normal_result <= mantissa_after_round_shift(22 downto 0)	when round_overflow = '1' else
									  mantissa_after_round(22 downto 0);
	
	exponent_normal_result <= exponent_after_round_shift when round_overflow = '1' else
									  exponent_after_left_shift;
		
	-- Check if the round produces and infinite value
	round_infinite_check	<=	'1' when round_overflow = '1' and exponent_after_left_shift = "11111110" else
									'0';
									
	special_case_flag_out	<=	'1' when (special_case_flag = '1') or (round_infinite_check = '1') else
										'0';
	
	result <= normal_result when special_case_flag = '0' else
				 special_case_result;
	
end Behavioral;