--------------------------------------------------------------------------------
-- Module Name:   TestZeroCounter
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module ZeroCounter
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
 
entity TestZeroCounter is
end TestZeroCounter;
 
architecture behavior of TestZeroCounter is 
	component ZeroCounter
		port(
			mantissa :	in		std_logic_vector(27 downto 0);
			count 	:	out	std_logic_vector(4 downto 0)
		);
   end component;

   -- Input data
   signal mantissa : std_logic_vector(27 downto 0) := (others => '0');

 	-- Output data
   signal count : std_logic_vector(4 downto 0);
 
	
begin
 
   uut: ZeroCounter
		port map (
			mantissa	=>	mantissa,
         count 	=>	count
       );
 
   -- Stimulus process
   stim_proc: process
   begin
      wait for 100 ns;	
		mantissa <= "1100000000000000000000000000";
		wait for 100 ns;
		mantissa <= "0001101010010101010100101000";
		wait for 100 ns;
		mantissa <= "1000000000000110010110101000";
		wait for 100 ns;
		mantissa <= "0000000000000000000000000010";
		wait for 100 ns;
		mantissa <= "0000000000000000000000000000";
      wait;
   end process;

end;
