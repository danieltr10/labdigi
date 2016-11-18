library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity RecepcaoSerial is
    port (
        CLK : in  std_logic;
        LIGA : in  std_logic;
        RESET : in  std_logic;
        ENTRADASERIAL : in std_logic;

		MORSE_DEPURACAO : out std_logic_vector(11 downto 0);
        RIGHT_HEX_DISPLAY : out std_logic_vector(6 downto 0);
        LEFT_HEX_DISPLAY : out std_logic_vector(6 downto 0);
        estadoDepuracao : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of RecepcaoSerial is

    component registradorRecepcao is
        port(   clk : in  std_logic;
                reset : in  std_logic;
                registraPonto : in std_logic;
                registraTraco : in std_logic;

                dados : out std_logic_vector(11 downto 0)
        );
    end component;

    component contadorRecepcao is
        port(   clk: in  std_logic;
                conta4: in std_logic;
                conta3 : in std_logic;
                reset: in  std_logic;
        
                fimConta4 : out std_logic;
                fimConta3 : out std_logic
        );
    end component;

    component unidadeControleRecepcao is
        port(   clk: in  std_logic;
                bitSerial : in std_logic;
                liga : in std_logic;
                fimConta4 : in std_logic;
                fimConta3 : in std_logic;
                reset: in  std_logic;
        
                mostraDadoDisplay : out std_logic;
                conta4 : out std_logic;
                conta3 : out std_logic;
                registraPonto : out std_logic;
                registraTraco : out std_logic;
                zera : out std_logic;
                estadoDepuracao : out std_logic_vector(2 downto 0)
        );
    end component;

    component morseTo7Seg is
        port(   valor : in std_logic_vector(11 downto 0);
                blank : in std_logic;
                mostraDadoDisplay : in std_logic;

                rightHex : out std_logic_vector(6 downto 0);
                leftHex : out std_logic_vector(6 downto 0)
        );
    end component;


    signal FIM_CONTA4 : std_logic;
    signal FIM_CONTA3 : std_logic;
    signal CONTAR_4 : std_logic;
    signal CONTAR_3 : std_logic;
    signal MOSTRA_DADO_DISPLAY : std_logic;
    signal REGISTRA_PONTO : std_logic;
    signal REGISTRA_TRACO : std_logic;
    signal DADOS_MORSE : std_logic_vector(11 downto 0);
    signal ZERA : std_logic;
    
begin

	MORSE_DEPURACAO <= DADOS_MORSE;
	
    UC : unidadeControleRecepcao port map (clk => CLK,
                                           bitSerial => ENTRADASERIAL,
                                           liga => LIGA,
                                           fimConta4 => FIM_CONTA4,
                                           fimConta3 => FIM_CONTA3,
                                           reset => RESET,
                                           
                                           mostraDadoDisplay => MOSTRA_DADO_DISPLAY,
                                           conta4 => CONTAR_4,
                                           conta3 => CONTAR_3,
                                           registraPonto => REGISTRA_PONTO,
                                           registraTraco => REGISTRA_TRACO,
                                           zera => ZERA,
                                           estadoDepuracao => estadoDepuracao
    );


    Contador : contadorRecepcao port map (clk => CLK,
                                          conta4 => CONTAR_4,
                                          conta3 => CONTAR_3,
                                          reset => ZERA,

                                          fimConta4 => FIM_CONTA4,
                                          fimConta3 => FIM_CONTA3
    );

    Registrador : registradorRecepcao port map(clk => CLK,
											   reset => RESET,
                                               registraPonto => REGISTRA_PONTO,
                                               registraTraco => REGISTRA_TRACO,
                                               
                                               dados => DADOS_MORSE
    );

    Conversor : morseTo7Seg port map(valor => DADOS_MORSE,
									 blank => RESET,
                                     mostraDadoDisplay => MOSTRA_DADO_DISPLAY,
                                     
                                     rightHex => RIGHT_HEX_DISPLAY,        
                                     leftHex => LEFT_HEX_DISPLAY
    );

end architecture;