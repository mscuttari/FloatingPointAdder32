--------------------------------------------------------------------------------
-- Module Name:   TestDFF
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module DFF
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestDFF is
end TestDFF;
 
architecture behavior of TestDFF is 
	component DFF
		port (
			CLK	:	in  	std_logic;
			D		:	in  	std_logic;
			Q		:	out	std_logic
		);
	end component;
   
   -- Inputs
   signal CLK	: std_logic;
   signal D		: std_logic;

 	-- Outputs
   signal Q 	: std_logic;
	
	signal Q_expected	:	std_logic;
	
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
	uut: DFF
		port map (
			CLK	=> CLK,
			D 		=> D,
			Q		=> Q
		);
		
	test: check <= '1' when Q = Q_expected else '0';

   stim_proc: process
   begin
	
		Q_expected <= 'U';
	
		wait for CLK_period / 4;
		
		D	<=	'0';
		
		wait for CLK_period / 4;
		
		Q_expected <= '0';
		
		wait for CLK_period / 2;
		
		D <= '1';
		
		wait for CLK_period / 2;
		
		Q_expected <= '1';
		
		wait for CLK_period / 2;
		
		D <= '0';
		
		wait for CLK_period / 2;
		
		Q_expected <= '0';
		
		wait for CLK_period / 2;
		
		D <= '1';
		
		wait for CLK_period / 2;
		
		Q_expected <= '1';
		
		wait;
		
	end process;
end;