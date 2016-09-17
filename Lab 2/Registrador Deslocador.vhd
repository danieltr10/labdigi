library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity Registrador is
 port (
 clk : in STD_LOGIC;
 registra : in STD_LOGIC;
 serial : in STD_LOGIC -- data out
 
 paridade : out STD_LOGIC;
 dados : out STD_LOGIC_VECTOR (10 downto 0); -- data in
 );
end Registrador;

architecture estrutural of Registrador is
signal IREGISTER : STD_LOGIC_VECTOR (10 downto 0);
signal IREGISTER_AUX : STD_LOGIC_VECTOR (10 downto 0);

begin
	process (clk, IREGISTER, IREGISTER_AUX, registra)
	begin
		if (clk'event and clk='1') then
			if (registra = '1') then
				dados <= serial & IREGISTER(10 downto 1);
				IREGISTER_AUX <= serial & IREGISTER(10 downto 1);
			end if;
		end if;
	end process;
	
	process (clk, IREGISTER, IREGISTER_AUX)
	begin
		if (clk'event and clk='0') then	
			IREGISTER <= IREGISTER_AUX;
		end if;
	end process;
	
	process (clk, IREGISTER)
	begin
		paridade <= IREGISTER(2)
			  xnor (IREGISTER(9) 
		      xor   IREGISTER(8) 
			  xor   IREGISTER(7) 
			  xor   IREGISTER(6) 
			  xor   IREGISTER(5) 
			  xor   IREGISTER(4) 
			  xor   IREGISTER(3));
	end process;

end estrutural;