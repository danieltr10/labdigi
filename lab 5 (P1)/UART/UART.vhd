library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UART is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;

        -- Transmissao IN
        
        DADOS_TRANS : in std_logic_vector(7 downto 0);
        TRANSMITE_DADO : in std_logic;

        -- Recepcao IN
        
        ENTRADA : in std_logic;
        RECEBE_DADO : in std_logic;

        -- Transmissao OUT
        
        TRANSM_ANDAMENTO : out std_logic;
        SAIDA : out std_logic;
        
        -- Recepcao OUT
        
        TEM_DADO_REC : out std_logic;
        DADO_REC : out std_logic_vector(10 downto 0)


    );
end entity;



architecture rtl of UART is

    component TransmissaoSerial is
        port(clk : in std_logic;
        reset : in std_logic;
        dados : in std_logic_vector(7 downto 0);
        partida :  in std_logic;

        dadosserial : out std_logic;
        estado_uc: out std_logic_vector(1 downto 0);
        pronto : out std_logic
        );
    end component;

    component RecepcaoSerial is
        port(clk : in  std_logic;
        reset : in  std_logic;
        entradaserial : in std_logic;
        recebeDado : in std_logic;

        dados : out std_logic_vector(10 downto 0);
        pronto : out std_logic
        );
    end component;

    component TickGenerator is
        port(clk : in std_logic;
        reset : in std_logic;

        tick_tx : out std_logic;
        tick_rx : out std_logic
        );
    end component;

    component UnidadeControleUART is
        port(clk : in  std_logic;
        reset : in  std_logic;

        -- Recepcao
        recebe_dado : in std_logic;
        pronto_recepcao : in std_logic;

        tem_dado_rec : out std_logic;
        recebe_dado_signal : out std_logic;

        -- Transmissao
        pronto_transmissao : in std_logic;
        transmite_dado : in std_logic;

        transm_andamento : out std_logic;
        partida : out std_logic
        );
    end component;
    
    signal dadoRec : std_logic_vector(10 downto 0);
    signal prontoTransmissao : std_logic;
    signal prontoRecepcao : std_logic;
    signal partidaUART : std_logic;
    signal temDadoRec : std_logic;
    signal recebeDadoSignal : std_logic;
    signal partida : std_logic;
    signal tickTX : std_logic;
    signal tickRX : std_logic;
begin

    UC : UnidadeControleUART port map(clk => CLK,
													reset => RESET,
        -- Recepcao

        recebe_dado => RECEBE_DADO,
        pronto_recepcao => prontoRecepcao,

        tem_dado_rec => TEM_DADO_REC,
        recebe_dado_signal => recebeDadoSignal,

        -- Transmissao
        pronto_transmissao => prontoTransmissao,
        transmite_dado => TRANSMITE_DADO,

        transm_andamento => TRANSM_ANDAMENTO,
        partida => partidaUART
    );

    Tick : TickGenerator port map(clk => CLK,
        reset => RESET,

        tick_TX => tickTX,
        tick_RX => tickRX
    );


    Recepcao : RecepcaoSerial port map(clk => tickRX,
        reset => RESET,
        entradaSerial => ENTRADA,
        recebeDado => recebeDadoSignal,

        dados => dadoRec,
        pronto => prontoRecepcao
    );


    Transmissao : TransmissaoSerial port map(clk => tickTX,
        reset => RESET,
        dados => DADOS_TRANS,
        partida => partidaUART,
        
        dadosserial => SAIDA,
        pronto => prontoTransmissao
    );

    process (prontoRecepcao)
    begin
        if (prontoRecepcao = '1') then
            DADO_REC <= dadoRec;
        end if;
    end process;
    
end architecture;