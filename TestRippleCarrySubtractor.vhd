--------------------------------------------------------------------------------
-- Module Name:   TestRippleCarrySubtractor
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module RippleCarrySubtractor
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity TestRippleCarrySubtractor is
end TestRippleCarrySubtractor;
 
architecture behavior of TestRippleCarrySubtractor is
	component RippleCarrySubtractor
		generic (
			n : integer
		);
		port (
         x, y			:	in		std_logic_vector(n-1 downto 0);
         s 				:	out	std_logic_vector(n-1 downto 0);
         underflow 	:	out  	std_logic
        );
    end component;

   --Inputs
   signal x, y : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal s 			: std_logic_vector(7 downto 0);
   signal underflow 	: std_logic;
 
begin
   uut: RippleCarrySubtractor
		generic map (
			n => 8
		)
		port map (
         x => x,
         y => y,
         s => s,
         underflow => underflow
      );
		
   stim_proc: process
   begin
      wait for 100 ns;
		x <= "11111111";
		y <= "00000000";
		wait for 100 ns;
		x <= "11111111";
		y <= "11111110";
		wait for 100 ns;
		x <= "11111111";
		y <= "11111111";
		wait for 100 ns;
		x <= "11111110";
		y <= "11111111";
		wait for 100 ns;
		x <= "00000000";
		y <= "11111111";
		wait;
   end process;

END;
