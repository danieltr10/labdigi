library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity RecepcaoSerial is
    port (
        CLK : in  std_logic;
        LIGA : in  std_logic;
        RESET : in  std_logic;
        ENTRADASERIAL : in std_logic;

        DADOS : out std_logic_vector(11 downto 0);
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
        port(   valor : in std_logic_vector(3 downto 0);
                blank : in std_logic;

                rightHex : out std_logic_vector(6 downto 0);
                leftHex : out std_logic_vector(6 downto 0)
        );
    end component;

    signal CONTA4 : std_logic;
    signal CONTA3 : std_logic;
    signal CONTA_UC : std_logic;
    signal REGISTRA : std_logic;
    signal ZERA : std_logic;
begin

  clk: in  std_logic;
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

    UC : unidadeControleRecepcao port map (clk => CLK,
                                           bitSerial => ENTRADASERIAL,
                                           liga => LIGA,
                                           fimConta4 => CONTA4,
                                           fimConta3 => CONTA8,
                                           fim => FIM,
                                           reset => RESET,
                                           recebeDado => RECEBEDADO,
                                           
                                           pronto => PRONTO,
                                           conta => CONTA_UC,
                                           registra => REGISTRA,
                                           zera => ZERA,
                                           temDado => TEMDADO,
                                           estadoDepuracao => estadoDepuracao
    );

    Contador : contadorRecepcao port map (clk => CLK,
                                          conta => CONTA_UC,
                                          reset => ZERA,

                                          fim => FIM,
                                          conta4 => CONTA4,
                                          conta8 => CONTA8
    );

    Registrador : registradorRecepcao port map(clk => CLK,
															  reset => RESET,
                                               registra => REGISTRA,
                                               serial => ENTRADASERIAL,
                                               
                                               dados => DADOS
    );

end architecture;