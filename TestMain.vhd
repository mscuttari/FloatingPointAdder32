--------------------------------------------------------------------------------
-- Module Name:   TestMain
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module Main
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestMain is
end TestMain;

architecture behavior of TestMain is 
	component Main
		port (
			CLK								: 	in		std_logic;
			a, b								: 	in		std_logic_vector(31 downto 0);
			result							: 	out	std_logic_vector(31 downto 0);
			
			stg1_special_case_flag		:	out	std_logic;
			stg1_special_case_result	:	out	std_logic_vector(31 downto 0);
			stg1_operand_1					:	out	std_logic_vector(31 downto 0);
			stg1_operand_2					:	out	std_logic_vector(31 downto 0);
			stg1_d 							:	out 	std_logic_vector(0 to 7);
			stg1_d_abs 						: 	out	std_logic_vector(0 to 7);
			
			stg2_sum							:	out	std_logic_vector(31 downto 0);
			stg2_operand_1					:	out	std_logic_vector(31 downto 0);
			stg2_operand_1_shifted		:	out	std_logic_vector(31 downto 0);
			
			stg3_mantissa_shift			:	out	std_logic_vector(0 to 4);
			stg3_exponent_increase		:	out	std_logic_vector(0 to 7)
		);
	end component;
	
	-- Data signals
	signal CLK 		: std_logic := '0';
   signal a, b 	: std_logic_vector(31 downto 0) := (others => '0');
	signal result 	: std_logic_vector(31 downto 0);
	
	-- Debug
	signal stage1_special_case_flag		:	std_logic;
	signal stage1_special_case_result	:	std_logic_vector(31 downto 0);
	signal stage1_operand_1					:	std_logic_vector(31 downto 0);
	signal stage1_operand_2					:	std_logic_vector(31 downto 0);
	signal stage1_d 							: 	std_logic_vector(0 to 7);
	signal stage1_d_abs 						: 	std_logic_vector(0 to 7);
	
	signal stage2_sum							:	std_logic_vector(31 downto 0);
	signal stage2_operand_1					:	std_logic_vector(31 downto 0);
	signal stage2_operand_1_shifted		:	std_logic_vector(31 downto 0);
	
	signal stage3_mantissa_shift			:	std_logic_vector(4 downto 0);
	signal stage3_exponent_increase		:	std_logic_vector(7 downto 0);
	
   -- Clock period
   constant CLK_period : time := 80 ns;
	
begin
	-- Clock definition
   CLK_process: process
   begin
		CLK <= '0';
		wait for CLK_period / 2;
		CLK <= '1';
		wait for CLK_period / 2;
   end process;
	
	uut: Main
		port map (
			CLK 		=> CLK,
			a 			=> a,
         b 			=> b,
         result	=> result,
			
			stg1_special_case_flag		=>	stage1_special_case_flag,
			stg1_special_case_result	=>	stage1_special_case_result,
			stg1_operand_1					=>	stage1_operand_1,
			stg1_operand_2					=>	stage1_operand_2,
			stg1_d 							=>	stage1_d,
			stg1_d_abs 						=>	stage1_d_abs,
			
			stg2_sum							=>	stage2_sum,
			stg2_operand_1					=>	stage2_operand_1,
			stg2_operand_1_shifted		=>	stage2_operand_1_shifted,
			
			stg3_mantissa_shift			=>	stage3_mantissa_shift,
			stg3_exponent_increase		=>	stage3_exponent_increase
		);
	
   stim_proc: process
   begin
		wait for CLK_period * 5;
		
		a <= "11000001101110101000000000000000";
		b <= "11000011101110101000000000111111";
		wait for CLK_period * 5;
		
		a <= "01000011000000100100000000000000";
		b <= "01000011000001100001000000000000";
		-- 01000011000010000101000000000000
		wait;
		
   end process;

end;
