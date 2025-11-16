library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sevenseg_main is
    Port (
        clk         : in  std_logic;                       -- system clock
        reset       : in  std_logic;                       -- synchronous reset for divider
        bcd         : in  std_logic_vector(3 downto 0);    -- hex input
        sevseg      : out std_logic_vector(6 downto 0);    -- seven seg output
        EN          : out std_logic_vector(7 downto 0)     -- anode enables (2 will be active low)
    );
end sevenseg_main;

architecture structural of sevenseg_main is

 
    component clock_divider is
        port (
            clk_in    : in  std_logic;
            reset_clk : in  std_logic;
            clk_out   : out std_logic
        );
    end component;

    component multiplexer is
        port (
            clk_slow     : in  std_logic;
            segments_in  : in  std_logic_vector(6 downto 0);
            segments_out : out std_logic_vector(6 downto 0);
            EN           : out std_logic_vector(7 downto 0)
        );
    end component;

    -- internal signals
    signal slow_clk  : std_logic;
    signal leds      : std_logic_vector(6 downto 0);  -- decoder logic
    signal seg_int   : std_logic_vector(6 downto 0);  -- after inversion 
    signal seg_out   : std_logic_vector(6 downto 0);  -- from multiplexer to physical pins

begin
    -- instantiate clock divider 
    CLK_DIV_INST : clock_divider
        port map (
            clk_in    => clk,
            reset_clk => reset,
            clk_out   => slow_clk
        );

    
    leds <= "1111110" when bcd = "0000" else  -- 0
            "0110000" when bcd = "0001" else  -- 1
            "1101101" when bcd = "0010" else  -- 2
            "1111001" when bcd = "0011" else  -- 3
            "0110011" when bcd = "0100" else  -- 4
            "1011011" when bcd = "0101" else  -- 5
            "1011111" when bcd = "0110" else  -- 6
            "1110000" when bcd = "0111" else  -- 7
            "1111111" when bcd = "1000" else  -- 8
            "1111011" when bcd = "1001" else  -- 9
            "1110111" when bcd = "1010" else  -- A
            "0011111" when bcd = "1011" else  -- b
            "1001110" when bcd = "1100" else  -- C
            "0111101" when bcd = "1101" else  -- d
            "1001111" when bcd = "1110" else  -- E
            "1000111" when bcd = "1111" else  -- F
            "0000000";                                -- default Off

    -- has to be invert because of common anode displays 
    seg_int <= not leds;

   
    MUX_INST : multiplexer
        port map (
            clk_slow     => slow_clk,
            segments_in  => seg_int,
            segments_out => seg_out,
            EN           => EN
        );

    -- the output taken from the multiplexer connected to main pins
    sevseg <= seg_out;

end structural;


