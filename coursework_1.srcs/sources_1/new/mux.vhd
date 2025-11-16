library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer is
    Port (
        clk_slow     : in  STD_LOGIC;                      -- how slow clock is used in this part
        segments_in  : in  STD_LOGIC_VECTOR(6 downto 0);   -- from decoder
        segments_out : out STD_LOGIC_VECTOR(6 downto 0);   -- to display
        EN           : out STD_LOGIC_VECTOR(7 downto 0)    -- zctive low enable for displays
    );
end multiplexer;

architecture Behavioral of multiplexer is
    signal toggle : STD_LOGIC := '0';  -- toggles each rising edge
begin
    process(clk_slow)
    begin
     if rising_edge(clk_slow) then
         toggle <= not toggle;
      end if;
    end process;

    -- pass decoded segments back to the main part
    segments_out <= segments_in;


    EN <= "11111110" when toggle = '0' else --display 0 ON
          "11111011";   --display 2 ON

end Behavioral;

