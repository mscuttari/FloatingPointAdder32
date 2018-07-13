--------------------------------------------------------------------------------
-- Module Name:   TestStageOne
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for the stage one
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestStageOne is
end TestStageOne;

architecture behavior of TestStageOne is 
	component StageOne
		port (
			CLK						: 	in		std_logic;
			a, b						: 	in		std_logic_vector(31 downto 0);
			special_case_flag		:	out	std_logic;
			special_case_result	:	out	std_logic_vector(31 downto 0);
			operand_1				: 	out	std_logic_vector(36 downto 0);
			operand_2				: 	out	std_logic_vector(36 downto 0);
			exp_difference			: 	out 	std_logic_vector(0 to 7);
			exp_difference_abs	: 	out	std_logic_vector(0 to 7)
		);
	end component;
	
	-- Data signals
	signal CLK 						:	std_logic;
   signal a, b 					:	std_logic_vector(31 downto 0);
	signal special_case_flag	:	std_logic;
	signal special_case_result	:	std_logic_vector(31 downto 0);
	signal operand_1				: 	std_logic_vector(36 downto 0);
	signal operand_2				: 	std_logic_vector(36 downto 0);
	signal exp_difference		: 	std_logic_vector(0 to 7);
	signal exp_difference_abs	: 	std_logic_vector(0 to 7);
	
   -- Clock period
   constant CLK_period : time := 55 ns;
	
begin
	-- Clock definition
   CLK_process: process
   begin
		CLK <= '0';
		wait for CLK_period / 2;
		CLK <= '1';
		wait for CLK_period / 2;
   end process;
	
	uut: StageOne
		port map (
			CLK						=>	CLK,
			a							=>	a,
			b							=>	b,
			special_case_flag		=>	special_case_flag,
			special_case_result	=> special_case_result,
			operand_1				=>	operand_1,
			operand_2				=>	operand_2,
			exp_difference			=> exp_difference,
			exp_difference_abs	=>	exp_difference_abs
		);
	
   stim_proc: process
   begin
		wait for CLK_period * 4;
		
		a <= "01000010010010010000000000000000";
		b <= "11000010111011010000000000000000";
		-- special_case_flag		0
		--	special_case_result	--------------------------------
		-- operand_1				0100001001100100100000000000000000000
		-- operand_2				1100001011110110100000000000000000000
		-- exp_difference			11111111
		--	exp_difference_abs	00000001
		
		wait for CLK_period * 4;
		
		a <= "01000001011000000000000000000000";
		b <= "00111111111111111111111111111111";
		-- special_case_flag		0
		--	special_case_result	--------------------------------
		-- operand_1				0011111111111111111111111111111110000
		-- operand_2				0100000101110000000000000000000000000
		-- exp_difference			00000011
		--	exp_difference_abs	00000011
		
		wait for CLK_period * 4;
		
		a <= "00000000010000000000000000000000";
		b <= "00000000010000000000000000000000";
		-- special_case_flag		0
		--	special_case_result	--------------------------------
		-- operand_1				0000000000100000000000000000000000000
		-- operand_2				0000000000100000000000000000000000000
		-- exp_difference			00000000
		--	exp_difference_abs	00000000
	
		wait for CLK_period * 4;
		
		a <= "00000000110000000000000000000000";
		b <= "00000000001000000000000000000000";
		-- special_case_flag		0
		--	special_case_result	--------------------------------
		-- operand_1				0000000000010000000000000000000000000
		-- operand_2				0000000011100000000000000000000000000
		-- exp_difference			00000001
		--	exp_difference_abs	00000000
		
		wait for CLK_period * 4;
		
		a <= "00000000110000000000000000000000";
		b <= "00000000011000000000000000000000";
		-- special_case_flag		0
		--	special_case_result	--------------------------------
		-- operand_1				0000000000110000000000000000000000000
		-- operand_2				0000000011100000000000000000000000000
		-- exp_difference			00000001
		--	exp_difference_abs	00000000
		
		wait for CLK_period * 4;
		
		a <= "00000000110000000000000000000000";
		b <= "10000000011000000000000000000000";
		-- special_case_flag		0
		--	special_case_result	--------------------------------
		-- operand_1				1000000000110000000000000000000000000
		-- operand_2				0000000011100000000000000000000000000
		-- exp_difference			00000001
		--	exp_difference_abs	00000000
		
		wait for CLK_period * 4;
		
		a <= "00000000110000000000000000000000";
		b <= "10000000011100000000000000000000";
		-- special_case_flag		0
		--	special_case_result	--------------------------------
		-- operand_1				1000000000111000000000000000000000000
		-- operand_2				0000000011100000000000000000000000000
		-- exp_difference			00000001
		--	exp_difference_abs	00000000
		
		wait for CLK_period * 4;
		
		a <= "00000000001100000000000000000000";
		b <= "00000000001100000000000000000000";
		-- special_case_flag		0
		--	special_case_result	--------------------------------
		-- operand_1				0000000000011000000000000000000000000
		-- operand_2				0000000000011000000000000000000000000
		-- exp_difference			00000000
		--	exp_difference_abs	00000000
		
		wait for CLK_period * 4;
		
		a <= "00000000011000000000000000000000";
		b <= "10000001000000000000000000000000";
		-- special_case_flag		0
		--	special_case_result	--------------------------------
		-- operand_1				0000000000110000000000000000000000000
		-- operand_2				1000000101000000000000000000000000000
		-- exp_difference			11111110
		--	exp_difference_abs	00000001
		
		wait;
		
   end process;

end;
