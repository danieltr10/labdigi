library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UART is
    port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        
        ENTRADA : in std_logic;
        
        DADOS_TRANS : in std_logic_vector(7 downto 0);
        TRANSMITE_DADO : in std_logic;
        RECEBE_DADO : in std_logic;
        
        SAIDA : out std_logic;
        
        TRANSM_ANDAMENTO : out std_logic;        
        TEM_DADO_REC : out std_logic;
        DADO_REC : out std_logic_vector(10 downto 0)
    );
end entity;



architecture rtl of UART is
    
   
    
begin
    
	
end architecture;