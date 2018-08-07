--------------------------------------------------------------------------------
-- Module Name:   TestRegisters
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module Registers
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestRegisters is
end TestRegisters;
 
architecture behavior of TestRegisters is 
	component Registers
		generic (
			n	:	integer
		);
		port (
			CLK	:	in  	std_logic;
			D		:	in  	std_logic_vector(0 to n-1);
			Q		:	out	std_logic_vector(0 to n-1)
		);
	end component;
   
   -- Inputs
   signal CLK			: std_logic;
   signal D				: std_logic_vector(0 to 7);

 	-- Outputs
   signal Q 			: std_logic_vector(0 to 7);
	
	signal Q_expected	:	std_logic_vector(0 to 7);
	
	signal check		:	std_logic;

   -- Clock period
   constant CLK_period : time := 100 ns;

begin

	-- Clock definition
   CLK_process: process
   begin
		CLK <= '0';
		wait for CLK_period / 2;
		CLK <= '1';
		wait for CLK_period / 2;
   end process;
	
	-- DFF module
	uut: Registers
		generic map (
			n => 8
		)
		port map (
			CLK	=> CLK,
			D 		=> D,
			Q		=> Q
		);
		
	test: check <= '1' when Q = Q_expected else '0';

   stim_proc: process
   begin
	
		Q_expected <= "UUUUUUUU";
	
		wait for CLK_period / 4;
		
		D	<=	"00000000";
		
		wait for CLK_period / 4;
		
		Q_expected <= "00000000";
		
		wait for CLK_period / 2;
		
		D <= "10010110";
		
		wait for CLK_period / 2;
		
		Q_expected <= "10010110";
		
		wait for CLK_period / 2;
		
		D <= "11111111";
		
		wait for CLK_period / 2;
		
		Q_expected <= "11111111";
		
		wait;
		
	end process;
end;