--------------------------------------------------------------------------------
-- Module Name:   TestStageThree
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for the stage three
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestStageThree is
end TestStageThree;

architecture behavior of TestStageThree is 
	component StageThree
		port (
			CLK							:	in		std_logic;
			special_case_flag			:	in		std_logic;
			special_case_result		:	in		std_logic_vector(31 downto 0);
			value							:	in		std_logic_vector(36 downto 0);
			overflow						:	in		std_logic;
			normalized_value			:	out	std_logic_vector(31 downto 0);
			
			-- Debug
			mantissa_shift				:	out	std_logic_vector(4 downto 0);
			exponent_increase			:	out	std_logic_vector(7 downto 0)
		);
	end component;
	
	-- Data signals
	signal CLK							:	std_logic;
	signal special_case_flag		:	std_logic;
	signal special_case_result		:	std_logic_vector(31 downto 0);
	signal value						:	std_logic_vector(36 downto 0);
	signal overflow					:	std_logic;
	signal normalized_value			:	std_logic_vector(31 downto 0);
	signal mantissa_shift			:	std_logic_vector(4 downto 0);
	signal exponent_increase		:	std_logic_vector(7 downto 0);
	
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
	
	uut: StageThree
		port map (
			CLK						=>	CLK,
			special_case_flag		=>	special_case_flag,
			special_case_result	=>	special_case_result,
			value						=>	value,
			overflow					=>	overflow,
			normalized_value		=>	normalized_value,
			mantissa_shift			=>	mantissa_shift,
			exponent_increase		=>	exponent_increase
		);
	
   stim_proc: process
   begin
		wait for CLK_period * 2;
		
		special_case_flag		<=	'0';
		special_case_result	<=	"--------------------------------";
		value						<=	"1100001011000100010000000000000000000";
		overflow					<=	'0';
		-- normalized_value		11000010100010001000000000000000
		-- mantissa_shift			00000
		-- exponent_increase		10000101
		
		wait for CLK_period * 2;
		
		special_case_flag		<=	'0';
		special_case_result	<=	"--------------------------------";
		value						<=	"0100000101111111111111111111111111111";
		overflow					<=	'0';
		-- normalized_value		01000001100000000000000000000000
		-- mantissa_shift			00000
		-- exponent_increase		10000010
		
		wait for CLK_period * 2;
		
		special_case_flag		<=	'0';
		special_case_result	<=	"--------------------------------";
		value						<=	"0000000001000000000000000000000000000";
		overflow					<=	'0';
		-- normalized_value		00000000100000000000000000000000
		-- mantissa_shift			00000
		-- exponent_increase		00000001
		
		wait for CLK_period * 2;
		
		
		special_case_flag		<=	'0';
		special_case_result	<=	"--------------------------------";
		value						<=	"0000000011110000000000000000000000000";
		overflow					<=	'0';
		-- normalized_value		00000000111000000000000000000000
		-- mantissa_shift			00000
		-- exponent_increase		00000001
		
		wait for CLK_period * 2;
		
		
		special_case_flag		<=	'0';
		special_case_result	<=	"--------------------------------";
		value						<=	"0000000010010000000000000000000000000";
		overflow					<=	'1';
		-- normalized_value		00000001000100000000000000000000
		-- mantissa_shift			00000
		-- exponent_increase		00000010
		
		wait for CLK_period * 2;
		
		
		special_case_flag		<=	'0';
		special_case_result	<=	"--------------------------------";
		value						<=	"0000000010110000000000000000000000000";
		overflow					<=	'0';
		-- normalized_value		00000000011000000000000000000000
		-- mantissa_shift			00000
		-- exponent_increase		00000000
		
		wait for CLK_period * 2;
		
		
		special_case_flag		<=	'0';
		special_case_result	<=	"--------------------------------";
		value						<=	"0000000010101000000000000000000000000";
		overflow					<=	'0';
		-- normalized_value		00000000010100000000000000000000
		-- mantissa_shift			00000
		-- exponent_increase		00000000
		
		wait for CLK_period * 2;
		
		
		special_case_flag		<=	'0';
		special_case_result	<=	"--------------------------------";
		value						<=	"0000000000110000000000000000000000000";
		overflow					<=	'0';
		-- normalized_value		00000000011000000000000000000000
		-- mantissa_shift			00000
		-- exponent_increase		00000000
		
		wait for CLK_period * 2;
		
		
		special_case_flag		<=	'0';
		special_case_result	<=	"--------------------------------";
		value						<=	"1000000100101000000000000000000000000";
		overflow					<=	'0';
		-- normalized_value		10000000101000000000000000000000
		-- mantissa_shift			00001
		-- exponent_increase		00000001
		
		wait;
		
   end process;

end;
