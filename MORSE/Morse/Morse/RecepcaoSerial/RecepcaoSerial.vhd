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
        estadoDepuracao : out std_logic_vector(3 downto 0)
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
				conta35 : in std_logic;
				conta32 : in std_logic;
				reset: in  std_logic;
        
				fimConta35 : out std_logic;
				fimConta32 : out std_logic
        );
    end component;

    component unidadeControleRecepcao is
        port(   clk: in  std_logic;
                bitSerial : in std_logic;
                liga : in std_logic;
                fimConta35 : in std_logic;
                fimConta32 : in std_logic;
                reset: in  std_logic;
        
                mostraDadoDisplay : out std_logic;
                conta35 : out std_logic;
                conta32 : out std_logic;
                registraPonto : out std_logic;
                registraTraco : out std_logic;
                zera : out std_logic;
                estadoDepuracao : out std_logic_vector(3 downto 0)
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

    signal FIM_CONTA35 : std_logic;
    signal CONTAR_35 : std_logic;
    signal FIM_CONTA32 : std_logic;
    signal CONTAR_32 : std_logic;
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
                                           fimConta35 => FIM_CONTA35,
                                           fimConta32 => FIM_CONTA32,
                                           reset => RESET,
                                           
                                           mostraDadoDisplay => MOSTRA_DADO_DISPLAY,
                                           conta35 => CONTAR_35,
                                           conta32 => CONTAR_32,
                                           registraPonto => REGISTRA_PONTO,
                                           registraTraco => REGISTRA_TRACO,
                                           zera => ZERA,
                                           estadoDepuracao => estadoDepuracao
    );


    Contador : contadorRecepcao port map (clk => CLK,
                                          conta35 => CONTAR_35,
                                          conta32 => CONTAR_32,
                                          reset => ZERA,

                                          fimConta35 => FIM_CONTA35,
                                          fimConta32 => FIM_CONTA32
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