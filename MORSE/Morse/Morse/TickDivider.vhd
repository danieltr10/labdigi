library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity TickDivider is
    port (
        TICKIN880HZ : in  std_logic;
        TICKOUT110HZ : out  std_logic
    );
end entity;

architecture rtl of TickDivider is
    signal clock : std_logic := '0';
begin
    process (TICKIN880HZ)
        variable contador : integer range 0 to 3;
    begin
        if (TICKIN880HZ'event and TICKIN880HZ='1') then
            if (contador = 3) then
                TICKOUT110HZ <= clock;
                clock <= not clock;
                contador := 0;
            else 
                contador := contador + 1;
            end if;
        end if;
    end process;
end architecture;