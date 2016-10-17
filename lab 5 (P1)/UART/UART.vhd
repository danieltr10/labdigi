library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UART is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        CLK300Hz : out std_logic;

        -- Transmissao IN
        
        DADOS_TRANS : in std_logic_vector(7 downto 0);
        TRANSMITE_DADO : in std_logic;

        -- Recepcao IN
        
        ENTRADA : in std_logic;
        RECEBE_DADO : in std_logic;

        -- Transmissao OUT
        
        TRANSM_ANDAMENTO : out std_logic;
        SAIDA : out std_logic;
        WORD0TRANS : out std_logic_vector(6 downto 0);
        WORD1TRANS : out std_logic_vector(6 downto 0);
        
        -- Recepcao OUT
        
        TEM_DADO_REC : out std_logic;
        DADO_REC : out std_logic_vector(10 downto 0);
        WORD0REC: out std_logic_vector(6 downto 0);
        WORD1REC: out std_logic_vector(6 downto 0);


        estadoDepuracao : out std_logic_vector(2 downto 0)
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
        pronto : out std_logic;
        temDado : out std_logic;
        estadoDepuracao : out std_logic_vector(2 downto 0)
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

        -- Transmissao
        pronto_transmissao : in std_logic;
        transmite_dado : in std_logic;

        transm_andamento : out std_logic;
        partida : out std_logic
        );
    end component;
    
    component HexTo7Seg is
        Port ( valor : in std_logic_vector(3 downto 0);
        blank : in std_logic;
        test : in std_logic;
        segs : out std_logic_vector(6 downto 0));
    end component;
    
    signal dadoRec : std_logic_vector(10 downto 0);
    signal dado7SegRec : std_logic_vector(10 downto 0);
    signal prontoTransmissao : std_logic;
    signal prontoRecepcao : std_logic;
    signal partidaUART : std_logic;
    signal temDadoRec : std_logic;
    signal partida : std_logic;
    signal tickTX : std_logic;
    signal tickRX : std_logic;
begin
    
    CLK300Hz <= tickTX;

    UC : UnidadeControleUART port map(clk => CLK,
		                              reset => RESET,

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
        recebeDado => RECEBE_DADO,

        dados => dadoRec,
        pronto => prontoRecepcao,
        temDado => TEM_DADO_REC,
        estadoDepuracao => estadoDepuracao
    );


    Transmissao : TransmissaoSerial port map(clk => tickTX,
        reset => RESET,
        dados => DADOS_TRANS,
        partida => partidaUART,
        
        dadosserial => SAIDA,
        pronto => prontoTransmissao
    );
    
    Word0Recepcao : HexTo7Seg port map(valor => dado7SegRec(1) & dado7SegRec(2) & dado7SegRec(3) & dado7SegRec(4),
                                       blank => '0',
                                       test => '0',
                                       segs => WORD0REC
    );
    
    Word1Recepcao : HexTo7Seg port map(valor => dado7SegRec(5) & dado7SegRec(6) & dado7SegRec(7) & dado7SegRec(8),
        blank => '0',
        test => '0',
        segs => WORD1REC
    );
    
    Word0Transmissao : HexTo7Seg port map(valor => DADOS_TRANS(7 downto 4),
        blank => '0',
        test => '0',
        segs => WORD0TRANS
    );
    
    Word1Transmissao : HexTo7Seg port map(valor => DADOS_TRANS(3 downto 0),
        blank => '0',
        test => '0',
        segs => WORD1TRANS
    );

    process (prontoRecepcao)
    begin
        if (prontoRecepcao = '1') then
            DADO_REC <= dadoRec;
            dado7SegRec <= dadoRec;
        end if;
    end process;
    
end architecture;