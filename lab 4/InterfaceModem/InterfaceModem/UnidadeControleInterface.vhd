library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UnidadeControleInterface is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        LIGA : in std_logic;
        ENVIAR : in std_logic;
        CD : in std_logic;
        CTS : in std_logic;
        PRONTOTRANSMISSAO : in std_logic;

        DTR : out std_logic;
        RTS : out std_logic;
        PARTIDA : out std_logic;
        ENABLERECEPCAO : out std_logic;
		  ESTADO_DEPURACAO : out std_logic_vector(1 downto 0)
    );
end entity;

architecture rtl of UnidadeControleInterface is
    type estado_transmissao is (t0, t1, t2, t3);
    type estado_recepcao is (r0, r1, r2); 
    signal estadoTransmissao : estado_transmissao := t0;
    signal estadoRecepcao : estado_recepcao := r0;
    
    signal enviar_aux : std_logic;
    signal borderEnviar : std_logic;

begin
    process (CLK, ENVIAR)
    begin
        borderEnviar <= ENVIAR and (not enviar_aux);
        if (CLK'event and CLK = '1') then
            enviar_aux <= ENVIAR;
        end if;
    end process;
    
    process (LIGA) 
    begin
        DTR <= not LIGA;
    end process;
    
    process (CLK, LIGA, RESET, ENVIAR, PRONTOTRANSMISSAO, CTS, estadoTransmissao)
    begin
        if (LIGA = '0') then
            estadoTransmissao <= t0;
				ESTADO_DEPURACAO <= "00";
        elsif (RESET = '1') then
            estadoTransmissao <= t1;
				ESTADO_DEPURACAO <= "01";
        elsif (estadoTransmissao = t0) then
            estadoTransmissao <= t1;
				ESTADO_DEPURACAO <= "01";
        else
            if (CLK'event and CLK='1') then
                case estadoTransmissao is
            
                    when t0 =>
                    when t1 =>
                        if (borderEnviar = '1') then
                            estadoTransmissao <= t2;
									 ESTADO_DEPURACAO <= "10";
                        end if;
                    when t2 =>
                        if (CTS = '0') then
                            estadoTransmissao <= t3;
									 ESTADO_DEPURACAO <= "11";
                        end if;
                    when t3 =>
                        if (PRONTOTRANSMISSAO = '1') then
                            estadoTransmissao <= t1;
									 ESTADO_DEPURACAO <= "01";
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
                PARTIDA <= '0';
            when t1 =>
                RTS <= '1';
                PARTIDA <= '0';
            when t2 =>
                RTS <= '0';
                PARTIDA <= '0';
            when t3 =>
                RTS <= '0';
                PARTIDA <= '1';
        end case;
    end process;
    
    process (CLK, LIGA, RESET, CD)
    begin
        if (LIGA = '0') then
            estadoRecepcao <= r0;
        elsif (RESET = '1') then
            estadoRecepcao <= r1;
        elsif (estadoRecepcao = r0) then
            estadoRecepcao <= r1;
        else
            if (CLK'event and CLK='1') then
                case estadoRecepcao is
                    when r0 =>
                    when r1 =>
                        if (CD = '0') then
                            estadoRecepcao <= r2;
                        end if;
                    when r2 =>
                        if (CD = '1') then
                            estadoRecepcao <= r1;
                        end if;
                end case;
            end if;
        end if;
    end process;
    
    process (estadoRecepcao)
    begin
        case estadoRecepcao is
            when r0 =>
                ENABLERECEPCAO <= '0';
            when r1 =>
                ENABLERECEPCAO <= '0';
            when r2 =>
                ENABLERECEPCAO <= '1';
        end case;
    end process;
    
end architecture;