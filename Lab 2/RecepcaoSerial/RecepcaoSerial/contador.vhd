library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
    use IEEE.std_logic_arith.all;
entity contador is
    port (
        clk : in STD_LOGIC;
        conta : in STD_LOGIC;
        reset : in STD_LOGIC;


        contagem : out STD_LOGIC_VECTOR(3 downto 0);
        fim : out STD_LOGIC;
        conta4 : out STD_LOGIC;
        conta8 : out STD_LOGIC
    );
end contador;

architecture estrutural of contador is
    signal var_fim : std_logic;

begin
    process(clk, conta, reset)
        variable contador : integer range 0 to 9;
        variable contador_4 : integer range 0 to 3;
        variable contador_8 : integer range 0 to 7;
    begin
        if (reset = '1') then
            contador := 0;
            contador_4 := 0;
            contador_8 := 0;
            fim <= '0';
            conta4 <= '0';
            conta8 <= '0';
            var_fim <= '0';
        elsif (clk'event and clk= '1') then
            if (conta = '1') then
                if (contador_4 = 3) then
                    conta4 <= '1';
                    if (contador_8 = 7 and contador /= 9) then
                        contador_8 := 0;
                        contador := contador + 1;
                        conta8 <= '1';
								fim <= '0';
                    elsif (contador_8 = 7 and contador = 9) then
                        fim <= '1';
                        var_fim <= '1';
                        conta8 <= '1';
                    else
                        contador_8 := contador_8 + 1;
                        conta8 <= '0';
                    end if;
                else
                    contador_4 := contador_4 + 1;
                end if;
            end if;
        end if;
        contagem <= conv_std_logic_vector(contador, 4);
    end process;
end estrutural;