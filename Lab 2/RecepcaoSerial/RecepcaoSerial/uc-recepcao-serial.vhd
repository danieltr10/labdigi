LIBRARY IEEE;
    USE IEEE.Std_logic_1164.ALL;
    USE IEEE.Std_logic_arith.ALL;
    USE ieee.std_logic_unsigned.ALL;

ENTITY unidade_controle IS
    PORT (
        clk : IN STD_LOGIC;
        serial_start_bit : IN STD_LOGIC;
        pronto_conta_4 : IN STD_LOGIC;
        pronto_conta_8 : IN STD_LOGIC;
        fim : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        pronto : OUT STD_LOGIC;
        conta : OUT STD_LOGIC;
        registra : OUT STD_LOGIC;
        zera : OUT STD_LOGIC;
        estado_depuracao : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        registra_depuracao : OUT STD_LOGIC
    );
END unidade_controle;

ARCHITECTURE uc OF unidade_controle IS TYPE tipo_estado IS (s0, s1, s2, s3, s4);
SIGNAL estado : tipo_estado;

BEGIN

    PROCESS (clk, reset)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            IF (reset = '1') THEN
                estado <= s0;
                estado_depuracao <= "000";
            END IF;
            IF (estado /= s0) THEN
                CASE estado IS
                    WHEN s0 =>
                    WHEN s1 =>
                        IF pronto_conta_4 = '1' THEN
                            estado <= s2;
                            estado_depuracao <= "010";
                        END IF;
                    WHEN s2 =>
                        IF fim = '0' THEN
                            estado <= s3;
                            estado_depuracao <= "011";
                        ELSE
                            estado <= s4;
                            estado_depuracao <= "100";
                        END IF;
                    WHEN s3 =>
                        IF pronto_conta_8 = '1' THEN
                            estado <= s2;
                            estado_depuracao <= "010";
                        END IF;
                    WHEN s4 =>
                        estado <= s0;
                        estado_depuracao <= "000";
                END CASE;
            ELSIF (serial_start_bit = '0') THEN
                estado <= s1;
                estado_depuracao <= "001";
            END IF;
        END IF;
    END PROCESS;

    PROCESS (estado)
    BEGIN
        CASE estado IS
            WHEN s0 =>
                pronto <= '1';
                zera <= '1';
                registra <= '0';
                registra_depuracao <= '0';
                conta <= '0';
            WHEN s1 =>
                pronto <= '0';
                zera <= '0';
                registra <= '0';
                registra_depuracao <= '0';
                conta <= '1';
            WHEN s2 =>
                pronto <= '0';
                zera <= '0';
                registra <= '1';
                registra_depuracao <= '1';
                conta <= '1';
            WHEN s3 =>
                pronto <= '0';
                zera <= '0';
                registra <= '0';
                registra_depuracao <= '0';
                conta <= '1';
            WHEN s4 =>
                pronto <= '0';
                zera <= '1';
                registra <= '0';
                registra_depuracao <= '0';
                conta <= '0';
        END CASE;
    END PROCESS;
    END uc;-- VHDL da Unidade de Controle