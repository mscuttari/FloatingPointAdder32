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
			a			:	in 	std_logic_vector(31 downto 0);
			b			:	in 	std_logic_vector(31 downto 0);
			enable	:	out	std_logic;
			result	:	out	std_logic_vector(31 downto 0)
		);
	end component;
   
   -- Inputs
   signal a 	:	std_logic_vector(0 to 31) := (others => '0');
   signal b 	:	std_logic_vector(0 to 31) := (others => '0');

 	-- Outputs
	signal e		:	std_logic;
	signal s		:	std_logic_vector(0 to 31);

begin
   uut: ParticularCaseAssignation
		generic map (
			operand_size => 32,
			exponent_size => 8,
			mantissa_size => 23
		)
		port map (
         a => a,
         b => b,
			enable => e,
			result => s
		);

   stim_proc: process
   begin
		wait for 100 ns;
		a <= "01111111100000000000000000000000";
		b <= "11111111100000000000000000000000";
		wait for 100 ns;
		a <= "11111111100000000000000000000000";
		b <= "01111111100000000000000000000000";
		wait for 100 ns;
		a <= "01111111100000000000000000000000";
		b <= "00000000000000000000000000000000";
		wait for 100 ns;
		a <= "11111111100000000000000000000000";
		b <= "00000000000000000000000000000000";
		wait for 100 ns;
		b <= "01111111100000000000000000000000";
		a <= "00000000000000000000000000000000";
		wait for 100 ns;
		b <= "11111111100000000000000000000000";
		a <= "00000000000000000000000000000000";
		wait for 100 ns;
		a <= "11111111100000000000000000000001";
		b <= "00000000000000000000000000000000";
		wait for 100 ns;
		b <= "11111111100000000000000000000001";
		a <= "00000000000000000000000000000000";
		wait for 100 ns;
		a <= "10101010101010101010101010101010";
		b <= "00000000000000000000000000000000";
		wait for 100 ns;
		b <= "10101010101010101010101010101010";
		a <= "00000000000000000000000000000000";
		wait for 100 ns;
		b <= "10101010101010101010101010101010";
		a <= "01010101010101010101010101010101";
		wait;
   end process;

end;