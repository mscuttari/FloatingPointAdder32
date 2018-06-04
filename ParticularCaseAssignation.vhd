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
	generic (
		operand_size	:	integer;				-- Operand size
		exponent_size	:	integer;				-- Exponent size
		mantissa_size	:	integer				-- Mantissa size
	);
	port (
		a			:	in 	std_logic_vector(operand_size - 1 downto 0);		-- First operand
		b			:	in 	std_logic_vector(operand_size - 1 downto 0);		-- Second operand
		enable	:	out	std_logic;													-- Enable signal
		result	:	out	std_logic_vector(operand_size - 1 downto 0)		-- Result
	);
end ParticularCaseAssignation;

architecture Behavioral of ParticularCaseAssignation is

	-- Operand A
	alias Sa is a(operand_size - 1);											-- A sign
	alias Ea is a((operand_size - 2) downto mantissa_size);			-- A exponent
	alias Ma is a((mantissa_size - 1) downto 0);							-- A mantissa
	
	-- Operand B
	alias Sb is b(operand_size - 1);											-- B sign
	alias Eb is b((operand_size - 2) downto mantissa_size);			-- B exponent
	alias Mb is b((mantissa_size - 1) downto 0);							-- B mantissa
	
	-- Result
	alias S is result(operand_size - 1);									-- Result sign
	alias E is result((operand_size - 2) downto mantissa_size);		-- Result exponent
	alias M is result((mantissa_size - 1) downto 0);					-- Result mantissa

begin
	
	process (a, b)
	begin
		-- 0 + anything = anything
		if (	Ea = ((operand_size - 2) downto mantissa_size => '0') and
				Ma = ((mantissa_size - 1) downto 0 => '0')) then
			
			enable <= '1';
			S <= Sb;
			E <= Eb;
			M <= Mb;
			
		-- anything + 0 = anything
		elsif (	Eb = ((operand_size - 2) downto mantissa_size => '0') and
					Mb = ((mantissa_size - 1) downto 0 => '0')) then
			
			enable <= '1';
			S <= Sa;
			E <= Ea;
			M <= Ma;
			
		-- + Infinity + Infinity = + Infinity
		elsif (	Sa = '0' and
				Ea = ((operand_size - 2) downto mantissa_size => '1') and
				Ma = ((mantissa_size - 1) downto 0 => '0') and
				Sb = '0' and
				Eb = ((operand_size - 2) downto mantissa_size => '1') and
				Mb = ((mantissa_size - 1) downto 0 => '0')) then
			
			enable <= '1';
			S <= '0';
			E <= (others => '1');
			M <= (others => '0');
		
		-- - Infinity - Infinity = - Infinity
		elsif (	Sa = '1' and
					Ea = ((operand_size - 2) downto mantissa_size => '1') and
					Ma = ((mantissa_size - 1) downto 0 => '0') and
					Sb = '1' and
					Eb = ((operand_size - 2) downto mantissa_size => '1') and
					Mb = ((mantissa_size - 1) downto 0 => '0')) then
			
			enable <= '1';
			S <= '1';
			E <= (others => '1');
			M <= (others => '0');
			
		-- + Infinity - Infinity = NaN
		elsif (	Sa = '0' and
					Ea = ((operand_size - 2) downto mantissa_size => '1') and
					Ma = ((mantissa_size - 1) downto 0 => '0') and
					Sb = '1' and
					Eb = ((operand_size - 2) downto mantissa_size => '1') and
					Mb = ((mantissa_size - 1) downto 0 => '0')) then
			
			enable <= '1';
			S <= '0';
			E <= (others => '1');
			M <= (0 => '1', others => '0');
		
		-- - Infinity + Infinity = NaN
		elsif (	Sa = '1' and
					Ea = ((operand_size - 2) downto mantissa_size => '1') and
					Ma = ((mantissa_size - 1) downto 0 => '0') and
					Sb = '0' and
					Eb = ((operand_size - 2) downto mantissa_size => '1') and
					Mb = ((mantissa_size - 1) downto 0 => '0')) then
			
			enable <= '1';
			S <= '0';
			E <= (others => '1');
			M <= (0 => '1', others => '0');
		
		-- NaN + anything = NaN
		elsif (Ea = ((operand_size - 2) downto mantissa_size => '1')) then
			
			enable <= '1';
			S <= '0';
			E <= (others => '1');
			M <= (0 => '1', others => '0');
		
		-- anything + NaN = NaN
		elsif (Eb = ((operand_size - 2) downto mantissa_size => '1')) then
			
			enable <= '1';
			S <= '0';
			E <= (others => '1');
			M <= (0 => '1', others => '0');
		
		else
			enable <= '0';
			S <= '-';
			E <= ((operand_size - 2) downto mantissa_size => '-');
			M <= ((mantissa_size - 1) downto 0 => '-');
		end if;
	end process;
	
end Behavioral;