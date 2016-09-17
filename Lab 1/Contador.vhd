library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
entity contador is
 port (
 clk : in STD_LOGIC;
 conta : in STD_LOGIC;
 zera : in STD_LOGIC;
 

 contagem : out STD_LOGIC_VECTOR(3 downto 0);
 fim : out STD_LOGIC
 );
end contador;

architecture estrutural of contador is
signal var_fim : std_logic;

begin
	process(clk, conta, zera)
	variable contador : integer range 0 to 10;
	begin
		if zera = '1' then
				contador := 0;
				fim <= '0';
				var_fim <= '0';
		elsif clk'event and clk= '1' then
			if conta = '1' then
				if contador = 10 then
					fim <= '1';
					var_fim <= '1';
				end if;
				else
					contador := contador + 1;
				end if;
			end if;
		end if;
		contagem <= conv_std_logic_vector(contador, 4);
	end process;
end estrutural;