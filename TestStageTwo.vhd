--------------------------------------------------------------------------------
-- Module Name:   TestStageTwo
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for the stage two
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestStageTwo is
end TestStageTwo;

architecture behavior of TestStageTwo is 
	component StageTwo
		port (
			CLK							:	in		std_logic;
			special_case_flag_in		:	in		std_logic;
			special_case_result_in	:	in		std_logic_vector(31 downto 0);
			operand_1_in				:	in		std_logic_vector(36 downto 0);
			operand_2_in				:	in		std_logic_vector(36 downto 0);
			exp_difference_in			:	in		std_logic_vector(0 to 7);
			exp_difference_abs_in	:	in		std_logic_vector(0 to 7);
			special_case_flag_out	:	out	std_logic;
			special_case_result_out	:	out	std_logic_vector(31 downto 0);
			sum							:	out	std_logic_vector(36 downto 0);
			overflow						:	out	std_logic;
			operand_1_out				:	out	std_logic_vector(36 downto 0);
			operand_1_shifted			:	out	std_logic_vector(36 downto 0)
		);
	end component;
	
	-- Data signals
	signal CLK								:	std_logic;
	signal special_case_flag_in		:	std_logic;
	signal special_case_result_in		:	std_logic_vector(31 downto 0);
	signal operand_1_in					:	std_logic_vector(36 downto 0);
	signal operand_2_in					:	std_logic_vector(36 downto 0);
	signal exp_difference_in			:	std_logic_vector(0 to 7);
	signal exp_difference_abs_in		:	std_logic_vector(0 to 7);
	signal special_case_flag_out		:	std_logic;
	signal special_case_result_out	:	std_logic_vector(31 downto 0);
	signal overflow						:	std_logic;
	signal operand_1_out					:	std_logic_vector(36 downto 0);
	signal operand_1_shifted			:	std_logic_vector(36 downto 0);
	signal sum								:	std_logic_vector(36 downto 0);
	
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
	
	uut: StageTwo
		port map (
			CLK							=>	CLK,
			special_case_flag_in		=>	special_case_flag_in,
			special_case_result_in	=>	special_case_result_in,
			operand_1_in				=>	operand_1_in,
			operand_2_in				=>	operand_2_in,
			exp_difference_in			=>	exp_difference_in,
			exp_difference_abs_in	=>	exp_difference_abs_in,
			special_case_flag_out	=>	special_case_flag_out,
			special_case_result_out	=>	special_case_result_out,
			sum							=>	sum,
			overflow						=>	overflow,
			operand_1_out				=>	operand_1_out,
			operand_1_shifted			=>	operand_1_shifted
		);
	
   stim_proc: process
   begin
		wait for CLK_period * 2;
		
		special_case_flag_in		<=	'0';
		special_case_result_in	<=	"--------------------------------";
		operand_1_in				<=	"0100001001100100100000000000000000000";
		operand_2_in				<=	"1100001011110110100000000000000000000";
		exp_difference_in			<=	"11111111";
		exp_difference_abs_in	<=	"00000001";
		-- special_case_flag_out	0
		--	special_case_result_out	--------------------------------
		--	overflow						0
		--	operand_1_out				0100001001100100100000000000000000000
		--	operand_1_shifted			0100001000110010010000000000000000000
		--	sum							1100001011000100010000000000000000000
		
		wait for CLK_period * 2;
		
		special_case_flag_in		<=	'0';
		special_case_result_in	<=	"--------------------------------";
		operand_1_in				<=	"0011111111111111111111111111111110000";
		operand_2_in				<=	"0100000101110000000000000000000000000";
		exp_difference_in			<=	"00000011";
		exp_difference_abs_in	<=	"00000011";
		-- special_case_flag_out	0
		--	special_case_result_out	--------------------------------
		--	overflow						0
		--	operand_1_out				0011111111111111111111111111111110000
		--	operand_1_shifted			0011111110001111111111111111111111110
		--	sum							0100000101111111111111111111111111111
		
		wait for CLK_period * 2;
		
		special_case_flag_in		<=	'0';
		special_case_result_in	<=	"--------------------------------";
		operand_1_in				<=	"0000000000100000000000000000000000000";
		operand_2_in				<=	"0000000000100000000000000000000000000";
		exp_difference_in			<=	"00000000";
		exp_difference_abs_in	<=	"00000000";
		-- special_case_flag_out	0
		--	special_case_result_out	--------------------------------
		--	overflow						0
		--	operand_1_out				0000000000100000000000000000000000000
		--	operand_1_shifted			0000000000100000000000000000000000000
		--	sum							0000000001000000000000000000000000000
	
		wait for CLK_period * 2;
		
		special_case_flag_in		<=	'0';
		special_case_result_in	<=	"--------------------------------";
		operand_1_in				<=	"0000000000010000000000000000000000000";
		operand_2_in				<=	"0000000011100000000000000000000000000";
		exp_difference_in			<=	"00000001";
		exp_difference_abs_in	<=	"00000000";
		-- special_case_flag_out	0
		--	special_case_result_out	--------------------------------
		--	overflow						0
		--	operand_1_out				0000000000010000000000000000000000000
		--	operand_1_shifted			0000000000010000000000000000000000000
		--	sum							0000000011110000000000000000000000000
		
		wait for CLK_period * 2;
		
		special_case_flag_in		<=	'0';
		special_case_result_in	<=	"--------------------------------";
		operand_1_in				<=	"0000000000110000000000000000000000000";
		operand_2_in				<=	"0000000011100000000000000000000000000";
		exp_difference_in			<=	"00000001";
		exp_difference_abs_in	<=	"00000000";
		-- special_case_flag_out	0
		--	special_case_result_out	--------------------------------
		--	overflow						1
		--	operand_1_out				0000000000110000000000000000000000000
		--	operand_1_shifted			0000000000110000000000000000000000000
		--	sum							0000000010010000000000000000000000000
		
		wait for CLK_period * 2;
		
		special_case_flag_in		<=	'0';
		special_case_result_in	<=	"--------------------------------";
		operand_1_in				<=	"1000000000110000000000000000000000000";
		operand_2_in				<=	"0000000011100000000000000000000000000";
		exp_difference_in			<=	"00000001";
		exp_difference_abs_in	<=	"00000000";
		-- special_case_flag_out	0
		--	special_case_result_out	--------------------------------
		--	overflow						0
		--	operand_1_out				1000000000110000000000000000000000000
		--	operand_1_shifted			1000000000110000000000000000000000000
		--	sum							0000000010110000000000000000000000000
		
		wait for CLK_period * 2;
		
		special_case_flag_in		<=	'0';
		special_case_result_in	<=	"--------------------------------";
		operand_1_in				<=	"1000000000111000000000000000000000000";
		operand_2_in				<=	"0000000011100000000000000000000000000";
		exp_difference_in			<=	"00000001";
		exp_difference_abs_in	<=	"00000000";
		-- special_case_flag_out	0
		--	special_case_result_out	--------------------------------
		--	overflow						0
		--	operand_1_out				1000000000111000000000000000000000000
		--	operand_1_shifted			1000000000111000000000000000000000000
		--	sum							0000000010101000000000000000000000000
		
		wait for CLK_period * 2;
		
		special_case_flag_in		<=	'0';
		special_case_result_in	<=	"--------------------------------";
		operand_1_in				<=	"0000000000011000000000000000000000000";
		operand_2_in				<=	"0000000000011000000000000000000000000";
		exp_difference_in			<=	"00000000";
		exp_difference_abs_in	<=	"00000000";
		-- special_case_flag_out	0
		--	special_case_result_out	--------------------------------
		--	overflow						0
		--	operand_1_out				0000000000011000000000000000000000000
		--	operand_1_shifted			0000000000011000000000000000000000000
		--	sum							0000000000110000000000000000000000000
		
		wait for CLK_period * 2;
		special_case_flag_in		<=	'0';
		special_case_result_in	<=	"--------------------------------";
		operand_1_in				<=	"0000000000110000000000000000000000000";
		operand_2_in				<=	"1000000101000000000000000000000000000";
		exp_difference_in			<=	"11111110";
		exp_difference_abs_in	<=	"00000001";
		-- special_case_flag_out	0
		--	special_case_result_out	--------------------------------
		--	overflow						0
		--	operand_1_out				0000000000110000000000000000000000000
		--	operand_1_shifted			0000000000011000000000000000000000000
		--	sum							1000000100101000000000000000000000000
		
		wait;
		
   end process;

end;
