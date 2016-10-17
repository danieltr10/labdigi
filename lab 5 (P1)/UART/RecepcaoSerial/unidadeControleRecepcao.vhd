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
        recebeDado: in std_logic;
        
        pronto : out std_logic;
        conta : out std_logic;
        registra : out std_logic;
        zera : out std_logic;
        temDado : out std_logic;
        estadoDepuracao : out std_logic_vector(2 downto 0)
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
                estadoDepuracao <= "000";
            end if;
            if (estado /= s0) then
                case estado is
                    when s0 =>
                    when s1 =>
                        if (prontoConta4 = '1') then
                            estado <= s2;
                            estadoDepuracao <= "010";
                        end if;
                    when s2 =>
                        if (fim = '0') then
                            estado <= s3;
                            estadoDepuracao <= "011";
                        else
                            estado <= s4;
                            estadoDepuracao <= "100";
                        end if;
                    when s3 =>
                        if (prontoConta8 = '1') then
                            estado <= s2;
                            estadoDepuracao <= "010";
                        end if;
                    when s4 =>
                        if (recebeDado = '1') then
                            estado <= s0;
                            estadoDepuracao <= "000";
                        end if;
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
                temDado <= '0';
            when s1 =>
                pronto <= '0';
                zera <= '0';
                registra <= '0';
                conta <= '1';
                temDado <= '0';
            when s2 =>
                pronto <= '0';
                zera <= '0';
                registra <= '1';
                conta <= '1';
                temDado <= '0';
            when s3 =>
                pronto <= '0';
                zera <= '0';
                registra <= '0';
                conta <= '1';
                temDado <= '0';
            when s4 =>
                pronto <= '0';
                zera <= '0';
                registra <= '0';
                conta <= '0';
                temDado <= '1';
        end case;
    end process;
end architecture;