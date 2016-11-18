library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
entity Registrador is
    port (
        clk : in STD_LOGIC;
        desloca : in STD_LOGIC;
        registraponto : in STD_LOGIC; -- data in
        registratraco : in std_logic;
        registrafim : in std_logic;
        
        serial : out STD_LOGIC -- data
    );
end Registrador;

architecture estrutural of Registrador is
    signal ISERIAL : STD_LOGIC_VECTOR (55 downto 0);

begin
    process (clk, ISERIAL, desloca, registratraco, registraponto)
    begin
        if (clk'event and clk='1') then
            if (registraponto = '1') then
                ISERIAL <= ISERIAL(55 downto 8) & "00001111";
                serial <= '1';
            elsif (registratraco = '1') then
                ISERIAL <= ISERIAL(55 downto 12) & "000000001111";
                serial <= '1';
            elsif (registrafim = '1') then
                ISERIAL <= ISERIAL(55 downto 4) & "1111";
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

