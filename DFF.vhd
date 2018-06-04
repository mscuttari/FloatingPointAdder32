----------------------------------------------------------------------------------
-- Module Name:    	DFF
-- Project Name: 		32 bit floating point adder
-- Description: 		Flip flop D
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity DFF is
	port (
		CLK	: 	in std_logic;			-- Clock
		D		: 	in std_logic;			-- D
		Q		: 	out std_logic			-- Q
	);
end DFF;

architecture Behavioral of DFF is

begin

	dff: process (CLK)
	begin
		if (rising_edge(CLK)) then
			Q <= D;
		end if;
	end process;
	
end Behavioral;