-- VHDL da Unidade de Controle

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY unidade_controle IS
   PORT(
      clk      : IN   STD_LOGIC;
      partida  : IN   STD_LOGIC;
      reset    : IN   STD_LOGIC;
      fim	   : IN STD_LOGIC;
      saida    : OUT  STD_LOGIC_VECTOR(1 downto 0);
      estados  : OUT  STD_LOGIC_VECTOR(1 downto 0);
      pronto   : OUT STD_LOGIC;
      partida_x  : OUT STD_LOGIC
      );
END unidade_controle;

ARCHITECTURE exemplo OF unidade_controle IS
   TYPE tipo_estado IS (s0, s1, s2,s3);
   SIGNAL estado   : tipo_estado;
   signal partidaz : std_logic;
BEGIN
	PROCESS (clk,partida)
	BEGIN
		if clk='1' and clk'event then
			partidaz<=partida;
		end if;
		partida_x <= partida and (not partidaz);
	END PROCESS;

   PROCESS (clk, reset)
   BEGIN
   
      IF reset = '1' THEN
         estado <= s0;
         
      ELSIF (clk'EVENT AND clk = '1') THEN
         CASE estado IS
            WHEN s0=>
               IF (partida and (not partidaz))='1' THEN
                  estado <= s1;
               ELSE
                  estado <= s0;
               END IF;
               
            WHEN s1=>
                  estado <= s2;
               
            WHEN s2=> 
				 IF fim = '0' THEN
                  estado <= s2;
               ELSE
                  estado <= s3;
               END IF;
           WHEN s3=> 
                  estado <= s0;
         END CASE;
      END IF;
   END PROCESS;
   
   PROCESS (estado)
   BEGIN
      CASE estado IS
         WHEN s0 =>
            saida <= "00";
            estados <= "00";
            pronto<='0';
         WHEN s1 =>
            saida <= "01";
            estados <= "01";
         WHEN s2 =>
            saida <= "10";
            estados <= "10";
         WHEN s3 =>
            saida <= "10";
            estados <= "10";
            pronto <='1';
      END CASE;
   END PROCESS;
   
END exemplo;-- VHDL da Unidade de Controle
