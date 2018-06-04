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
			CLK : IN  std_logic;
			D : IN  std_logic;
			Q : OUT  std_logic
		);
	end component;
   
   -- Inputs
   signal CLK : std_logic := '0';
   signal D : std_logic := '0';

 	-- Outputs
   signal Q : std_logic;

   -- Clock period
   constant CLK_period : time := 10 ns;

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
			CLK => CLK,
			D => D,
			Q => Q
		);

   stim_proc: process
   begin
		-- Hold reset state for 100 ns
		wait for 100 ns;
		
		wait for CLK_period * 5;
		
		D <= '1';
		wait for CLK_period * 5;
		
		D <= '0';
		wait for CLK_period * 5;
		
		D <= '0';
		wait for CLK_period * 5;
		
		D <= '1';
		wait;
   end process;

end;