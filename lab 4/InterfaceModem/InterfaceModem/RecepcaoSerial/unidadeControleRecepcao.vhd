library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity unidadeControleRecepcao is
    port (
        clk: in  std_logic;
        serialStartBit : in std_logic;
        prontoConta4 : in std_logic;
        prontoConta8 : in std_logic;
        fim : in std_logic; 
        reset: in  std_logic;
        
        pronto : out std_logic;
        conta : out std_logic;
        registra : out std_logic;
        zera : out std_logic
    );
end entity;

architecture rtl of unidadeControleRecepcao is 
    type tipoEstado is (s0, s1, s2, s3, s4);
    signal estado : tipoEstado;
    
begin
    
    process (clk, reset)
    begin
        if (clk'event and clk='1') then
            if (reset = '1') then
                estado <= s0;
            end if;
            if (estado /= s0) then
                case estado is
                    when s0 =>
                    when s1 =>
                        if (prontoConta4 = '1') then
                            estado <= s2;
                        end if;
                    when s2 =>
                        if (fim = '0') then
                            estado <= s3;
                        else
                            estado <= s4;
                        end if;
                    when s3 =>
                        if (prontoConta8 = '1') then
                            estado <= s2;
                        end if;
                    when s4 =>
                        estado <= s0;
                end case;
            elsif (serialStartBit = '0') then
                estado <= s1;
            end if;
        end if;
    end process;
    
    process (estado)
    begin
        case estado is
            when s0 =>
                pronto <= '1';
                zera <= '1';
                registra <= '0';
                conta <= '0';
            when s1 =>
                pronto <= '0';
                zera <= '0';
                registra <= '0';
                conta <= '1';
            when s2 =>
                pronto <= '0';
                zera <= '0';
                registra <= '1';
                conta <= '1';
            when s3 =>
                pronto <= '0';
                zera <= '0';
                registra <= '0';
                conta <= '1';
            when s4 =>
                pronto <= '0';
                zera <= '1';
                registra <= '0';
                conta <= '0';
        end case;
    end process;
end architecture;