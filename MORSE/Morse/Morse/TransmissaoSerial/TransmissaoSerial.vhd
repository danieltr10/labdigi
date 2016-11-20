library IEEE;
    use IEEE.Std_logic_1164.all;
    use IEEE.Std_logic_arith.all;
    use ieee.std_logic_unsigned.all;
    use work.all;

entity TransmissaoSerial is
    port(
        CLK : in std_logic;
        RESET : in std_logic;
        PARTIDA :  in std_logic;
        CARREGA_PONTO : in std_logic;
        CARREGA_TRACO : in std_logic;
        CARREGA_FIM : in std_logic;
        
        DADOSSERIAL : out std_logic;
        ESTADO_UC: out std_logic_vector(1 downto 0);
        PRONTO : out std_logic;
        REGISTRADOR_DEPURACAO : out std_logic_vector(55 downto 0)
    );
end TransmissaoSerial;

architecture estrutural of TransmissaoSerial is
    component unidade_controle is
        port(   clk      : IN   STD_LOGIC;
        partida  : IN   STD_LOGIC;
        fim      : IN STD_LOGIC;
        reset     : IN STD_LOGIC;

        conta   : OUT STD_LOGIC;
        desloca   : OUT STD_LOGIC;
        zera   : OUT STD_LOGIC;
        estado_atual : OUT STD_LOGIC_VECTOR(1 downto 0);
        pronto : OUT STD_LOGIC
        );
    end component;
    component contador is
        port( clk : in STD_LOGIC;
        conta : in STD_LOGIC;
        zera : in STD_LOGIC;

        fim : out STD_LOGIC
        --CONTAGEM_DEPURACAO : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    component Registrador is
        port(   clk : in STD_LOGIC;
        reset : in std_logic;
        desloca: in STD_LOGIC;
        registraponto : in STD_LOGIC;
        registratraco : in std_logic;
        registrafim : in std_logic;

        serial : out STD_LOGIC;
        registrador : out std_logic_vector(55 downto 0)
        );
    end component;
    signal fim_z :STD_LOGIC; 
    signal conta_z : STD_LOGIC;
    signal zera_z : STD_LOGIC;
    signal desloca_z : std_logic;

    

begin

    controle: unidade_controle port map (clk => CLK, 
        partida => PARTIDA, 
        fim => fim_z, 
        reset => RESET, 
        conta => conta_z, 
        desloca => desloca_z, 
        zera => zera_z, 
        estado_atual => ESTADO_UC, 
        pronto => PRONTO);
    mod_contador: contador port map (clk => CLK, 
        conta => conta_z, 
        zera => zera_z, 
        fim => fim_z);
    mod_reg: Registrador port map (clk => CLK, 
        reset => RESET,
        desloca => desloca_z, 
        registraponto => CARREGA_PONTO,
        registratraco => CARREGA_TRACO, 
        registrafim => CARREGA_FIM, 
        serial => DADOSSERIAL,
        registrador => REGISTRADOR_DEPURACAO
    );

end estrutural;