library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity morseTo7Seg is
    Port ( valor : in std_logic_vector(11 downto 0);
    blank : in std_logic;
    mostraDadoDisplay : in std_logic;

    rightHex : out std_logic_vector(6 downto 0);
    leftHex : out std_logic_vector(6 downto 0)
    );
end morseTo7Seg;

architecture behavioral of morseTo7Seg is
begin
    process (valor, blank, mostraDadoDisplay) is
    begin
        if (blank = '1') then
            rightHex <= "1111111";
            leftHex <= "1111111";
        elsif (mostraDadoDisplay = '1') then 
            case valor is
                when "010011111111" => -- A
                    rightHex <= "1111001";
                    leftHex <= "0011001"; 

                when "000000011111" => -- B
                    rightHex <= "0100100";
                    leftHex <= "0011001"; 

                when "000100011111" => -- C
                    rightHex <= "0110000";
                    leftHex <= "0011001"; 

                when "000001111111" => -- D
                    rightHex <= "0011001";
                    leftHex <= "0011001"; 

                when "001111111111" => -- E
                    rightHex <= "0010010";
                    leftHex <= "0011001"; 

                when "000100001111" => -- F
                    rightHex <= "0000010";
                    leftHex <= "0011001"; 

                when "000101111111" => -- G
                    rightHex <= "1111000";
                    leftHex <= "0011001"; 

                when "000000001111" => -- H
                    rightHex <= "0000000";
                    leftHex <= "0011001"; 

                when "000011111111" => -- I
                    rightHex <= "0011000"; 
                    leftHex <= "0011001"; 

                when "010101001111" => -- J
                    rightHex <= "0001000"; 
                    leftHex <= "0011001"; 

                when "010001111111" => -- K
                    rightHex <= "0000011"; 
                    leftHex <= "0011001"; 

                when "000001001111" => -- L
                    rightHex <= "1000110"; 
                    leftHex <= "0011001"; 

                when "010111111111" => -- M
                    rightHex <= "0100001"; 
                    leftHex <= "0011001"; 

                when "000111111111" => -- N
                    rightHex <= "0000110";
                    leftHex <= "0011001"; 

                when "010101111111" => -- O
                    rightHex <= "0001110"; 
                    leftHex <= "0011001"; 

                when "000101001111" => -- P
                    rightHex <= "1000000"; 
                    leftHex <= "0010010"; 

                when "010001011111" => -- Q
                    rightHex <= "1111001"; 
                    leftHex <= "0010010"; 

                when "000100111111" => -- R
                    rightHex <= "0100100"; 
                    leftHex <= "0010010"; 

                when "000000111111" => -- S
                    rightHex <= "0110000"; 
                    leftHex <= "0010010"; 

                when "011111111111" => -- T
                    rightHex <= "0011001"; 
                    leftHex <= "0010010"; 

                when "010000111111" => -- U
                    rightHex <= "0010010"; 
                    leftHex <= "0010010"; 

                when "010000001111" => -- V
                    rightHex <= "0000010"; 
                    leftHex <= "0010010"; 

                when "010100111111" => -- W
                    rightHex <= "1111000"; 
                    leftHex <= "0010010"; 

                when "010000011111" => -- X
                    rightHex <= "0000000"; 
                    leftHex <= "0010010"; 

                when "010100011111" => -- Y
                    rightHex <= "0011000"; 
                    leftHex <= "0010010"; 

                when "000001011111" => -- Z
                    rightHex <= "0001000"; 
                    leftHex <= "0010010"; 

                when "010101010101" => -- 0
                    rightHex <= "1000000"; 
                    leftHex <= "0110000"; 

                when "010101010111" => -- 1
                    rightHex <= "1111001"; 
                    leftHex <= "0110000"; 

                when "010101000011" => -- 2
                    rightHex <= "0000110"; 
                    leftHex <= "0110000"; 

                when "010100000011" => -- 3
                    rightHex <= "0100100"; 
                    leftHex <= "0110000"; 

                when "010000000011" => -- 4
                    rightHex <= "0110000"; 
                    leftHex <= "0110000"; 

                when "000000000011" => -- 5
                    rightHex <= "0010010"; 
                    leftHex <= "0110000"; 

                when "000000000111" => -- 6
                    rightHex <= "0000010"; 
                    leftHex <= "0110000"; 

                when "000000010111" => -- 7
                    rightHex <= "1111000"; 
                    leftHex <= "0110000"; 

                when "000001010111" => -- 8
                    rightHex <= "0000000"; 
                    leftHex <= "0110000"; 

                when "000101010111" => -- 9
                    rightHex <= "0011000"; 
                    leftHex <= "0110000"; 

                when "010001000100" => -- .
                    rightHex <= "0000110"; 
                    leftHex <= "0100100"; 

                when "010100000101" => -- ,
                    rightHex <= "1000110"; 
                    leftHex <= "0100100"; 

                when "000001010000" => -- ?
                    rightHex <= "0001110"; 
                    leftHex <= "0110000"; 

                when others => rightHex <= "0111111"; -- INVALID

            end case;
        end if;
    end process;
end behavioral;