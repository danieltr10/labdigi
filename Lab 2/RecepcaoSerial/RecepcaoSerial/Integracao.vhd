library IEEE;
    use IEEE.STD_LOGIC_1164.all;
    use IEEE.numeric_std.all;

entity Integracao is
    port (
        CLK : in  STD_LOGIC;
        RESET : in  STD_LOGIC;
        SERIAL_IN : in STD_LOGIC;
        
        DADOS : out STD_LOGIC_VECTOR(10 downto 0);
        PARIDADE_OK : out STD_LOGIC;
        PRONTO : out STD_LOGIC;
        DADOS_7SEG_1 : out STD_LOGIC_VECTOR(6 downto 0);
        DADOS_7SEG_2 : out STD_LOGIC_VECTOR(6 downto 0);
        ESTADO_DEPURACAO : out STD_LOGIC_VECTOR(2 downto 0);
        CONTAGEM_DEPURACAO : out STD_LOGIC_VECTOR(3 downto 0)
    );
end entity;

architecture rtl of Integracao is
    
    component registrador is
        port(   clk : in STD_LOGIC;
                registra : in STD_LOGIC;
                serial : in STD_LOGIC;

                paridade : out STD_LOGIC;
                dados : out STD_LOGIC_VECTOR(10 downto 0)
        );
    end component;
    
    component contador is
        port(   clk : in STD_LOGIC;
                conta : in STD_LOGIC;
                reset : in STD_LOGIC;
                
                contagem : out STD_LOGIC_VECTOR(3 downto 0);
                fim : out STD_LOGIC;
                conta4 : out STD_LOGIC;
                conta8 : out STD_LOGIC
        );
    end component;
    
    component unidade_controle is
        port(   clk : in STD_LOGIC;
                serial_start_bit : in STD_LOGIC;
                pronto_conta_4 : in STD_LOGIC;
                pronto_conta_8 : in STD_LOGIC;
                fim : in STD_LOGIC;
                reset : in STD_LOGIC;
                
                pronto : out STD_LOGIC;
                registra : out STD_LOGIC;
                conta : out STD_LOGIC;
                zera : out STD_LOGIC;
                estado_depuracao : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;
    
    component hexto7seg is
        port(   valor : in STD_LOGIC_VECTOR(3 downto 0);
                blank : in STD_LOGIC;
                test : in STD_LOGIC;
                segs : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    signal CONTA_4 : STD_LOGIC;
    signal CONTA_8 : STD_LOGIC;
    signal FIM : STD_LOGIC;
    signal CONTA_UC : STD_LOGIC;
    signal REGISTRA : STD_LOGIC;
    signal ZERA : STD_LOGIC;
    signal DADOS_HEX : STD_LOGIC_VECTOR(10 downto 0);
begin
    
    UC : unidade_controle port map (clk => CLK, 
                                   serial_start_bit => SERIAL_IN, 
                                   pronto_conta_4 => CONTA_4, 
                                   pronto_conta_8 => CONTA_8, 
                                   fim => FIM,
                                   reset => RESET,
                                   
                                   pronto => PRONTO,
                                   conta => CONTA_UC,
                                   registra => REGISTRA,
                                   zera => ZERA,
                                   estado_depuracao => ESTADO_DEPURACAO
    );
    
    ModContador : contador port map (clk => CLK, 
                                     conta => CONTA_UC, 
                                     reset => ZERA,
                                     
                                     contagem => CONTAGEM_DEPURACAO,
                                     fim => FIM,
                                     conta4 => CONTA_4,
                                     conta8 => CONTA_8
    );
    
    ModRegistrador : registrador port map(clk => CLK,
                                          registra => REGISTRA,
                                          serial => SERIAL_IN,
                                          
                                          paridade => PARIDADE_OK,
                                          dados => DADOS_HEX
    );
    
    DADOS <= DADOS_HEX;
    
    Mod1stWord : hexto7seg port map(valor => DADOS_HEX(4 downto 1),
                                    blank => '0',
                                    test => '0',
                                    segs => DADOS_7SEG_1
    );
    
    Mod2ndWord : hexto7seg port map(valor => '0' & DADOS_HEX(7 downto 5),
                                    blank => '0',
                                    test => '0',
                                    segs => DADOS_7SEG_2
    );
end architecture;