library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UnidadeControleMorse is
    port (
        TRACO: in  std_logic;
        PONTO: in  std_logic;
        ENVIAR: in std_logic;
        
        DTR : out std_logic;
        RTS: out std_logic
    );
end entity;

architecture rtl of UnidadeControleMorse is
begin
    process (
    end process;
end architecture;