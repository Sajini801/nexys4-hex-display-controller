library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
     Port (
     clk_in : in STD_LOGIC;
     reset_clk : in STD_LOGIC;
     clk_out : out STD_LOGIC
    );
end clock_divider;

architecture Behavioral of clock_divider is
    signal counter : unsigned(25 downto 0) := (others => '0'); -- 26bit 
    signal slow_clk : STD_LOGIC := '0';
begin

process (clk_in, reset_clk)
begin
   if reset_clk = '1' then
      counter  <= (others => '0');
      slow_clk <= '0';

   elsif rising_edge(clk_in) then
        -- Incrementing counter til it reaches the limit
        if counter = 500000 - 1 then
            counter  <= (others => '0');
            slow_clk <= not slow_clk; 
        else
            counter <= counter + 1;
        end if;
    end if;
end process;

clk_out <= slow_clk;


end Behavioral;
