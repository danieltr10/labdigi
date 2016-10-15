library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity TickDivider is
    port (
        TICKIN4800HZ : in  std_logic;
        TICKOUT300HZ : out  std_logic
    );
end entity;

architecture rtl of TickDivider is
    signal clock : std_logic := '0';
begin
    process (TICKIN4800HZ)
        variable contador : integer range 0 to 3;
    begin
        if (TICKIN4800HZ'event and TICKIN4800HZ='1') then
            if (contador = 3) then
                TICKOUT300HZ <= clock;
                clock <= not clock;
                contador := 0;
            else 
                contador := contador + 1;
            end if;
        end if;
    end process;
end architecture;