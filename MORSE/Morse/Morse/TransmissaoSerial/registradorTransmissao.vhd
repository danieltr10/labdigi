library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
entity Registrador is
    port (
        clk : in STD_LOGIC;
        reset : in std_logic;
        desloca : in STD_LOGIC;
        registraPonto : in STD_LOGIC; -- data in
        registraTraco : in std_logic;
        registraFim : in std_logic;
        
        serial : out STD_LOGIC; -- data
        registrador : out std_logic_vector(55 downto 0)
    );
end Registrador;

architecture estrutural of Registrador is
    signal ISERIAL : STD_LOGIC_VECTOR (55 downto 0) := "11111111111111111111111111111111111111111111111111111111";
    signal registraFimAux : std_logic;
    signal registraFimBorder : std_logic;

begin
    process (clk, ISERIAL, desloca, registratraco, registraponto)
    begin
        if (clk'event and clk='1') then
            if (registraPonto = '1') then
                ISERIAL <= ISERIAL(47 downto 0) & "00001111";
                serial <= '1';
            elsif (registraTraco = '1') then
                ISERIAL <= ISERIAL(43 downto 0) & "000000001111";
                serial <= '1';
            elsif (registraFimBorder = '1') then
                ISERIAL <= ISERIAL(51 downto 0) & "1111";
                serial <= '1';
            elsif (desloca = '1') then
                serial <= ISERIAL(55);
                ISERIAL <= ISERIAL(54 downto 0) & '1';
            elsif (reset = '1') then
                ISERIAL <= "11111111111111111111111111111111111111111111111111111111";
                serial <= '1';
            else
                serial <= '1';
            end if;
        end if;
        registrador <= ISERIAL;
    end process;
    
    PROCESS (clk,registraFim)
    BEGIN
        if (clk='1' and clk'event) then
            registraFimAux <= registraFim;
        end if;
        registraFimBorder <= registraFim and (not registraFimAux);
    END PROCESS;
end estrutural;

