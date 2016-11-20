-- contador_tick.vhd
--                      gerador de tick usando contador modulo-M
-- codigo baseado no livro de Pong Chu - "FPGA Prototyping by VHDL Examples"
-- Listing 4.11
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_tick is
   generic(
      M: integer := 56818;     -- modulo do contador
      N: integer := 100000000
   );
   port(
      clk50MHz, reset: in std_logic;
      tick880Hz: out std_logic;
      tick500mHz: out std_logic
   );
end contador_tick;

architecture arch of contador_tick is
   signal contagem880Hz, contagem500mHz, prox_contagem880Hz, prox_contagem500mHz: integer;
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
   prox_contagem880Hz <= 0 when contagem880Hz=(M-1) else contagem880Hz + 1;
   -- logica de saida
   tick880Hz <= '1' when contagem880Hz=(M-1) else '0';
   
   process(clk50MHz,reset)
   begin
       if (reset='1') then
           contagem500mHz <= 0;
       elsif (clk50MHz'event and clk50MHz='1') then
           contagem500mHz <= prox_contagem500mHz;
       end if;
   end process;
   -- logica de proximo estado
   prox_contagem500mHz <= 0 when contagem500mHz=(N-1) else contagem500mHz + 1;
   -- logica de saida
   tick500mHz <= '1' when contagem500mHz=(N-1) else '0';
end arch;