library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity circuito_completo is
	port(
		PARTIDA		: in std_logic;
		CLK		: in std_logic;
		RESET	: in std_logic;
		DADOS_IN : in STD_LOGIC_VECTOR(6 downto 0);
		PRONTO	: out std_logic;
		ESTADOS	 : OUT  STD_LOGIC_VECTOR(1 downto 0);
		cont_depuracao : out STD_LOGIC_VECTOR(3 downto 0);
		SERIAL_OUT : out std_logic;
		SERIAL_OUTC : out STD_LOGIC; -- data out
		SERIAL_LEDS : out STD_LOGIC_VECTOR(8 downto 0);
		out_partidaz : out STD_LOGIC
		);
end circuito_completo;

architecture estrutural of circuito_completo is    
    component unidade_controle is		
    port(   CLK      : IN   STD_LOGIC;
			partida  : IN   STD_LOGIC;
			reset    : IN   STD_LOGIC;
			fim      : IN STD_LOGIC;
			saida    : OUT  STD_LOGIC_VECTOR(1 downto 0);
			estados	 : OUT STD_LOGIC_VECTOR(1 downto 0);
			pronto   : OUT STD_LOGIC;
			partida_x: OUT STD_LOGIC
    );
    end component;
    	component contador is		
    port( CLK : in STD_LOGIC;
		  estado : in STD_LOGIC_VECTOR(1 downto 0);
		  CONTAGEM : out STD_LOGIC_VECTOR(3 downto 0);
		  FIM : out STD_LOGIC
		  --CONTAGEM_DEPURACAO : out STD_LOGIC_VECTOR(3 downto 0)
		  );
 end component;
    component Registrador is		
    port(   CLK      : IN   STD_LOGIC;
			estado	 : IN STD_LOGIC_VECTOR (1 downto 0);
			DADOS : in STD_LOGIC_VECTOR (6 downto 0); -- data in
			SERIAL : out STD_LOGIC; -- data out
			SERIAL_C : out STD_LOGIC; -- data out
			ISERIAL_D : out STD_LOGIC_VECTOR (8 downto 0)
			);
    end component; 
    signal fim_z :STD_LOGIC;
    signal saida_z: STD_LOGIC_VECTOR(1 downto 0);
	
	begin
	
	controle: unidade_controle port map (clk => CLK, partida=>PARTIDA, reset => RESET,fim=>fim_z, saida=>saida_z, estados=>ESTADOS, pronto=>PRONTO, partida_x=>out_partidaz);
	mod_contador: contador port map (clk => CLK,estado => saida_z, CONTAGEM=>cont_depuracao, FIM=>fim_z);
	mod_reg: Registrador port map (clk => CLK, estado => saida_z, DADOS => DADOS_IN, SERIAL => SERIAL_OUT,SERIAL_C=>SERIAL_OUTC, ISERIAL_D =>SERIAL_LEDS);
	
end estrutural;