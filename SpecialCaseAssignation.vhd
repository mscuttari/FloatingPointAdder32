----------------------------------------------------------------------------------
-- Module Name:    	SpecialCaseAssignation
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

entity SpecialCaseAssignation is
	port (
		a					:	in 	std_logic_vector(31 downto 0);			-- First operand
		b					:	in 	std_logic_vector(31 downto 0);			-- Second operand
		enable			:	out	std_logic;										-- Enable signal
		result			:	out	std_logic_vector(31 downto 0)				-- Result
	);
end SpecialCaseAssignation;

architecture Behavioral of SpecialCaseAssignation is

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
	
	process (a, b, Sa, Ea, Ma, Sb, Eb, Mb)
	begin
		-- Zero + anything = anything
		if (	Ea = "00000000" and
				Ma = "00000000000000000000000") then
			
			enable <= '1';
			S <= Sb;
			E <= Eb;
			M <= Mb;
			
		-- Anything + zero = anything
		elsif (	Eb = "00000000" and
					Mb = "00000000000000000000000") then
			
			enable <= '1';
			S <= Sa;
			E <= Ea;
			M <= Ma;
			
		-- + Infinity + Infinity = + Infinity
		elsif (	Sa = '0' and
					Ea = "11111111" and
					Ma = "00000000000000000000000" and
					Sb = '0' and
					Eb = "11111111" and
					Mb = "00000000000000000000000") then
			
			enable <= '1';
			S <= '0';
			E <= "11111111";
			M <= "00000000000000000000000";
		
		-- - Infinity - Infinity = - Infinity
		elsif (	Sa = '1' and
					Ea = "11111111" and
					Ma = "00000000000000000000000" and
					Sb = '1' and
					Eb = "11111111" and
					Mb = "00000000000000000000000") then
			
			enable <= '1';
			S <= '1';
			E <= "11111111";
			M <= "00000000000000000000000";
			
		-- + Infinity - Infinity = NaN
		elsif (	Sa = '0' and
					Ea = "11111111" and
					Ma = "00000000000000000000000" and
					Sb = '1' and
					Eb = "11111111" and
					Mb = "00000000000000000000000") then
			
			enable <= '1';
			S <= '0';
			E <= "11111111";
			M <= "00000000000000000000001";
		
		-- - Infinity + Infinity = NaN
		elsif (	Sa = '1' and
					Ea = "11111111" and
					Ma = "00000000000000000000000" and
					Sb = '0' and
					Eb = "11111111" and
					Mb = "00000000000000000000000") then
			
			enable <= '1';
			S <= '0';
			E <= "11111111";
			M <= "00000000000000000000001";
			
			-- Infinity + anything (different from NaN) = Infinity
		elsif (Ea = "11111111" and
				 Ma = "00000000000000000000000" and
				 not(Eb = "11111111")) then
			
			enable <= '1';
			S <= Sa;
			E <= Ea;
			M <= Ma;
			
		-- Anything (different from NaN) + Infinity = Infinity
		elsif (Eb = "11111111" and
				 Mb = "00000000000000000000000" and
				 not(Ea = "11111111")) then
			
			enable <= '1';
			S <= Sb;
			E <= Eb;
			M <= Mb;
		
		-- NaN + anything = NaN
		elsif (Ea = "11111111") then
			
			enable <= '1';
			S <= '0';
			E <= "11111111";
			M <= "00000000000000000000001";
		
		-- Anything + NaN = NaN
		elsif (Eb = "11111111") then
			
			enable <= '1';
			S <= '0';
			E <= "11111111";
			M <= "00000000000000000000001";
		
		--	Opposite values
		elsif (Sa = not Sb and
					Ea = Eb and
					Ma = Mb) then
			
			enable <= '1';
			S <= '0';
			E <= "00000000";
			M <= "00000000000000000000000";
			
		-- No special cases found
		else
			enable <= '0';
			S <= '-';
			E <= "--------";
			M <= "-----------------------";
		end if;
	end process;
	
end Behavioral;