library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
entity contador is
 port (
 CLK : in STD_LOGIC;

 estado : in STD_LOGIC_VECTOR(1 downto 0);
 CONTAGEM : out STD_LOGIC_VECTOR(3 downto 0);
 FIM : out STD_LOGIC
 );
end contador;

architecture arquitetura_cont of contador is
signal var_fim : std_logic;

begin
	process(CLK, estado)
	variable contador : integer range 0 to 15;
	begin
		if estado ="01" then
				contador := 0;
				FIM <= '0';
				var_fim <= '0';
		elsif CLK'event and CLK = '1' then
			if contador = 10 then
				FIM <= '1';
				var_fim <= '1';
			end if;
			if estado ="10" and var_fim = '0' then
				contador := contador + 1;
			end if;
		end if;
		CONTAGEM <= conv_std_logic_vector(contador, 4);
	end process;
end arquitetura_cont;