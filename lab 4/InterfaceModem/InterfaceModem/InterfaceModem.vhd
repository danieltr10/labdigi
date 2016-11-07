library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity InterfaceModem is
    port (
        CLK : in  std_logic;
		  CLKSignalTap : in std_logic;
        RESET : in  std_logic;
        LIGA : in std_logic;
        DADOS : in std_logic_vector(7 downto 0);
        ENVIAR : in std_logic;
        CD : in std_logic;
        CTS : in std_logic;
        RD : in std_logic;
        
        RECEBIDO : out std_logic;
        DADOSRECEBIDO : out std_logic_vector(9 downto 0);
        WORD0REC : out std_logic_vector(6 downto 0);
        WORD1REC : out std_logic_vector(6 downto 0);
        WORD0TRANS : out std_logic_vector(6 downto 0);
        WORD1TRANS : out std_logic_vector(6 downto 0);
        TD : out std_logic;
        RTS : out std_logic;   
        PARTIDA_DEPURACAO : out std_logic; 
        SERIAL_DEPURACAO : out std_logic;   
        ESTADO_UC_TRANSMISSAO : out std_logic_VECTOR(1 DOWNTO 0);  
			ESTADO_DEPURACAO : OUT STD_logic_VECTOR(1 DOWNTO 0);
        DTR : out std_logic;
		  clockDep : out std_logic
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
             enableRecepcao : out std_logic;
				 estado_depuracao : out std_logic_VECTOR(1 downto 0)
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
    
    component HexTo7Seg is
        Port ( valor : in std_logic_vector(3 downto 0);
        blank : in std_logic;
        test : in std_logic;
        segs : out std_logic_vector(6 downto 0));
    end component;
    
    signal IPARTIDA : std_logic;
    signal prontoT : std_logic;
    signal clockT: std_logic;
    signal enableR : std_logic;
    SIGNAL IDADOS : STD_LOGIC;
    signal IDADOSREC : std_logic_vector(9 downto 0);

begin
		
	PARTIDA_DEPURACAO <= IPARTIDA;
	SERIAL_DEPURACAO <= IDADOS;
	TD <= IDADOS;
	
	process (CLK, IDADOSREC)
	begin
		if (enableR = '1') then
			DADOSRECEBIDO <= IDADOSREC;
		end if;
	end process;
	
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
                                            enableRecepcao => enableR,
														  estado_depuracao => ESTADO_DEPURACAO
                                            
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
                                        reset => RESET,
                                        entradaSerial => RD,
                                        
                                        dados => IDADOSREC,
                                        pronto => RECEBIDO
    );
    
    ClockTransmissao : ClockDivider port map (clkin => CLK,
                                              clkout => clockT
    );
	 
	 clockDep <= clockT;
    
    Word0Recepcao : HexTo7Seg port map(valor => IDADOSREC(1) & IDADOSREC(2) & IDADOSREC(3) & IDADOSREC(4),
        blank => '0',
        test => '0',
        segs => WORD0REC
    );

    Word1Recepcao : HexTo7Seg port map(valor => IDADOSREC(5) & IDADOSREC(6) & IDADOSREC(7) & IDADOSREC(8),
        blank => '0',
        test => '0',
        segs => WORD1REC
    );

    Word0Transmissao : HexTo7Seg port map(valor => DADOS(7 downto 4),
        blank => '0',
        test => '0',
        segs => WORD0TRANS
    );

    Word1Transmissao : HexTo7Seg port map(valor => DADOS(3 downto 0),
        blank => '0',
        test => '0',
        segs => WORD1TRANS
    );
end architecture;