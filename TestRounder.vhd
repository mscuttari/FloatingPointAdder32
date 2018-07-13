library ieee;
use ieee.std_logic_1164.all;
 
entity TestRounder is
end TestRounder;
 
architecture behavior of TestRounder is 

    component Rounder
		generic (
			g	:	integer
		);
		port (
         i	:	in		std_logic_vector(g-1 downto 0);
         o	:	out	std_logic
      );
    end component;
    

   --Inputs
   signal i : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal o : std_logic;
	
begin
 
	uut: Rounder
	generic map (
		g => 4
	)
	port map (
		i => i,
      o => o
	);

   stim_proc: process
   begin
      wait for 100 ns;	
		i <= "0111";
		wait for 100 ns;	
		i <= "1000";
		wait for 100 ns;	
		i <= "1001";
      wait;
   end process;

end;
