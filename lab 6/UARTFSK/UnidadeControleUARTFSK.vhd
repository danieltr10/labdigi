library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UnidadeControleUART is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        RESETOUT : out std_logic;
        LIGA : in std_logic;
        
        -- Transmissao
        PRONTO_TRANSMISSAO : in std_logic;
        TRANSMITE_DADO : in std_logic;
        TRANSM_ANDAMENTO : out std_logic;
        PARTIDA : out std_logic;
        
        -- Recepcao
        ENABLE_RECEPCAO : out std_logic;
        
        -- Modem FSK
        CD : in std_logic;
        CTS : in std_logic;
        
        DTR : out std_logic;
        RTS : out std_logic
    );
end entity;

architecture rtl of UnidadeControleUART is
    type estado_transmissao is (t0, t1, t2); 
    signal estadoTransmissao : estado_transmissao := t0;
    
    type estado_recepcao is (r0, r1);
    signal estadoRecepcao : estado_recepcao := r0;
    
    signal partida_aux : std_logic;
    signal borderPartida : std_logic;

begin
    process (CLK, TRANSMITE_DADO)
    begin        borderPartida <= TRANSMITE_DADO and (not partida_aux);
        if (CLK'event and CLK = '1') then

            partida_aux <= TRANSMITE_DADO;
        end if;
    end process;
    
    process (CLK, RESET, PRONTO_TRANSMISSAO, estadoTransmissao)
    begin
        if (LIGA = '0') then
            estadoTransmissao <= t0;
            RESETOUT <= '0';
            DTR <= '1';
        elsif (RESET = '1') then
            estadoTransmissao <= t0;
            RESETOUT <= '0';
            DTR <= '1';
        else
            DTR <= '1';
            if (CLK'event and CLK='1') then
                case estadoTransmissao is
                    when t0 =>
                        if (borderPartida = '1') then
                            estadoTransmissao <= t1;
                        end if;
                    when t1 =>
                        if (CTS = '0') then
                            estadoTransmissao <= t2;
                        end if;
                    when t2 =>
                        if (PRONTO_TRANSMISSAO = '1') then
                            estadoTransmissao <= t0;
                        end if;
                end case;
            end if;
        end if;
    end process;
    
    process (estadoTransmissao)
    begin
        case estadoTransmissao is
            when t0 =>
                RTS <= '1';
				TRANSM_ANDAMENTO <= '0';
                PARTIDA <= '0';
            when t1 =>
                RTS <= '0';
				TRANSM_ANDAMENTO <= '0';
                PARTIDA <= '0';
            when t2 =>
                RTS <= '0';
                TRANSM_ANDAMENTO <= '1';
                PARTIDA <= '1';
        end case;
    end process;
    
    process (CLK, LIGA, RESET, CD)
    begin
        if (LIGA = '0') then
            estadoRecepcao <= r0;
        elsif (RESET = '1') then
            estadoRecepcao <= r0;
        else
            if (CLK'event and CLK='1') then
                case estadoRecepcao is
                    when r0 =>
                        if (CD = '1') then
                            estadoRecepcao <= r1;
                        end if;
                    when r1 =>
                        if (CD = '0') then
                            estadoRecepcao <= r0;
                        end if;
                end case;
            end if;
        end if;
    end process;
    
    process (estadoRecepcao)
    begin
        case estadoRecepcao is
            when r0 =>
                ENABLE_RECEPCAO <= '0';
            when r1 =>
                ENABLE_RECEPCAO <= '1';
        end case;
    end process;
    
end architecture;