library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity Morse is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        MORSE : in std_logic;
        LIGA : in std_logic;
        
        --Modem Signals
        DTR : out std_logic;
        --Recepcao
        CD : in std_logic;
        RD : in std_logic;
        --Transmissao
        CTS : in std_logic;
        RTS : out std_logic;
        TD : out std_logic;        
        
        COUNTER : in std_logic;
        RIGHT_HEX : out std_logic_vector(6 downto 0);
        LEFT_HEX : out std_logic_vector(6 downto 0);
        
        ESTADO_TRANSMISSAO : out std_logic_vector(2 downto 0);
        PARTIDA_DEPURACAO : out std_logic;
        REGISTRADOR_TRANSMISSAO : out std_logic_vector(55 downto 0)
    );
end entity;

architecture rtl of Morse is
    
    component contador_tick is
        port(
            clk50MHz, reset : in std_logic;
            tick880Hz : out std_logic;
            tick500mHz : out std_logic
        );
    end component;
    
    component tickDivider is
        port(
            tickin880Hz : in std_logic;
            tickout110Hz : out std_logic
        );
    end component;
    
    component RecepcaoSerial is
        port(
            clk : in std_logic;
            liga : in std_logic;
            reset : in std_logic;
            entradaSerial : in std_logic;
            
            MORSE_DEPURACAO : out std_logic_vector(11 downto 0);
            right_hex_display : out std_logic_vector(6 downto 0);
            left_hex_display : out std_logic_vector(6 downto 0);
            estadoDepuracao : out std_logic_vector(3 downto 0)
        );
    end component;
    
    component TransmissaoSerial is
        port(
            clk : in std_logic;
            reset : in std_logic;
            partida : in std_logic;
            carrega_ponto : in std_logic;
            carrega_traco : in std_logic;
            carrega_fim : in std_logic;
            
            dadosserial : out std_logic;
            estado_uc : out std_logic_vector(1 downto 0);
            pronto : out std_logic;
            registrador_depuracao : out std_logic_vector(55 downto 0)
        );
    end component;
    
    component UnidadeControleMorse is
        port(
            clk : in std_logic;
            morse : in std_logic;
            counter : in std_logic;
            reset : in std_logic;
            liga : in std_logic;
            prontotransmissao : in std_logic;
            
            --ModemSignals
            dtr : out std_logic;
            --Recepcao
            cd : in std_logic;
            --Transmissao
            cts : in std_logic;
            rts : out std_logic;
            
            carregaPonto : out std_logic;
            carregaTraco : out std_logic;
            carregaFim : out std_logic;
            partida : out std_logic;
            enableRecepcao : out std_logic;
            estado_depuracao : out std_logic_vector(2 downto 0)
        );
    end component;
    
    signal carrega_ponto_signal : std_logic;
    signal carrega_traco_signal : std_logic;
    signal carrega_fim_signal : std_logic;
    signal partida_signal : std_logic;
    signal pronto_transmissao : std_logic;
    signal ledCounter : std_logic;
    signal clock880Hz : std_logic;
    signal clock110Hz : std_logic;
    signal enableRecepcaoSignal : std_logic;
   
    
begin
    --COUNTER <= ledCounter;
    PARTIDA_DEPURACAO <= partida_signal;
    
    Controle: UnidadeControleMorse port map (
        clk => CLK,
        morse => MORSE,
        counter => ledCounter,
        reset => RESET,
        liga => LIGA,
        prontotransmissao => pronto_transmissao,
        
        --ModemSignals
        dtr => DTR,
        --Recepcao
        cd => CD,
        --Transmissao
        cts => CTS,
        rts => RTS,
        
        carregaPonto => carrega_ponto_signal,
        carregaTraco => carrega_traco_signal,
        carregaFim => carrega_fim_signal,
        partida => partida_signal,
        enableRecepcao => enableRecepcaoSignal,
        estado_depuracao => ESTADO_TRANSMISSAO
    );
    
    Transmissao: TransmissaoSerial port map (
        clk => clock110Hz,
        reset => RESET,
        partida => partida_signal,
        carrega_ponto => carrega_ponto_signal,
        carrega_traco => carrega_traco_signal,
        carrega_fim => carrega_fim_signal,
        
        dadosserial => TD,
        pronto => pronto_transmissao,
        registrador_depuracao => REGISTRADOR_TRANSMISSAO
    );
    
    Recepcao: RecepcaoSerial port map (
        clk => clock880Hz,
        liga => LIGA,
        reset => RESET,
        entradaSerial => RD,
        
        right_hex_display => RIGHT_HEX,
        left_hex_display => LEFT_HEX
    );
    
    TickGenerator: contador_tick port map (
        clk50MHz => CLK,
        reset => RESET,
        tick880Hz => clock880Hz,
        tick500mHz => ledCounter
    );
    
    ClockDivider: TickDivider port map (
        tickin880Hz => clock880Hz,
        tickout110Hz => clock110Hz
    );
    
end architecture;