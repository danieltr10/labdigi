library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity contadorRecepcao is
    port (
        clk: in  std_logic;
        conta35 : in std_logic;
        conta32 : in std_logic;
        reset: in  std_logic;
        
        fimConta35 : out std_logic;
        fimConta32 : out std_logic
       
    );
end entity;

architecture rtl of contadorRecepcao is
begin
    process(clk, conta35, conta32, reset)
        variable contador35 : integer range 0 to 34;
        variable contador32 : integer range 0 to 31;
    begin
        if (reset = '1') then
            contador35 := 0;
            fimConta35 <= '0';
            contador32 := 0;
            fimConta32 <= '0';
        elsif (clk'event and clk='1') then
            if (conta35 = '1') then
                if (contador35 = 34) then
                    fimConta35 <= '1';
                else
                    contador35 := contador35 + 1;
                end if;
            end if;
            
            if (conta32 = '1') then
				if (contador32 = 31) then
                    fimConta32 <= '1';
                else
                    contador32 := contador32 + 1;
                end if;
            end if;
        end if;
    end process;
end architecture;