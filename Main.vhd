----------------------------------------------------------------------------------
-- Module Name:    	Main
-- Project Name: 		32 bit floating point adder
-- Description: 		Main module
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Main is
	generic (
		exponent_size	:	integer	:=	8;				-- Exponent size
		mantissa_size	:	integer	:=	23				-- Mantissa size
	);
	port (
		a, b			: in	std_logic_vector(31 downto 0);		-- Input
		result		: out	std_logic_vector(31 downto 0)			-- Output
	);
end Main;

architecture Behavioral of Main is

	-- Operand A
	signal Sa	:	std_logic;													-- A sign
	signal Ea	:	std_logic_vector(0 to exponent_size - 1);			-- A exponent
	signal Ma	:	std_logic_vector(0 to mantissa_size - 1);			-- A mantissa
	
	-- Operand B
	signal Sb	:	std_logic;													-- B sign
	signal Eb	:	std_logic_vector(0 to exponent_size - 1);			-- B exponent
	signal Mb	:	std_logic_vector(0 to mantissa_size - 1);			-- B mantissa
	
	-- Result
	signal S		: std_logic;													-- Result sign
	signal E		: std_logic_vector(0 to exponent_size - 1);			-- Result exponent
	signal M		: std_logic_vector(0 to mantissa_size - 1);			-- Result mantissa
	
	-- Temporary signals
	signal d			: 	std_logic_vector(0 to exponent_size - 1);		-- Difference between Ea and Eb
	signal d_abs	:	std_logic_vector(0 to exponent_size - 1);		-- Absolute value of d
	signal Memin	:	std_logic_vector(0 to mantissa_size - 1);		-- Mantissa corresponding to the lowest exponent
	signal M1		:	std_logic_vector(0 to mantissa_size - 1);		-- Memin aligned with Memax (= M2)
	signal M2		:	std_logic_vector(0 to mantissa_size - 1);		-- Mantissa corresponding to the higher exponent
	signal M12S		:	std_logic_vector(0 to mantissa_size - 1);		-- Sum between M1 and M2
	signal M12D		:	std_logic_vector(0 to mantissa_size - 1);		-- Difference between M1 and M2
	signal S1		: 	std_logic;												-- Sign corresponding to the higher exponent
	signal S2		:	std_logic;												-- Sign corresponding to the lower exponent
	
	
	-- AbsoluteValue
	component AbsoluteValue
		generic ( n : integer );
		port (
			x			: 	in 	std_logic_vector(0 to n-1);
			y			: 	out	std_logic_vector(0 to n-1)
		);
	end component;
	
	-- Ripple carry adder
	component RippleCarryAdder
		generic ( n : integer );
		port (
			x, y 		: in  	std_logic_vector(0 to n-1);
			s			: out		std_logic_vector(0 to n-1);
			overflow	: out		std_logic
		);
	end component;
	
	-- Ripple carry subtractor
	component RippleCarrySubtractor
		generic ( n : integer );
		port (
			x, y 			: in  	std_logic_vector(0 to n-1);
			s				: out		std_logic_vector(0 to n-1);
			underflow	: out		std_logic
		);
	end component;
	
	-- Swap module
	component SwapN
		generic ( n : integer );
		port (
			swap	: in	std_logic;
			x, y	: in 	std_logic_vector(0 to n-1);
			a, b	: out	std_logic_vector(0 to n-1)
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

begin
	
	-- Operand A: extract data
	Sa <= a(31);
	Ea <= a(30 downto 23);
	Ma <= a(22 downto 0);
	
	-- Operand B: extract data
	Sb <= b(31);
	Eb <= b(30 downto 23);
	Mb <= b(22 downto 0);
	
	-- Difference between exponents
	sub_exp: RippleCarrySubtractor
		generic map ( n => exponent_size )
		port map (
         x => Ea,
			y => Eb,
			s => d
		);
	
	-- Swap mantissas if needed
	swap_exp: SwapN
		generic map ( n => mantissa_size )
		port map (
			swap => d(0),
			x => Ma,
			y => Mb,
			a => M2,
			b => Memin
		);
	
	-- Calculate |d|
	abs_d: AbsoluteValue
		generic map ( n => exponent_size )
		port map (
         x => d,
			y => d_abs
		);
	
	-- Mantissa right shifter
	mantissa_right_shifter: MantissaRightShifter
		port map (
			x => Memin,
			pos => d_abs(exponent_size - 5 to exponent_size - 1),
			y => M1
		);
	
	-- Sum of M1 and M2
	adder_m12: RippleCarryAdder
		generic map ( n => mantissa_size )
		port map (
         x => M1,
			y => M2,
			s => M12S
		);
	
	-- Difference between M1 and M2
	sub_mantissa: RippleCarrySubtractor
		generic map ( n => mantissa_size )
		port map (
         x => M1,
			y => M2,
			s => M12D
		);
	
	-- Swap signs if needed
	S1 <= Sb when d(0) = '1' else
			Sa;
	
	S2 <= Sa when d(0) = '1' else
			Sb;
	
	-- Result sign
	S <=  S2 when M12D(0) = '1' else
			S1;
	
	-- Compose result
	result <= S & E & M;

end Behavioral;