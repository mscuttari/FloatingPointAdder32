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
		port (
			mantissa :	in		std_logic_vector(27 downto 0);
			count 	:	out	std_logic_vector(4 downto 0)
		);
   end component;

   -- Input data
   signal mantissa : std_logic_vector(27 downto 0);

 	-- Output data
   signal count : std_logic_vector(4 downto 0);
	
	signal count_expected	:	std_logic_vector(4 downto 0);
	
	signal check	:	std_logic;
	
begin
 
   uut: ZeroCounter
		port map (
			mantissa	=>	mantissa,
         count 	=>	count
       );
 
	test: check <= '1' when count = count_expected else '0';
 
   -- Stimulus process
   stim_proc: process
   begin
	
		-- Mantissa filled with 0s
		mantissa			<=	"0000000000000000000000000000";
		count_expected	<=	"11100";
		
		wait for 250 ns;
		
		-- Mantissa with 10 leading zeros
		mantissa			<=	"0000000000100000000000000000";
		count_expected	<=	"01010";
		
		wait for 250 ns;
		
		-- Mantissa with 20 leading zeros
		mantissa			<=	"0000000000000000000010000000";
		count_expected	<=	"10100";
		
		wait for 250 ns;
		
		-- Mantissa filled with 1s
		mantissa			<=	"1111111111111111111111111111";
		count_expected	<=	"00000";
		
		wait;
		
   end process;
	
end;