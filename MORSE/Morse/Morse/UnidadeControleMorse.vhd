library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UnidadeControleMorse is
    port (
        CLK : in std_logic;
        MORSE : in  std_logic;
        COUNTER : in std_logic;
        RESET : in std_logic;
        LIGA : in std_logic;
        PRONTOTRANSMISSAO: in std_logic;

        --ModemSignals
        DTR : out std_logic;
        --Recep��o
        CD : in STD_LOGIC;
        --Transmiss�o
        CTS : in std_logic;
        RTS : out std_logic;


        carregaPonto : out std_logic;
        carregaTraco : out std_logic;
        carregaFim : out std_logic;
        PARTIDA : out std_logic;
        ENABLERECEPCAO : out std_logic;
        ESTADO_DEPURACAO : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of UnidadeControleMorse is
    type estado is (t0, t1, t2, t3, t4, t5, t6);
    signal state : estado := t0;
	signal last_MORSE : std_logic := '0';
    signal input_detected : std_logic := '0';
    signal counter_contador : std_logic := '0';

begin
    process (CD)
    begin
        ENABLERECEPCAO <= not CD;
    end process;
    
    
    process (LIGA)
    begin
        DTR <= not LIGA;
    end process;

    process (MORSE, CLK, RESET, LIGA, COUNTER)
    begin
        if (LIGA = '0') then
            state <= t0;
            ESTADO_DEPURACAO <= "000";
        elsif (RESET = '1') then
            state <= t0;
            ESTADO_DEPURACAO <= "000";
        else
            if (CLK'event and CLK='1') then
                case state is
                    when t0 =>
                        state <= t1;
                        ESTADO_DEPURACAO <= "001";
                    when t1 =>
                        if (COUNTER = '1') then
                            counter_contador <= '1';
                            if ((MORSE /= last_MORSE) and (MORSE = '1')) then
                                state <= t2;
                                ESTADO_DEPURACAO <= "010";
							    input_detected <= '1';
                                counter_contador <= '0';
                            end if;
                            last_MORSE <= MORSE;
                        elsif (MORSE = last_MORSE and input_detected = '1' and counter_contador = '1') then
                            state <= t5;
                            ESTADO_DEPURACAO <= "101";
                        end if;
                    when t2 =>
                        if (COUNTER = '0') then
                            if (MORSE = '0') then
                                state <= t3;
                                ESTADO_DEPURACAO <= "011";
                            else
                                state <= t4;
                                ESTADO_DEPURACAO <= "100";
                            end if;
                        end if;
                    when t3 =>
                        state <= t1;
                        ESTADO_DEPURACAO <= "001";
                    when t4 =>
                        state <= t1;
                        ESTADO_DEPURACAO <= "001";
                    when t5 =>
                        if (CTS = '0') then
                            state <= t6;
                            ESTADO_DEPURACAO <= "110";
                        end if;
                    when t6 =>
                        if (PRONTOTRANSMISSAO = '1') then
                            state <= t1;
                            ESTADO_DEPURACAO <= "001";
                            input_detected <= '0';
                        end if;
                end case;
            end if;
        end if;
    end process;

    process (state) begin
        case state is
            when t0 =>
                RTS <= '1';
                carregaPonto <= '0';
                carregaTraco <= '0';
                carregaFim <= '0';
                PARTIDA <= '0';
            when t1 =>
                RTS <= '1';
                carregaPonto <= '0';
                carregaTraco <= '0';
                carregaFim <= '0';
                PARTIDA <= '0';
            when t2 =>
                RTS <= '1';
                carregaPonto <= '0';
                carregaTraco <= '0';
                carregaFim <= '0';
                PARTIDA <= '0';
            when t3 =>
                RTS <= '1';
                carregaPonto <= '1';
                carregaTraco <= '0';
                carregaFim <= '0';
                PARTIDA <= '0';
            when t4 =>
                RTS <= '1';
                carregaPonto <= '0';
                carregaTraco <= '1';
                carregaFim <= '0';
                PARTIDA <= '0';
            when t5 =>
                RTS <= '0';
                carregaPonto <= '0';
                carregaTraco <= '0';
                carregaFim <= '1';
                PARTIDA <= '0';
            when t6 =>
                RTS <= '0';
                carregaPonto <= '0';
                carregaTraco <= '0';
                carregaFim <= '0';
                PARTIDA <= '1';
        end case;
    end process;

end architecture;