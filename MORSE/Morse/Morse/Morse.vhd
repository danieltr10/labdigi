library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity Morse is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        MORSE : in std_logic;
        COUNTER : in std_logic;
        LIGA : in std_logic;
        
        SERIAL_OUT : out std_logic;
        ESTADO_TRANSMISSAO : out std_logic_vector(2 downto 0);
        PARTIDA_DEPURACAO : out std_logic;
        REGISTRADOR_TRANSMISSAO : out std_logic_vector(55 downto 0)
    );
end entity;

architecture rtl of Morse is
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
            
            carregaponto : out std_logic;
            carregatraco : out std_logic;
            carregafim : out std_logic;
            partida : out std_logic;
            DTR : out std_logic;
            RTS : out std_logic;
            estado_depuracao : out std_logic_vector(2 downto 0)
        );
    end component;
    
    signal carrega_ponto_signal : std_logic;
    signal carrega_traco_signal : std_logic;
    signal carrega_fim_signal : std_logic;
    signal partida_signal : std_logic;
    signal pronto_transmissao : std_logic;
    
begin
    PARTIDA_DEPURACAO <= partida_signal;
    
    Controle: UnidadeControleMorse port map (
        clk => CLK,
        morse => MORSE,
        counter => COUNTER,
        reset => RESET,
        liga => LIGA,
        prontotransmissao => pronto_transmissao,
        
        carregaponto => carrega_ponto_signal,
        carregatraco => carrega_traco_signal,
        carregafim => carrega_fim_signal,
        partida => partida_signal,
        estado_depuracao => ESTADO_TRANSMISSAO
    );
    
    Transmissao: TransmissaoSerial port map (
        clk => CLK,
        reset => RESET,
        partida => partida_signal,
        carrega_ponto => carrega_ponto_signal,
        carrega_traco => carrega_traco_signal,
        carrega_fim => carrega_fim_signal,
        
        dadosserial => SERIAL_OUT,
        pronto => pronto_transmissao,
        registrador_depuracao => REGISTRADOR_TRANSMISSAO
    );
    
end architecture;