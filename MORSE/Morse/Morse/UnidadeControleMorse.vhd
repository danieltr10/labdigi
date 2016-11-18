library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity UnidadeControleMorse is
    port (
        CLK : in std_logic;
        MORSE : in  std_logic;
        COUNTER : in std_logic;
        RESET : in std_logic;
        LIGA : in std_logic;
        
        CARREGAPONTO : out std_logic;
        CARREGATRACO : out std_logic;
        CARREGAFIM : out std_logic;
        PARTIDA : out std_logic;
        DTR : out std_logic;
        RTS: out std_logic
    );
end entity;

architecture rtl of UnidadeControleMorse is
    TYPE estado is (t0, t1, t2, t3, t4, t5, t6);
    signal state : estado := t0;
begin
    process (MORSE)
    begin 
        if (LIGA = 0) then
            state <= t0;
        elsif (RESET = 1) then
            state <= t0;
        else
            if (CLK'event and CLK='1') then
                case state is
                    when t0 =>
                        state <= t1;
                    when t1 =>
                        if (COUNTER = '1') then
                            if (MORSE'event and MORSE = '1') then
                                state <= t2;
                            else 
                                state <= t5;
                            end if;
                        end if;
                    when t2 =>
                        if (COUNTER = 0) then
                            if (MORSE = 0) then
                                state <= t3;
                            else
                                state <= t4;
                            end if;
                        end if;
                    when t3 =>
                        state <= t1;
                    when t4 =>
                        state <= t1;
                    when t5 =>
                        state <= t6;
                    when t6 =>
                        state <= t1;
                end case;
            end if;
        end if;
    end process;
    
    process (state) begin
        case state is
            when t0 =>
                DTR <= '1';
                CARREGAPONTO <= '0';
                CARREGATRACO <= '0';
                CARREGAFIM <= '0';
                PARTIDA <= '1';
            when t1 =>
                DTR <= '0';
                CARREGAPONTO <= '0';
                CARREGATRACO <= '0';
                CARREGAFIM <= '0';
                PARTIDA <= '0';
            when t2 =>
                DTR <= '1';
                CARREGAPONTO <= '0';
                CARREGATRACO <= '0';
                CARREGAFIM <= '0';
                PARTIDA <= '0';
            when t3 =>
                DTR <= '1';
                CARREGAPONTO <= '1';
                CARREGATRACO <= '0';
                CARREGAFIM <= '0';
                PARTIDA <= '0';
            when t4 =>
                DTR <= '1';
                CARREGAPONTO <= '0';
                CARREGATRACO <= '1';
                CARREGAFIM <= '0';
                PARTIDA <= '0';
            when t5 =>
                DTR <= '1';
                CARREGAPONTO <= '0';
                CARREGATRACO <= '0';
                CARREGAFIM <= '1';
                PARTIDA <= '0';
            when t6 =>
                DTR <= '1';
                CARREGAPONTO <= '0';
                CARREGATRACO <= '0';
                CARREGAFIM <= '0';
                PARTIDA <= '1';
        end case;
    end process;
end architecture;