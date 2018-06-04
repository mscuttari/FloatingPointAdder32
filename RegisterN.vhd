----------------------------------------------------------------------------------
-- Module Name:    	RegisterN
-- Project Name: 		32 bit floating point adder
-- Description: 		Block of n DFFs
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity RegisterN is
	generic (
		n 	: 	integer												-- Number of registers
	);					
	port (
		CLK		:	in		std_logic;							-- Clock
		D_vector	: 	in 	std_logic_vector(0 to n-1);	-- Input data
		Q_vector	: 	out	std_logic_vector(0 to n-1)		-- Output data
	);
end RegisterN;

architecture Behavioral of RegisterN is

	component DFF
		port (
			CLK	: 	in std_logic;
			D		: 	in std_logic;
			Q		: 	out std_logic
		);
	end component;

begin

	gen_dff: 
	for i in 0 to n-1 generate
		 dff: DFF
			port map(
				CLK => CLK,
				D => D_vector(i),
				Q => Q_vector(i)
			);
   end generate gen_dff;

end Behavioral;