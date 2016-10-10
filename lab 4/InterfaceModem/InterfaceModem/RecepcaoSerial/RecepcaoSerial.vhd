library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity RecepcaoSerial is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        ENTRADASERIAL : in std_logic;

        DADOS : out std_logic_vector(9 downto 0);
        PRONTO : out std_logic

    );
end entity;

architecture rtl of RecepcaoSerial is

    component registradorRecepcao is
        port(   clk : in std_logic;
                reset : in std_logic;
                registra : in std_logic;
                serial : in std_logic;

                dados : out std_logic_vector(9 downto 0)
        );
    end component;

    component contadorRecepcao is
        port(   clk : in std_logic;
                conta : in std_logic;
                reset : in std_logic;

                fim : out std_logic;
                conta4 : out std_logic;
                conta8 : out std_logic
        );
    end component;

    component unidadeControleRecepcao is
        port(   clk : in std_logic;
                serialStartBit : in std_logic;
                prontoConta4 : in std_logic;
                prontoConta8 : in std_logic;
                fim : in std_logic;
                reset : in std_logic;

                pronto : out std_logic;
                registra : out std_logic;
                conta : out std_logic;
                zera : out std_logic
        );
    end component;

    signal CONTA4 : std_logic;
    signal CONTA8 : std_logic;
    signal FIM : std_logic;
    signal CONTA_UC : std_logic;
    signal REGISTRA : std_logic;
    signal ZERA : std_logic;
begin

    UC : unidadeControleRecepcao port map (clk => CLK,
                                           serialStartBit=> ENTRADASERIAL,
                                           prontoConta4 => CONTA4,
                                           prontoConta8 => CONTA8,
                                           fim => FIM,
                                           reset => RESET,
                                           
                                           pronto => PRONTO,
                                           conta => CONTA_UC,
                                           registra => REGISTRA,
                                           zera => ZERA
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