library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
    use IEEE.std_logic_arith.all;
entity contador is
    port (
        clk : in STD_LOGIC;
        conta : in STD_LOGIC;
        zera : in STD_LOGIC;

        fim : out STD_LOGIC
    );
end contador;

architecture estrutural of contador is

begin
    process(clk, conta, zera)
        variable contador : integer range 0 to 82;
    begin
        if zera = '1' then
            contador := 0;
            fim <= '0';
        elsif (clk'event and clk= '1') then
            if (conta = '1') then
                if (contador = 82) then
                    fim <= '1';
                else
                    contador := contador + 1;
                end if;
            end if;
        end if;
    end process;
end estrutural;