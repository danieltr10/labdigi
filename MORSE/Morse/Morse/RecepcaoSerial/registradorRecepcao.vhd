library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity registradorRecepcao is
    port (
        clk : in  std_logic;
        reset : in  std_logic;
        registraPonto : in std_logic;
        registraTraco : in std_logic;

        dados : out std_logic_vector(11 downto 0)
    );
end entity;

architecture rtl of registradorRecepcao is
    signal REGISTRADOR : std_logic_vector(11 downto 0);
begin
    process (clk, REGISTRADOR, registraPonto, registraTraco)
    begin
        if (reset = '1') then
            dados <= "111111111111";
            REGISTRADOR <= "111111111111";
        elsif (clk'event and clk='1') then
            if (registraPonto = '1') then
                dados <= "00" & REGISTRADOR(11 downto 2);
                REGISTRADOR <= "00" & REGISTRADOR(11 downto 2);
            elsif (registraTraco = '1') then
                dados <= "01" & REGISTRADOR(11 downto 2);
                REGISTRADOR <= "01" & REGISTRADOR(11 downto 2);
            end if;     
        end if;
    end process;
    
end architecture;