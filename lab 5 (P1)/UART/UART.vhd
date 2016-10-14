library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UART is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        LIGA : in std_logic;
        DADOS : in std_logic_vector(7 downto 0);
        ENVIAR : in std_logic;
        CD : in std_logic;
        CTS : in std_logic;
        RD : in std_logic;
        
        RECEBIDO : out std_logic;
        DADOSRECEBIDO : out std_logic_vector(9 downto 0);
        LEDCD : out std_logic;
        LEDCTS : out std_logic;
        TD : out std_logic;
        RTS : out std_logic;   
        PARTIDA_DEPURACAO : out std_logic; 
        SERIAL_DEPURACAO : out std_logic;   
        ESTADO_UC_TRANSMISSAO : out std_logic_VECTOR(1 DOWNTO 0);   
        DTR : out std_logic
    );
end entity;



architecture rtl of UART is
    
    component ClockDivider is
        port(clkin : in std_logic;
             clkout : out std_logic
        );
    end component;
    
    component UnidadeControleUART is
    port(    clk : in  std_logic;
             reset : in  std_logic;
             liga : in std_logic;
             enviar : in std_logic;
             cd : in std_logic;
             cts : in std_logic;
             prontoTransmissao : in std_logic;
             
             dtr : out std_logic;
             rts : out std_logic;
             partida : out std_logic;
             enableRecepcao : out std_logic
    );
    end component;
    
    component TransmissaoSerial is
        port(   clk : in std_logic;
                reset : in std_logic;
                dados : in std_logic_vector(7 downto 0);
                partida : in std_logic;
                
                dadosSerial : out std_logic;
                ESTADO_UC : out std_logic_vector(1 downto 0);
                pronto : out std_logic
        );
    end component;
    
    component RecepcaoSerial is
        port(   clk : in std_logic;
                reset : in std_logic;
                entradaSerial : in std_logic;
                
                dados : out std_logic_vector(9 downto 0);
                pronto : out std_logic
        );
    end component;
    
    signal IPARTIDA : std_logic;
    signal prontoT : std_logic;
    signal clockT: std_logic;
    signal enableR : std_logic;
    SIGNAL IDADOS : STD_LOGIC;
begin
    
	PARTIDA_DEPURACAO <= IPARTIDA;
	SERIAL_DEPURACAO <= IDADOS;
	TD <= IDADOS;
	
    UC : UnidadeControleUART port map (clk => CLK,
                                            reset => RESET,
                                            liga => LIGA,
                                            enviar => ENVIAR,
                                            cd => CD,
                                            cts => CTS,
                                            prontoTransmissao => prontoT,
                                            
                                            dtr => DTR,
                                            rts => RTS,
                                            partida => IPARTIDA,
                                            enableRecepcao => enableR
                                            
    );    
    
    Transmissor : TransmissaoSerial port map (clk => clockT,
                                              reset => RESET,
                                              dados => DADOS,
                                              partida => IPARTIDA,
                                          
                                              dadosSerial => IDADOS,
                                              ESTADO_UC => ESTADO_UC_TRANSMISSAO,
                                              pronto => prontoT
    );
    
    Receptor : RecepcaoSerial port map (clk => CLK,
                                        reset => RESET or (not enableR),
                                        entradaSerial => RD,
                                        
                                        dados => DADOSRECEBIDO,
                                        pronto => RECEBIDO
    );
    
    ClockTransmissao : ClockDivider port map (clkin => CLK,
                                              clkout => clockT
    );
end architecture;