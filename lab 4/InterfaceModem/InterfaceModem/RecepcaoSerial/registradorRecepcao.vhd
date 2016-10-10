library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity registradorRecepcao is
    port (
        clk : in  std_logic;
        reset : in  std_logic;
        registra : in std_logic;
        serial : in std_logic;

        dados : out std_logic_vector(9 downto 0)
    );
end entity;

architecture rtl of registradorRecepcao is
    signal REGISTRADOR : std_logic_vector(9 downto 0);
begin
    process (clk, REGISTRADOR, registra)
    begin
        if (reset = '1') then
            dados <= "0000000000";
            REGISTRADOR <= "0000000000";
        elsif (clk'event and clk='1') then
            if (registra = '1') then
                dados <= serial & REGISTRADOR(9 downto 1);
                REGISTRADOR <= serial & REGISTRADOR(9 downto 1);
            end if;     
        end if;
    end process;
    
end architecture;