library ieee;
use ieee.std_logic_1164.ALL;

entity Rounder is
	generic (
		g	:	integer												-- Input length
	);
	port (
		i	:	in		std_logic_vector(g-1 downto 0);		--	Input vector
		o	:	out	std_logic									--	Rounded output
	);
end Rounder;

architecture Behavioral of Rounder is

	signal zero	:	std_logic_vector(g-2 downto 0) := (others => '0');

begin

	o <=	'1'	when	(i(g-1) = '1' and not (i(g-2 downto 0) = zero(g-2 downto 0))) else
			'0';

end Behavioral;

