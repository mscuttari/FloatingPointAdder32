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
		a					:	in 	std_logic_vector(31 downto 0);			-- First operand
		b					:	in 	std_logic_vector(31 downto 0);			-- Second operand
		enable			:	out	std_logic;										-- Enable signal
		result			:	out	std_logic_vector(31 downto 0);			-- Result
		normalized_a	:	out	std_logic;										--	Whether the first operand is normalized or not
		normalized_b	:	out	std_logic										--	Whether the second operand is normalized or not
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
		if (	Ea = "00000000" and
				Ma = "00000000000000000000000") then
			
			enable <= '1';
			S <= Sb;
			E <= Eb;
			M <= Mb;
			normalized_a <= '-';
			normalized_b <= '-';
			
		-- anything + 0 = anything
		elsif (	Eb = "00000000" and
					Mb = "00000000000000000000000") then
			
			enable <= '1';
			S <= Sa;
			E <= Ea;
			M <= Ma;
			normalized_a <= '-';
			normalized_b <= '-';
			
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
			normalized_a <= '-';
			normalized_b <= '-';
		
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
			normalized_a <= '-';
			normalized_b <= '-';
			
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
			normalized_a <= '-';
			normalized_b <= '-';
		
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
			normalized_a <= '-';
			normalized_b <= '-';
		
		-- NaN + anything = NaN
		elsif (Ea = "11111111") then
			
			enable <= '1';
			S <= '0';
			E <= "11111111";
			M <= "00000000000000000000001";
			normalized_a <= '-';
			normalized_b <= '-';
		
		-- anything + NaN = NaN
		elsif (Eb = "11111111") then
			
			enable <= '1';
			S <= '0';
			E <= "11111111";
			M <= "00000000000000000000001";
			normalized_a <= '-';
			normalized_b <= '-';
		
		elsif (Sa = not Sb and
					Ea = Eb and
					Ma = Mb) then
			
			enable <= '1';
			S <= '0';
			E <= "00000000";
			M <= "00000000000000000000000";
			normalized_a <= '-';
			normalized_b <= '-';
		
		--	both numbers not normalized
		elsif	(Ea = "00000000" and
				 Eb = "00000000") then
				 
			enable <= '0';
			S <= '-';
			E <= "--------";
			M <= "-----------------------";
			normalized_a <= '0';
			normalized_b <= '0';
		
		-- only number a not normalized
		elsif (Ea = "00000000") then
		
			enable <= '0';
			S <= '-';
			E <= "--------";
			M <= "-----------------------";
			normalized_a <= '0';
			normalized_b <= '1';
		
		-- only number b not normalized
		elsif (Eb = "00000000") then
		
			enable <= '0';
			S <= '-';
			E <= "--------";
			M <= "-----------------------";
			normalized_a <= '1';
			normalized_b <= '0';
		
		-- both numbers normalized
		else
			enable <= '0';
			S <= '-';
			E <= "--------";
			M <= "-----------------------";
			normalized_a <= '1';
			normalized_b <= '1';
		end if;
	end process;
	
end Behavioral;