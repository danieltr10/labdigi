library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
entity Registrador is
    port (
        clk : in STD_LOGIC;
        desloca : in STD_LOGIC;
        registra : in STD_LOGIC;
        dados : in STD_LOGIC_VECTOR (7 downto 0); -- data in
        
        serial : out STD_LOGIC -- data
    );
end Registrador;

architecture estrutural of Registrador is
    signal ISERIAL : STD_LOGIC_VECTOR (10 downto 0);

begin
    process (clk, ISERIAL, desloca, registra)
    begin
        if (clk'event and clk='1') then
            if (registra = '1') then
                ISERIAL <= '0' & dados & not (dados(0) xor dados(1) xor dados(2) xor dados(3) xor dados(4) xor dados(5) xor dados(6) xor dados(7)) & '1';
                serial <= '1';
            elsif (desloca = '1') then
                serial <= ISERIAL(10);
                ISERIAL <= ISERIAL(9 downto 0) & '1';
            else
                serial <= '1';
            end if;
        end if;
    end process;
end estrutural;

