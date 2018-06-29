--------------------------------------------------------------------------------
-- Module Name:   TestLeftShifter
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module LeftShifter
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
 
entity TestLeftShifter is
end TestLeftShifter;
 
architecture behavior of TestLeftShifter is 
 
    component LeftShifter
		generic (
			n : integer;
			s : integer
		);
		port(
         x	:	in		std_logic_vector(0 to n-1);
         y	:	out	std_logic_vector(0 to n-1)
       );
    end component;
    

   --Inputs
   signal i : std_logic_vector(0 to 22) := (others => '0');

 	--Outputs
   signal o : std_logic_vector(0 to 22);
 
begin
	uut: LeftShifter 
		generic map (
			n => 23,
			s => 3
		)
		port map (
         x => i,
         y => o
      );
		
   stim_proc: process
   begin
      wait for 100 ns;
		i <= "11111111111111111111111";
		wait for 100 ns;
		i <= "00011111111111111111111";
		wait for 100 ns;
		i <= "11110000000000000000000";
		wait for 100 ns;
		i <= "10101010101010101010101";
      wait;
   end process;

end;
