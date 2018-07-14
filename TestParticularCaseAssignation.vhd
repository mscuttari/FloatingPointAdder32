--------------------------------------------------------------------------------
-- Module Name:   TestParticularCaseAssignation
-- Project Name:  FloatingPointAdder32
-- Description:   VHDL test bench for module ParticularCaseAssignation
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity TestParticularCaseAssignation is
end TestParticularCaseAssignation;
 
architecture behavior of TestParticularCaseAssignation is 
	component ParticularCaseAssignation
		port (
			a					:	in 	std_logic_vector(31 downto 0);
			b					:	in 	std_logic_vector(31 downto 0);
			enable			:	out	std_logic;
			result			:	out	std_logic_vector(31 downto 0);
			normalized_a	:	out	std_logic;
			normalized_b	:	out	std_logic
		);
	end component;
   
   -- Inputs
   signal a 	:	std_logic_vector(31 downto 0);
   signal b 	:	std_logic_vector(31 downto 0);

 	-- Outputs
	signal enable			:	std_logic;
	signal result			:	std_logic_vector(31 downto 0);
	signal normalized_a	:	std_logic;
	signal normalized_b	:	std_logic;

begin
   uut: ParticularCaseAssignation
		port map (
         a => a,
         b => b,
			enable => enable,
			result => result,
			normalized_a => normalized_a,
			normalized_b => normalized_b
		);

   stim_proc: process
   begin
		a <= "01111111100000000000000000000000";
		b <= "11111111100000000000000000000000";
		-- enable			1
		-- result			01111111100000000000000000000001
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "11111111100000000000000000000000";
		b <= "01111111100000000000000000000000";
		-- enable			1
		-- result			01111111100000000000000000000001
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "01111111100000000000000000000000";
		b <= "00000000000000000000000000000000";
		-- enable			1
		-- result			01111111100000000000000000000000
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "11111111100000000000000000000000";
		b <= "00000000000000000000000000000000";
		-- enable			1
		-- result			11111111100000000000000000000000
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "00000000000000000000000000000000";
		b <= "01111111100000000000000000000000";
		-- enable			1
		-- result			01111111100000000000000000000000
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "00000000000000000000000000000000";
		b <= "11111111100000000000000000000000";
		-- enable			1
		-- result			11111111100000000000000000000000
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "11111111100000000000000000000001";
		b <= "00000000000000000000000000000000";
		-- enable			1
		-- result			11111111100000000000000000000001
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "00000000000000000000000000000000";
		b <= "11111111100000000000000000000001";
		-- enable			1
		-- result			11111111100000000000000000000001
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "10101010101010101010101010101010";
		b <= "00000000000000000000000000000000";
		-- enable			1
		-- result			10101010101010101010101010101010
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "00000000000000000000000000000000";
		b <= "10101010101010101010101010101010";
		-- enable			1
		-- result			10101010101010101010101010101010
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "01010101010101010101010101010101";
		b <= "11010101010101010101010101010101";
		-- enable			1
		-- result			00000000000000000000000000000000
		-- normalized_a	-
		-- normalized_b	-
		
		wait for 100 ns;
		
		a <= "01010101010101010101010101010101";
		b <= "10101010101010101010101010101010";
		-- enable			0
		-- result			--------------------------------
		-- normalized_a	1
		-- normalized_b	1
		
		wait for 100 ns;
		
		a <= "00000000010101010101010101010101";
		b <= "11100100101010101010101010101010";
		-- enable			0
		-- result			--------------------------------
		-- normalized_a	0
		-- normalized_b	1
		
		
		wait for 100 ns;
		
		a <= "01010101010101010101010101010101";
		b <= "10000000001010101010101010101010";
		-- enable			0
		-- result			--------------------------------
		-- normalized_a	1
		-- normalized_b	0
		
		wait for 100 ns;
		
		a <= "00000000010101010101010101010101";
		b <= "10000000001010101010101010101010";
		-- enable			0
		-- result			--------------------------------
		-- normalized_a	0
		-- normalized_b	0
		
		wait;
		
   end process;

end;