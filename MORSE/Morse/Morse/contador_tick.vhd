-- contador_tick.vhd
--                      gerador de tick usando contador modulo-M
-- codigo baseado no livro de Pong Chu - "FPGA Prototyping by VHDL Examples"
-- Listing 4.11
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity contador_tick is
   generic(
      M: integer := 4;     -- modulo do contador
      N: integer := 8
   );
   port(
      clk50MHz, reset: in std_logic;
      tick880Hz: out std_logic;
      tick500mHz: out std_logic
   );
end contador_tick;

architecture arch of contador_tick is
   signal contagem880Hz, contagem500mHz, prox_contagem880Hz: integer;
   signal clockAux : std_logic := '0'; 
begin
   -- registrador
   process(clk50MHz,reset)
   begin
      if (reset='1') then
         contagem880Hz <= 0;
      elsif (clk50MHz'event and clk50MHz='1') then
         contagem880Hz <= prox_contagem880Hz;
      end if;
   end process;
   -- logica de proximo estado
   prox_contagem880Hz <= 0 when contagem880Hz=(56818) else contagem880Hz + 1;
   -- logica de saida
   tick880Hz <= '1' when contagem880Hz=(56818) else '0';
   
   process(clk50MHz,reset)
   begin
       if (reset='1') then
           contagem500mHz <= 0;
			  tick500mHz <= '0';
       elsif (clk50MHz'event and clk50MHz='1') then
           contagem500mHz <= contagem500mHz + 1;
           if (contagem500mHz = 50000000) then
               tick500mHz <= clockAux;
					contagem500mHz <= 0;
               clockAux <= not clockAux;
           end if;
       end if;
   end process;
end arch;