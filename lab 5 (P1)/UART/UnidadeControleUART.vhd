library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UnidadeControleUART is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        
        -- Transmissao
        PRONTO_TRANSMISSAO : in std_logic;
        TRANSMITE_DADO : in std_logic;
        TRANSM_ANDAMENTO : out std_logic;
        PARTIDA : out std_logic
        
    );
end entity;

architecture rtl of UnidadeControleUART is
    type estado_transmissao is (t0, t1); 
    signal estadoTransmissao : estado_transmissao := t0;
    
    signal partida_aux : std_logic;
    signal borderPartida : std_logic;

begin
    process (CLK, TRANSMITE_DADO)
    begin
        borderPartida <= TRANSMITE_DADO and (not partida_aux);
        if (CLK'event and CLK = '1') then
            partida_aux <= TRANSMITE_DADO;
        end if;
    end process;
    
    process (CLK, RESET, PRONTO_TRANSMISSAO, estadoTransmissao)
    begin
        if (RESET = '1') then
            estadoTransmissao <= t0;
        else
            if (CLK'event and CLK='1') then
                case estadoTransmissao is
                    when t0 =>
                        if (borderPartida = '1') then
                            estadoTransmissao <= t1;
                        end if;
                    when t1 =>
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
				TRANSM_ANDAMENTO <= '0';
                PARTIDA <= '0';
            when t1 =>
				TRANSM_ANDAMENTO <= '1';
                PARTIDA <= '1';
        end case;
    end process;
    
end architecture;