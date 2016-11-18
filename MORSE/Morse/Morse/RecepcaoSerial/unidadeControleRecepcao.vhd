library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity unidadeControleRecepcao is
    port (
        clk: in  std_logic;
        bitSerial : in std_logic;
        liga : in std_logic;
        fimConta4 : in std_logic;
        fimConta3 : in std_logic;
        reset: in  std_logic;
        
        mostraDadoDisplay : out std_logic;
        conta4 : out std_logic;
        conta3 : out std_logic;
        registraPonto : out std_logic;
        registraTraco : out std_logic;
        zera : out std_logic;
        estadoDepuracao : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of unidadeControleRecepcao is 
    type tipoEstado is (s0, s1, s2, s3, s4, s5, s6, s7);
    signal estado : tipoEstado;
    
begin
    
    process (clk, reset)
    begin
        if (clk'event and clk='1') then
            if (reset = '1') then
                estado <= s0;
                estadoDepuracao <= "000";
            end if;
            if (estado /= s1) then
                case estado is
                    when s0 =>
                        if (liga = '1') then
                            estado <= s1;
                            estadoDepuracao <= "001";
                        end if ;
                    when s1 =>
                    when s2 =>
                        if (fimConta4 = '1') then
                            if (bitSerial = '0') then
                                estado <= s3;
                                estadoDepuracao <= "011";
                            else
                                estado <= s4;
                                estadoDepuracao <= "100";
                            end if ;
                        end if;
                    when s3 =>
                        estado <= s5;
                        estadoDepuracao <= "101";
                    when s4 =>
                        estado <= s5;
                        estadoDepuracao <= "101";
                    when s5 =>
                        if (fimConta3 = '1') then
                            if (bitSerial = '1') then
                                estado <= s6;
                                estadoDepuracao <= "110";
                            else
                                estado <= s7;
                                estadoDepuracao <= "111";
                            end if ;
                        end if ;
                    when s6 =>
						estado <= s1;
                        estadoDepuracao <= "001";
					when s7 =>
						estado <= s2;
                        estadoDepuracao <= "010";
                end case;
            elsif (bitSerial = '0') then
                estado <= s2;
                estadoDepuracao <= "010";
            end if;
        end if;
    end process;
    
    process (estado)
    begin
        case estado is
            when s0 =>
                mostraDadoDisplay <= '0';
                conta4 <= '0';
                conta3 <= '0';
                registraPonto <= '0';
                registraTraco <= '0';
                zera <= '0';
            when s1 =>
                mostraDadoDisplay <= '0';
                conta4 <= '0';
                conta3 <= '0';
                registraPonto <= '0';
                registraTraco <= '0';
                zera <= '0';
            when s2 =>
                mostraDadoDisplay <= '0';
                conta4 <= '1';
                conta3 <= '0';
                registraPonto <= '0';
                registraTraco <= '0';
                zera <= '0';
            when s3 =>
                mostraDadoDisplay <= '0';
                conta4 <= '0';
                conta3 <= '1';
                registraPonto <= '0';
                registraTraco <= '1';
                zera <= '0';
            when s4 =>
                mostraDadoDisplay <= '0';
                conta4 <= '0';
                conta3 <= '1';
                registraPonto <= '1';
                registraTraco <= '0';
                zera <= '0';
            when s5 =>
                mostraDadoDisplay <= '0';
                conta4 <= '0';
                conta3 <= '1';
                registraPonto <= '0';
                registraTraco <= '0';
                zera <= '0';
            when s6 =>
                mostraDadoDisplay <= '1';
                conta4 <= '0';
                conta3 <= '0';
                registraPonto <= '0';
                registraTraco <= '0';
                zera <= '1';
            when s7 =>
                mostraDadoDisplay <= '0';
                conta4 <= '0';
                conta3 <= '0';
                registraPonto <= '0';
                registraTraco <= '0';
                zera <= '1';
        end case;
    end process;
end architecture;