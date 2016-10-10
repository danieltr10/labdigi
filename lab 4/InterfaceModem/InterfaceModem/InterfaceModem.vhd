library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity InterfaceModem is
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
        DTR : out std_logic
    );
end entity;



architecture rtl of InterfaceModem is
    
    component ClockDivider is
        port(clkin : in std_logic;
             clkout : out std_logic
        );
    end component;
    
    component UnidadeControleInterface is
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
begin
    
    UC : UnidadeControleInterface port map (clk => CLK,
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
                                              
                                              dadosSerial => TD,
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