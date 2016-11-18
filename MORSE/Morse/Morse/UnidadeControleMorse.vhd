library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UnidadeControleMorse is
    port (
        MORSE : in  std_logic;
        COUNTER : in std_logic;
        RESET : in std_logic;
        
        DTR : out std_logic;
        RTS: out std_logic
    );
end entity;

architecture rtl of UnidadeControleMorse is
    TYPE estado is (t0, t1, t2, t3, t4);
    signal state : estado := t0;
begin
    process (MORSE)
    begin 
        if (RESET = 1) then
            state <= t0;
        end if;

        case state is
            when t0 =>
                
        end case;
    end process;
end architecture;