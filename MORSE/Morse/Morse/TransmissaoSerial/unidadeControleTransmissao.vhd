-- VHDL da Unidade de Controle

library IEEE;
    use IEEE.Std_logic_1164.all;
    use IEEE.Std_logic_arith.all;
    use ieee.std_logic_unsigned.all;

ENTITY unidade_controle IS
    PORT(
        clk      : IN   STD_LOGIC;
        partida  : IN   STD_LOGIC;
        fim       : IN STD_LOGIC;
        reset    : IN STD_LOGIC;

        conta   : OUT STD_LOGIC;
        desloca   : OUT STD_LOGIC;
        zera   : OUT STD_LOGIC;
        registra   : OUT STD_LOGIC;
        estado_atual  : OUT STD_LOGIC_VECTOR(1 downto 0);
        pronto : OUT STD_LOGIC
    );
END unidade_controle;

ARCHITECTURE uc OF unidade_controle IS
    TYPE tipo_estado IS (s0, s1, s2, s3);
    SIGNAL estado   : tipo_estado;
    SIGNAL partidaz   : STD_LOGIC;
    SIGNAL partida_x   : STD_LOGIC;
BEGIN
    PROCESS (clk,partida)
    BEGIN
        if (clk='1' and clk'event) then
            partidaz<=partida;
        end if;
        partida_x <= partida and (not partidaz);
    END PROCESS;

    PROCESS (clk, reset, partida)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (reset = '1') then
                estado <= s0;
                estado_atual <= "00";
            end    IF;

            CASE estado IS

                WHEN s0 =>
                    IF (partida_x) = '1' THEN
                        estado <= s1;
						estado_atual <= "01";
                    ELSE
                        estado <= s0;
                        estado_atual <= "00";
                    END IF;

                WHEN s1 =>
                    estado <= s2;
                    estado_atual <= "10";

                WHEN s2 =>
                    IF fim = '0' THEN
                        estado <= s2;
                        estado_atual <= "10";
                    ELSE
                        estado <= s3;
                        estado_atual <= "11";
                    END IF;

                WHEN s3 =>
                    estado <= s0;
                    estado_atual <= "00";

            END CASE;
        END IF;
    END PROCESS;

    PROCESS (estado)
    BEGIN
        CASE estado IS
            WHEN s0 =>
                zera <= '0';
                registra <= '0';
                desloca <= '0';
                conta <= '0';
                pronto <= '0';

            WHEN s1 =>
                zera <= '0';
                registra <= '1';
                desloca <= '0';
                conta <= '0';
                pronto <= '0';

            WHEN s2 =>
                zera <= '0';
                registra <= '0';
                desloca <= '1';
                conta <= '1';
                pronto <= '0';

            WHEN s3 =>
                zera <= '1';
                registra <= '0';
                desloca <= '0';
                conta <= '0';
                pronto <= '1';

        END CASE;
    END PROCESS;

END uc;-- VHDL da Unidade de Controle





































































































































