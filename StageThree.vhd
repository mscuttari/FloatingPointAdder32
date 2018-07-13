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
		value							:	in		std_logic_vector(36 downto 0);	-- Result of the sum between the two operands
		overflow						:	in		std_logic;								--	Overflow value
		normalized_value			:	out	std_logic_vector(31 downto 0);	-- Normalized result
		
		-- Debug
		mantissa_shift				:	out	std_logic_vector(4 downto 0);
		exponent_increase			:	out	std_logic_vector(7 downto 0)
	);
end StageThree;

architecture Behavioral of StageThree is
	
	constant registers_number : integer := 45;
	
	alias sign is value(36);
	alias exponent is value(35 downto 28);
	alias mantissa is value(27 downto 0);
	
	-- Temporary signals
	-- "_dff" is used to indicate the signal before entering the registers
	signal normal_result_dff : std_logic_vector(31 downto 0);
	alias sign_normal_result_dff is normal_result_dff(31);
	alias exponent_normal_result_dff is normal_result_dff(30 downto 23);
	alias mantissa_normal_result_dff is normal_result_dff(22 downto 0);
	
	signal mantissa_after_sum_shift						:	std_logic_vector(27 downto 0);
	signal mantissa_after_sum_shift_overflowed		:	std_logic_vector(27 downto 0);
	signal exponent_after_sum_shift						:	std_logic_vector(7 downto 0);
	signal mantissa_after_sum_overflow					:	std_logic_vector(27 downto 0);
	signal exponent_after_sum_overflow					:	std_logic_vector(7 downto 0);
	signal mantissa_shift_amount 							:	std_logic_vector(4 downto 0);
	signal exponent_increase_amount						:	std_logic_vector(7 downto 0);
	signal starting_zeros									:	std_logic_vector(4 downto 0);
	signal extended_starting_zeros						:	std_logic_vector(7 downto 0);
	signal exponent_subtract_value						:	std_logic_vector(7 downto 0);
	signal exponent_subtract_sign							:	std_logic;
	signal shift_amount_not_normalized_case			:	std_logic_vector(7 downto 0);
	signal exponent_after_left_shift						:	std_logic_vector(7 downto 0);
	signal mantissa_after_left_shift						:	std_logic_vector(27 downto 0);
	signal round												:	std_logic;
	signal round_vector										:	std_logic_vector(27 downto 0)	:=	(others => '0');
	signal round_overflow									:	std_logic;
	signal mantissa_after_round							:	std_logic_vector(27 downto 0);
	signal mantissa_after_round_shift					:	std_logic_vector(27 downto 0);
	signal mantissa_after_round_shift_overflowed		:	std_logic_vector(27 downto 0);
	signal exponent_after_round_shift					:	std_logic_vector(7 downto 0);
	
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
			mantissa		:	in		std_logic_vector(27 downto 0);
			count			:	out	std_logic_vector(4 downto 0)
		);
	end component;
	
	-- Mantissa right shifter
	component MantissaRightShifter
		port (
			x				:	in 	std_logic_vector(27 downto 0);
			pos			:	in		std_logic_vector(4 downto 0);
			y				:	out	std_logic_vector(27 downto 0)
		);
	end component;
	
	-- Mantissa left shifter
	component MantissaLeftShifter
		port (
			x		: in 	std_logic_vector(27 downto 0);
			pos	: in	std_logic_vector(4 downto 0);
			y		: out	std_logic_vector(27 downto 0)
		);
	end component;
	
	-- Rounder
	component Rounder
		generic (
			g	:	integer
		);
		port (
			i	:	in		std_logic_vector(g-1 downto 0);
			o	:	out	std_logic
		);
	end component;
	
	-- Ripple carry adder
	component RippleCarryAdder
		generic (
			n : integer
		);
		port (
			x, y			: in	std_logic_vector(n-1 downto 0);
			s				: out std_logic_vector(n-1 downto 0);
			overflow		: out	std_logic
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
	
begin
	
	-- Copy result sign
	sign_normal_result_dff <= sign;
	
	--	If the sum produced an overflow in StageTwo, insert a '1' as the most significant bit
	mantissa_right_shifter_sum: MantissaRightShifter
		port map (
			x 		=> mantissa,
			pos 	=> "00001",
			y 		=> mantissa_after_sum_shift
		);
	
	mantissa_after_sum_shift_overflowed <= '1' & mantissa_after_sum_shift(26 downto 0);
		
	-- If the sum produced an overflow in StageTwo, increase the exponent by 1	
	exponent_increase_sum: RippleCarryAdder
		generic map (
			n => 8
		)
		port map (
         x => exponent,
			y => "00000001",
			s => exponent_after_sum_shift
		);
	
	mantissa_after_sum_overflow	<=	mantissa_after_sum_shift_overflowed	when	overflow = '1' else
												mantissa;
	exponent_after_sum_overflow	<=	exponent_after_sum_shift	when	overflow = '1' else
												exponent;
	
	-- Count the initial zeros of the mantissa
	zero_counter: ZeroCounter
		port map (
         mantissa	=>	mantissa_after_sum_overflow,
			count		=>	starting_zeros
		);
		
	extended_starting_zeros <= "000" & starting_zeros;
	
	-- Exponent - number of starting 0's
	exponent_zero_counter_difference: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x 				=> exponent_after_sum_overflow,
			y 				=> extended_starting_zeros,
			s 				=> exponent_subtract_value,
			result_sign	=>	exponent_subtract_sign
		);
		
	shift_left_not_normalized_case: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x 				=> exponent_after_sum_overflow,
			y 				=> "00000001",
			s 				=> shift_amount_not_normalized_case
		);
	
	mantissa_shift_amount <=	-- "00000"														when	exponent_subtract_value = "00000000" and starting_zeros = "00000"	else
										"00000"														when	exponent_after_sum_overflow = "00000000" else --(exponent_subtract_sign = '1' or exponent_subtract_value = "00000000") and
										shift_amount_not_normalized_case(4 downto 0)		when	exponent_subtract_sign = '1' or exponent_subtract_value = "00000000" else
										starting_zeros;
	
	
	
	
	--starting_zeros	when	exponent_subtract_sign = '0' and not exponent_subtract_value = "00000000" else
	--									exponent_after_sum_overflow(4 downto 0);
										
	exponent_after_left_shift	<=	"00000001"									when	exponent_subtract_value = "00000000" and starting_zeros = "00000"	else
											"00000000"									when	exponent_subtract_sign = '1' or exponent_subtract_value = "00000000" else
											exponent_subtract_value(7 downto 0);
											
	exponent_increase_amount <= exponent_after_left_shift;
	
	
	
	--										"00000001"	when	exponent_subtract_value(7 downto 0) = "00000000" else
	--										exponent_subtract_value	when	exponent_subtract_sign = '0'	else
	--										"00000000";
	
	mantissa_left_shifter: MantissaLeftShifter
		port map (
          x 	=>	mantissa_after_sum_overflow,
          pos 	=>	mantissa_shift_amount,
          y 	=>	mantissa_after_left_shift
        );
		  
	mantissa_rounder:	Rounder
		generic map (
			g => 4
		)
		port map (
			i => mantissa_after_left_shift(3 downto 0),
			o => round
		);
		
	round_vector(4) <= round;
	
	round_sum: RippleCarryAdder
		generic map (
			n => 28
		)
		port map (
         x			=> mantissa_after_left_shift,
			y			=> round_vector,
			s			=> mantissa_after_round,
			overflow	=>	round_overflow
		);
	
	--	If the sum produced an overflow in Rounder, insert a '1' as the most significant bit
	mantissa_right_shifter_round: MantissaRightShifter
		port map (
			x 		=> mantissa_after_round,
			pos 	=> "00001",
			y 		=> mantissa_after_round_shift
		);
		
	mantissa_after_round_shift_overflowed <= '1' & mantissa_after_round_shift(26 downto 0);
		
	-- If the sum produced an overflow in Rounder, increase the exponent by 1	
	exponent_increase_round: RippleCarryAdder
		generic map (
			n => 8
		)
		port map (
         x => exponent_after_left_shift,
			y => "00000001",
			s => exponent_after_round_shift
		);
	
	mantissa_normal_result_dff <= mantissa_after_round_shift_overflowed(26 downto 4)	when	round_overflow = '1' else
											mantissa_after_left_shift(26 downto 4);
	exponent_normal_result_dff <= exponent_after_round_shift	when	round_overflow = '1' else
											exponent_after_left_shift;
	
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