--------------------------------------------------------------------------------
-- Module Name:   TestStageOne
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module StageOne
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestStageOne is
end TestStageOne;

architecture behavior of TestStageOne is 
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
	
	-- Data signals
	signal a											:	std_logic_vector(31 downto 0);
	signal b											:	std_logic_vector(31 downto 0);
	signal special_case_flag					:	std_logic;
	signal special_case_result					:	std_logic_vector(31 downto 0);
	signal operand_1								:	std_logic_vector(31 downto 0);
	signal operand_2								:	std_logic_vector(31 downto 0);
	signal mantissa_shift_amount				:	std_logic_vector(0 to 7);
	
	signal special_case_flag_expected		:	std_logic;
	signal special_case_result_expected		:	std_logic_vector(31 downto 0);
	signal operand_1_expected					:	std_logic_vector(31 downto 0);
	signal operand_2_expected					:	std_logic_vector(31 downto 0);
	signal mantissa_shift_amount_expected	:	std_logic_vector(0 to 7);
	
	signal check	:	std_logic;
	
begin
	
	uut: StageOne
		port map (
			a								=>	a,
			b								=>	b,
			special_case_flag			=>	special_case_flag,
			special_case_result		=> special_case_result,
			operand_1					=>	operand_1,
			operand_2					=>	operand_2,
			mantissa_shift_amount	=>	mantissa_shift_amount
		);
		
	test:	check <= '1' when	special_case_flag = special_case_flag_expected and
									special_case_result = special_case_result_expected and
									operand_1 = operand_1_expected and
									operand_2 = operand_2_expected and
									mantissa_shift_amount = mantissa_shift_amount_expected
						else '0';
	
   stim_proc: process
   begin
		
		-- Generic values (first exponent is the smallest)
		a											<= "01000010010010010000000000000000";
		b											<= "11000010111011010000000000000000";
		special_case_flag_expected			<=	'0';
		special_case_result_expected		<=	"--------------------------------";
		operand_1_expected					<=	"01000010010010010000000000000000";
		operand_2_expected					<=	"11000010111011010000000000000000";
		mantissa_shift_amount_expected	<=	"00000001";
		
		wait for 142 ns;

		-- Generic values (first exponent is the biggest)
		a											<= "11000010111011010000000000000000";
		b											<= "01000010010010010000000000000000";
		special_case_flag_expected			<=	'0';
		special_case_result_expected		<=	"--------------------------------";
		operand_1_expected					<=	"01000010010010010000000000000000";
		operand_2_expected					<=	"11000010111011010000000000000000";
		mantissa_shift_amount_expected	<=	"00000001";

		wait for 142 ns;
		
		-- Generic values (equal exponents)
		a											<= "11000010111011010000000000000000";
		b											<= "01000010110010010000000000000000";
		special_case_flag_expected			<=	'0';
		special_case_result_expected		<=	"--------------------------------";
		operand_1_expected					<=	"01000010110010010000000000000000";
		operand_2_expected					<=	"11000010111011010000000000000000";
		mantissa_shift_amount_expected	<=	"00000000";
		
		wait for 142 ns;
		
		-- Generic values (first operand is not normalized)
		a											<= "10000000011011010000000000000000";
		b											<= "00000000110010010000000000000000";
		special_case_flag_expected			<=	'0';
		special_case_result_expected		<=	"--------------------------------";
		operand_1_expected					<=	"10000000011011010000000000000000";
		operand_2_expected					<=	"00000000110010010000000000000000";
		mantissa_shift_amount_expected	<=	"00000000";
		
		wait for 142 ns;
		
		-- Generic values (second operand is not normalized)
		a											<= "00000000110010010000000000000000";
		b											<= "10000000011011010000000000000000";
		special_case_flag_expected			<=	'0';
		special_case_result_expected		<=	"--------------------------------";
		operand_1_expected					<=	"10000000011011010000000000000000";
		operand_2_expected					<=	"00000000110010010000000000000000";
		mantissa_shift_amount_expected	<=	"00000000";
		
		wait for 142 ns;
		
		-- Generic values (both operands are not normalized)
		a											<= "10000000011011010000000000000000";
		b											<= "00000000010010010000000000000000";
		special_case_flag_expected			<=	'0';
		special_case_result_expected		<=	"--------------------------------";
		operand_1_expected					<=	"00000000010010010000000000000000";
		operand_2_expected					<=	"10000000011011010000000000000000";
		mantissa_shift_amount_expected	<=	"00000000";
		
		wait for 142 ns;
		
		-- Special case
		a											<= "11111111100000000000000000000000";
		b											<=	"11101011001101001001001110100101";
		special_case_flag_expected			<=	'1';
		special_case_result_expected		<=	"11111111100000000000000000000000";
		operand_1_expected					<=	"--------------------------------";
		operand_2_expected					<=	"--------------------------------";
		mantissa_shift_amount_expected	<=	"--------";
		
		wait;
		
   end process;
end;