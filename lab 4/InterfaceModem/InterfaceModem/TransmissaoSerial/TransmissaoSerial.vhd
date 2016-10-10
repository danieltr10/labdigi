library IEEE;
    use IEEE.Std_logic_1164.all;
    use IEEE.Std_logic_arith.all;
    use ieee.std_logic_unsigned.all;
    use work.all;

entity TransmissaoSerial is
    port(
        CLK : in std_logic;
        RESET : in std_logic;
        DADOS : in std_logic_vector(7 downto 0);
        PARTIDA :  in std_logic;
        
        DADOSSERIAL : out std_logic;
        PRONTO : out std_logic
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
        registra   : OUT STD_LOGIC;
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
        desloca: in STD_LOGIC;
        registra : in STD_LOGIC;
        dados : in STD_LOGIC_VECTOR (7 downto 0); -- data in

        serial : out STD_LOGIC
        );
    end component;
    signal fim_z :STD_LOGIC; 
    signal conta_z : STD_LOGIC;
    signal zera_z : STD_LOGIC;
    signal desloca_z : STD_LOGIC;
    signal registra_z : STD_LOGIC;

begin

    controle: unidade_controle port map (clk => CLK, partida => PARTIDA, fim => fim_z, reset => RESET, conta => conta_z, desloca => desloca_z, zera => zera_z, registra => registra_z, pronto => PRONTO);
    mod_contador: contador port map (clk => CLK, conta => conta_z, zera => zera_z, fim => fim_z);
    mod_reg: Registrador port map (clk => CLK, desloca => desloca_z, registra => registra_z, dados => DADOS, serial => DADOSSERIAL);

end estrutural;