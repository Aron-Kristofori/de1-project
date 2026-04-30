library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stopwatch is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           time_out : out STD_LOGIC_VECTOR (23 downto 0));
end stopwatch;

architecture Behavioral of stopwatch is

component counter is 
    generic ( 
        G_MAX  : positive := 9;                 --! Max value before wrap-around
        G_BITS : positive := 4                  --! Default number of bits
    );
    port (
        clk       : in  std_logic;                             
        rst       : in  std_logic;                             
        en        : in  std_logic;                             
        cnt       : out std_logic_vector(G_BITS - 1 downto 0); 
        carry_out : out std_logic               --! Cascade enable flag
    );
end component counter;

-- Signal declarations
signal sig_carry_10ms  : std_logic;
signal sig_carry_100ms : std_logic;
signal sig_carry_1s    : std_logic;
signal sig_carry_10s   : std_logic;
signal sig_carry_1m    : std_logic;

signal time_10ms : std_logic_vector(3 downto 0);
signal time_100ms : std_logic_vector(3 downto 0);
signal time_1s : std_logic_vector(3 downto 0);
signal time_10s : std_logic_vector(3 downto 0);
signal time_1m : std_logic_vector(3 downto 0);
signal time_10m : std_logic_vector(3 downto 0);


begin



counter_10ms : counter
    generic map (
        G_MAX => 9,
        G_BITS => 4
    )
    port map (
    clk => clk,
    rst => rst,
    en => en,
    cnt => time_10ms,
    carry_out => sig_carry_10ms
 );
 
 counter_100ms : counter
    generic map (
        G_MAX => 9,
        G_BITS => 4
    )
    port map (
    clk => clk,
    rst => rst,
    en => sig_carry_10ms,
    cnt => time_100ms,
    carry_out => sig_carry_100ms
 );
 
 counter_1s : counter
    generic map (
        G_MAX => 9,
        G_BITS => 4
    )
    port map (
    clk => clk,
    rst => rst,
    en => sig_carry_100ms,
    cnt => time_1s,
    carry_out => sig_carry_1s
 );
 
  counter_10s : counter
    generic map (
        G_MAX => 5,
        G_BITS => 4
    )
    port map (
    clk => clk,
    rst => rst,
    en => sig_carry_1s,
    cnt => time_10s,
    carry_out => sig_carry_10s
 );
 
   counter_1m : counter
    generic map (
        G_MAX => 9,
        G_BITS => 4
    )
    port map (
    clk => clk,
    rst => rst,
    en => sig_carry_10s,
    cnt => time_1m,
    carry_out => sig_carry_1m
 );
 
    counter_10m : counter
    generic map (
        G_MAX => 9,
        G_BITS => 4
    )
    port map (
    clk => clk,
    rst => rst,
    en => sig_carry_1m,
    cnt => time_10m,
    carry_out => open
 );

-- Concatenation of individual digits into one signal
time_out <= time_10m & time_1m & time_10s & time_1s & time_100ms & time_10ms; 


end Behavioral;
