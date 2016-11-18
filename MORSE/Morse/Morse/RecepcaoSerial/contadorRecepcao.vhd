library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity contadorRecepcao is
    port (
        clk: in  std_logic;
        conta3 : in std_logic;
        reset: in  std_logic;
        
        fimConta3 : out std_logic
    );
end entity;

architecture rtl of contadorRecepcao is
begin
    process(clk, conta3, reset)
        variable contador3 : integer range 0 to 2;
    begin
        if (reset = '1') then
            contador3 := 0;
            fimConta3 <= '0';
        elsif (clk'event and clk='1') then
            if (conta3 = '1') then
                if (contador3 = 2) then
                    fimConta3 <= '1';
                else
                    contador3 := contador3 + 1;
                end if;
            end if;
        end if;
    end process;
end architecture;