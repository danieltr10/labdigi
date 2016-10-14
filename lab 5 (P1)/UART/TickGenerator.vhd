library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity TickGenerator is
    port (
        CLK : in std_logic;
        RESET : in std_logic;
        
        TICK_TX : out std_logic;
        TICK_RX : out std_logic
    );
end entity;



architecture rtl of TickGenerator is
    
    component TickDivider is
        port(tickin4800Hz : in std_logic;
             tickout300Hz : out std_logic
        );
    end component;
    
    component contador_tick is
		port(
			clk50Mhz : in std_logic;
			reset : in std_logic;
			
			tick4800Hz : out std_logic
		);
	end component;
	
	signal tick4800 : std_logic;
begin
    ModContadorTick : contador_tick port map (
										clk50Mhz => CLK,
										reset => reset,
										
										tick4800Hz => tick4800
	);
	
	ModTickDivider : TickDivider port map (
									tickin4800Hz => tick4800,
									
									tickout300Hz => TICK_TX
	);
	
	TICK_RX <= tick4800;
	
end architecture;