library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
entity Registrador is
    port (
        clk : in STD_LOGIC;
        desloca : in STD_LOGIC;
        registra : in STD_LOGIC;
        dados : in STD_LOGIC; -- data in
        
        serial : out STD_LOGIC -- data
    );
end Registrador;

architecture estrutural of Registrador is
    signal ISERIAL : STD_LOGIC_VECTOR (55 downto 0);

begin
    process (clk, ISERIAL, desloca, registra)
    begin
        if (clk'event and clk='1') then
            if (registra = '1') then
                ISERIAL <= ISERIAL(55 downto 1) & dados;
                serial <= '1';
            elsif (desloca = '1') then
                serial <= ISERIAL(55);
                ISERIAL <= ISERIAL(54 downto 0) & '1';
            else
                serial <= '1';
            end if;
        end if;
    end process;
end estrutural;

