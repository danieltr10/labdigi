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
   signal contagem, prox_contagem: integer;
begin
   -- registrador
   process(clk50MHz,reset)
   begin
      if (reset='1') then
         contagem <= 0;
      elsif (clk50MHz'event and clk50MHz='1') then
         contagem <= prox_contagem;
      end if;
   end process;
   -- logica de proximo estado
   prox_contagem <= 0 when contagem=(M-1) else contagem + 1;
   -- logica de saida
   tick880Hz <= '1' when contagem=(M-1) else '0';
   
   process(clk50MHz,reset)
   begin
       if (reset='1') then
           contagem <= 0;
       elsif (clk50MHz'event and clk50MHz='1') then
           contagem <= prox_contagem;
       end if;
   end process;
   -- logica de proximo estado
   prox_contagem <= 0 when contagem=(N-1) else contagem + 1;
   -- logica de saida
   tick500mHz <= '1' when contagem=(N-1) else '0';
end arch;