library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity Registrador is
 port (
 CLK : in STD_LOGIC;
 estado : in STD_LOGIC_VECTOR(1 downto 0);
 DADOS : in STD_LOGIC_VECTOR (6 downto 0); -- data in
 SERIAL : out STD_LOGIC; -- data out
 SERIAL_C : out STD_LOGIC; -- data out
 ISERIAL_D : out STD_LOGIC_VECTOR (8 downto 0)
 );
end Registrador;

architecture exemplo of Registrador is
signal ISERIAL : STD_LOGIC_VECTOR (8 downto 0);

begin
	process (CLK, ISERIAL, estado)
	begin
		if (CLK'event and CLK='1') then
			if (estado = "01") then
				ISERIAL <= '0' & DADOS & (DADOS(0) xor DADOS(1)xor DADOS(2)xor DADOS(3)xor DADOS(4)xor DADOS(5)xor DADOS(6));
				ISERIAL_D <= '0' & DADOS & (DADOS(0) xor DADOS(1)xor DADOS(2)xor DADOS(3)xor DADOS(4)xor DADOS(5)xor DADOS(6));
				SERIAL <= '1';
				SERIAL_C <= '1';
			elsif (estado = "10") then
				SERIAL <= ISERIAL(8);
				SERIAL_C <= ISERIAL(8);
				ISERIAL <= ISERIAL(7 downto 0) & '1';
				ISERIAL_D <= ISERIAL(7 downto 0) & '1';
			else 
			SERIAL <= '1';
			SERIAL_C <= '1';
			end if;
		end if;
	end process;
end exemplo;