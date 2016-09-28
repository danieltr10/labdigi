library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity hex_display is
    Port ( value : in std_logic_vector(3 downto 0);
    blank : in std_logic;
    test : in std_logic;
    segs : out std_logic_vector(6 downto 0));
end hex_display;

architecture behavioral of hex_display is
begin
    process (value, blank, test) is
    begin
        if (blank = '1') then
            segs <= "00000000";
        elsif (test = '1') then
            segs <= "11111111";
        else
            case value is
                when "0000" => segs <= "0111111"; -- 0
                when "0001" => segs <= "0000110"; -- 1
                when "0010" => segs <= "1011011"; -- 2
                when "0011" => segs <= "1001111"; -- 3
                when "0100" => segs <= "1100110"; -- 4
                when "0101" => segs <= "1101101"; -- 5
                when "0110" => segs <= "1111101"; -- 6
                when "0111" => segs <= "0000111"; -- 7
                when "1000" => segs <= "1111111"; -- 8
                when "1001" => segs <= "1100111"; -- 9
                when "1010" => segs <= "1110111"; -- A
                when "1011" => segs <= "1111100"; -- b
                when "1100" => segs <= "0111001"; -- c
                when "1101" => segs <= "1011110"; -- d
                when "1110" => segs <= "1111001"; -- E
                when others => segs <= "1110001"; -- F
            end case;
        end if;
    end process;
end behavioral;