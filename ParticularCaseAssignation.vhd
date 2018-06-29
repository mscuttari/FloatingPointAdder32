----------------------------------------------------------------------------------
-- Module Name:    	ParticularCaseAssignation
-- Project Name: 		32 bit floating point adder
-- Description: 		Examine particular input cases such as NaN or Infinity
--
--							Value				Sign			Exponent			Mantissa
--							Zero				-				all 0s			all 0s
--							Denormalized	-				all 0s			non 0s
--							+ Infinity		0				all 1s			all 0s
--							- Infinity		1				all 1s			all 0s
--							QNaN				-				all 1s			1 & non 0s
--							SNan				-				all 1s			0 & non 0s
--							
--							Operation						Result
--							+ Infinity + Infinity		+ Infinity
--							- Infinity - Infinity		- Infinity
--							+ Infinity - Infinity		NaN
--							anything + NaN					NaN
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ParticularCaseAssignation is
	port (
		a			:	in 	std_logic_vector(31 downto 0);		-- First operand
		b			:	in 	std_logic_vector(31 downto 0);		-- Second operand
		enable	:	out	std_logic;													-- Enable signal
		result	:	out	std_logic_vector(31 downto 0)		-- Result
	);
end ParticularCaseAssignation;

architecture Behavioral of ParticularCaseAssignation is

	-- Operand A
	alias Sa is a(31);						-- A sign
	alias Ea is a(30 downto 23);			-- A exponent
	alias Ma is a(22 downto 0);			-- A mantissa
	
	-- Operand B
	alias Sb is b(31);						-- B sign
	alias Eb is b(30 downto 23);			-- B exponent
	alias Mb is b(22 downto 0);			-- B mantissa
	
	-- Result
	alias S is result(31);					-- Result sign
	alias E is result(30 downto 23);		-- Result exponent
	alias M is result(22 downto 0);		-- Result mantissa

begin
	
	process (a, b)
	begin
		-- 0 + anything = anything
		if (	Ea = (30 downto 23 => '0') and
				Ma = (22 downto 0 => '0')) then
			
			enable <= '1';
			S <= Sb;
			E <= Eb;
			M <= Mb;
			
		-- anything + 0 = anything
		elsif (	Eb = (30 downto 23 => '0') and
					Mb = (22 downto 0 => '0')) then
			
			enable <= '1';
			S <= Sa;
			E <= Ea;
			M <= Ma;
			
		-- + Infinity + Infinity = + Infinity
		elsif (	Sa = '0' and
				Ea = (30 downto 23 => '1') and
				Ma = (22 downto 0 => '0') and
				Sb = '0' and
				Eb = (30 downto 23 => '1') and
				Mb = (22 downto 0 => '0')) then
			
			enable <= '1';
			S <= '0';
			E <= (others => '1');
			M <= (others => '0');
		
		-- - Infinity - Infinity = - Infinity
		elsif (	Sa = '1' and
					Ea = (30 downto 23 => '1') and
					Ma = (22 downto 0 => '0') and
					Sb = '1' and
					Eb = (30 downto 23 => '1') and
					Mb = (22 downto 0 => '0')) then
			
			enable <= '1';
			S <= '1';
			E <= (others => '1');
			M <= (others => '0');
			
		-- + Infinity - Infinity = NaN
		elsif (	Sa = '0' and
					Ea = (30 downto 23 => '1') and
					Ma = (22 downto 0 => '0') and
					Sb = '1' and
					Eb = (30 downto 23 => '1') and
					Mb = (22 downto 0 => '0')) then
			
			enable <= '1';
			S <= '0';
			E <= (others => '1');
			M <= (0 => '1', others => '0');
		
		-- - Infinity + Infinity = NaN
		elsif (	Sa = '1' and
					Ea = (30 downto 23 => '1') and
					Ma = (22 downto 0 => '0') and
					Sb = '0' and
					Eb = (30 downto 23 => '1') and
					Mb = (22 downto 0 => '0')) then
			
			enable <= '1';
			S <= '0';
			E <= (others => '1');
			M <= (0 => '1', others => '0');
		
		-- NaN + anything = NaN
		elsif (Ea = (30 downto 23 => '1')) then
			
			enable <= '1';
			S <= '0';
			E <= (others => '1');
			M <= (0 => '1', others => '0');
		
		-- anything + NaN = NaN
		elsif (Eb = (30 downto 23 => '1')) then
			
			enable <= '1';
			S <= '0';
			E <= (others => '1');
			M <= (0 => '1', others => '0');
		
		else
			enable <= '0';
			S <= '-';
			E <= (30 downto 23 => '-');
			M <= (22 downto 0 => '-');
		end if;
	end process;
	
end Behavioral;