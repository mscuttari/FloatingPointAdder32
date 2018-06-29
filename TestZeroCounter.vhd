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
			mantissa :	in		std_logic_vector(22 downto 0);
			count 	:	out	std_logic_vector(4 downto 0)
		);
   end component;

   -- Input data
   signal mantissa : std_logic_vector(22 downto 0) := (others => '0');

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
		mantissa <= "10000000000000000000000";
		wait for 100 ns;
		mantissa <= "01101010010101010100101";
		wait for 100 ns;
		mantissa <= "00000000001100101101010";
		wait for 100 ns;
		mantissa <= "00000000000000000000001";
		wait for 100 ns;
		mantissa <= "00000000000000000000000";
      wait;
   end process;

end;
