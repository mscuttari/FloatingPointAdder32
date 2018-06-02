--------------------------------------------------------------------------------
-- Module Name:   TestSwapN
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module SwapN
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestSwapN is
end TestSwapN;
 
architecture behavior of TestSwapN is 
	component SwapN
		generic ( n : integer);
		port (
			swap 	: in  	std_logic;
			x, y 	: in  	std_logic_vector(0 to n-1);
			a, b	: out 	std_logic_vector(0 to n-1)
			);
	end component;
    
   -- Inputs
   signal swap : std_logic := '0';
   signal x 	: std_logic_vector(0 to 4) := "00000";
   signal y 	: std_logic_vector(0 to 4) := "11111";

 	-- Outputs
   signal a, b : std_logic_vector(0 to 4);

begin
   uut: SwapN
		generic map(n => 5)
		port map (
			swap => swap,
         x => x,
         y => y,
         a => a,
         b => b
		);

   stim_proc: process
   begin
      wait for 100 ns;
		swap <= '1';
		wait for 100 ns;
		swap <= '0';
      wait;
   end process;

end;
