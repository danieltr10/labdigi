library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity ClockDivider is
    port (
        CLKIN : in  std_logic;
        CLKOUT : out  std_logic
    );
end entity;

architecture rtl of ClockDivider is
    signal clock : std_logic := '0';
begin
    process (CLKIN)
        variable contador : integer range 0 to 3;
    begin
        if (CLKIN'event and CLKIN='1') then
            if (contador = 3) then
                CLKOUT <= clock;
                clock <= not clock;
                contador := 0;
            else 
                contador := contador + 1;
            end if;
        end if;
    end process;
end architecture;