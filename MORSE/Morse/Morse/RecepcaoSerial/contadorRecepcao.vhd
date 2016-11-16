library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity contadorRecepcao is
    port (
        clk: in  std_logic;
        conta : in std_logic;
        reset: in  std_logic;
        
        fim : out std_logic;
        conta4 : out std_logic;
        conta8 : out std_logic
    );
end entity;

architecture rtl of contadorRecepcao is
    signal var_fim : std_logic;
begin
    process(clk, conta, reset)
        variable contador : integer range 0 to 9;
        variable contador8 : integer range 0 to 7;
        variable contador16 : integer range 0 to 15;
    begin
        if (reset = '1') then
            contador := 0;
            contador8 := 0;
            contador16 := 0;
            fim <= '0';
            conta4 <= '0';
            conta8 <= '0';
            var_fim <= '0';
        elsif (clk'event and clk='1') then
            if (conta = '1') then
                if (contador8 = 7) then
                    conta4 <= '1';
                    if (contador16 = 15 and contador /= 9) then
                        contador16 := 0;
                        contador := contador + 1;
                        conta8 <= '1';
                        fim <= '0';
                    elsif (contador16 = 15 and contador = 9) then
                        fim <= '1';
                        var_fim <= '1';
                        conta8 <= '1';
                    else
                        contador16 := contador16 + 1;
                        conta8 <= '0';
                    end if;
                else
                    contador8 := contador8 + 1;
                end if;
            end if;
        end if;
    end process;
end architecture;