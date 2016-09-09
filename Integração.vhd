library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity circuito_completo is
	port(
		PARTIDA		: in std_logic;
		CLK		: in std_logic;
		RESET : in STD_LOGIC;
		DADOS_IN : in STD_LOGIC_VECTOR(6 downto 0);
		PRONTO	: out std_logic;
		CONTAGEM_DEPURACAO : out STD_LOGIC_VECTOR(3 downto 0);
		SERIAL_OUT : out std_logic;
		);
end circuito_completo;

architecture estrutural of circuito_completo is    
    component unidade_controle is		
    port(   clk      : IN   STD_LOGIC;
			partida  : IN   STD_LOGIC;
			fim      : IN STD_LOGIC;
			reset	 : IN STD_LOGIC;
			
			conta   : OUT STD_LOGIC;
			desloca   : OUT STD_LOGIC;
			zera   : OUT STD_LOGIC;
			registra   : OUT STD_LOGIC;
    );
    end component;
    	component contador is		
    port( clk : in STD_LOGIC;
		  conta : in STD_LOGIC;
		  zera : in STD_LOGIC;
		  
		  contagem : out STD_LOGIC_VECTOR(3 downto 0);
		  fim : out STD_LOGIC
		  --CONTAGEM_DEPURACAO : out STD_LOGIC_VECTOR(3 downto 0)
		  );
 end component;
    component Registrador is		
    port(   clk : IN   STD_LOGIC;
			desloca: in STD_LOGIC;
			registra : in STD_LOGIC;
			dados : in STD_LOGIC_VECTOR (6 downto 0); -- data in
			
			serial : out STD_LOGIC; -- data out
			);
    end component; 
    signal fim_z :STD_LOGIC;
	signal conta_z : STD_LOGIC;
	signal zera_z : STD_LOGIC;
	signal desloca_z : STD_LOGIC;
	signal registra_z : STD_LOGIC;
	
	begin
	
	controle: unidade_controle port map (clk => CLK, partida => PARTIDA, fim => fim_z, reset => RESET, conta => conta_z, desloca => desloca_z, zera => zera_z, registra => registra_z);
	mod_contador: contador port map (clk => CLK, conta => conta_z, zera => zera_z, contagem => CONTAGEM_DEPURACAO, fim => fim_z);
	mod_reg: Registrador port map (clk => CLK, desloca => desloca_z, registra => registra_z, dados => DADOS_IN, serial => SERIAL_OUT);
	
end estrutural;