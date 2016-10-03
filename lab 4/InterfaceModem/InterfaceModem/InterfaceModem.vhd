library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity InterfaceModem is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        LIGA : in std_logic;
        DADOS : in std_logic;
        ENVIAR : in std_logic;
        CD : in std_logic;
        CTS : in std_logic;
        RD : in std_logic;
        
        RECEBIDO : out std_logic;
        DADOSRECEBIDO : out std_logic;
        LEDCD : out std_logic;
        LEDCTS : out std_logic;
        TD : out std_logic;
        RTS : out std_logic;
        DTR : out std_logic        
    );
end entity;



architecture rtl of InterfaceModem is
    
    component TransmissaoSerial is
        port(   clk : in std_logic;
                reset : in std_logic;
                dados : in std_logic;
                partida : in std_logic;
                
                dadosSerial : out std_logic;
                pronto : out std_logic
        );
    end component;
    
    component RecepcaoSerial is
        port(   clk : in std_logic;
                reset : in std_logic;
                entradaSerial : in std_logic;
                
                dados : out std_logic;
                pronto : out std_logic
        );
    end component;
begin
    
    Transmissor : TransmissaoSerial port map (clk => CLK,
                                              reset => RESET,
                                              dados => DADOS,
                                              partida => ENVIAR,
                                              dadosSerial => TD,
                                              pronto => RTS
    );
    
    Receptor : RecepcaoSerial port map (clk => CLK,
                                        reset => RESET,
                                        entradaSerial => RD,
                                        
                                        dados => DADOSRECEBIDO,
                                        pronto => RECEBIDO
    );
end architecture;