library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

----------------------------------------------------------------------------------
entity display_driver is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           time_in : in STD_LOGIC_VECTOR (23 downto 0); --! 6 BCD digits (MM.SS.hh)
           lap_ptr : in STD_LOGIC_VECTOR (3 downto 0); --! State from FSM (0-8)
           dp  : out STD_LOGIC;                       --! Decimal points
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (7 downto 0)); --! 8 anodes
end display_driver;
----------------------------------------------------------------------------------
architecture Behavioral of display_driver is

    -- Component declaration for clock enable
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
 
    -- Component declaration for binary counter, declaration fixed from edited counter.vhd
    component counter is
         generic ( 
        G_MAX  : positive := 9;                  --! Max value before wrap-around
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
 
    component bin2seg is

        Port ( bin : in STD_LOGIC_VECTOR (3 downto 0);
               seg : out STD_LOGIC_VECTOR (6 downto 0));

    end component bin2seg;
 
    -- Internal signals
    signal sig_en : std_logic;
    signal sig_digit : std_logic_vector(2 downto 0);
    signal sig_bin :  std_logic_vector(3 downto 0);
    signal sig_seg_decoded : std_logic_vector(6 downto 0); -- fixed! 
  

begin

    ------------------------------------------------------------------------
    -- Clock enable generator for refresh timing
    ------------------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => 100_000 )  -- Adjust for flicker-free multiplexing, UPDATE: 1ms tick for 1kHz refresh rate - need to test it
        port map (                  -- For simulation: 8
            clk => clk,             -- For implementation: 80_000_000 -- from the lab 
            rst => rst,
            ce  => sig_en
        );

    counter_0 : counter
        generic map ( 
            G_MAX => 7,  -- Scan 8 digits (0 through 7)
            G_BITS => 3  -- 3-bit output
        )
        port map (
            clk => clk,
            rst => rst,
            en  => sig_en,
            cnt => sig_digit,
            carry_out => open -- We dont need carry_out for the multiplexer I guess?
        );

    ------------------------------------------------------------------------
    -- Digit select, not deleting this, will do tomorrow!
    ------------------------------------------------------------------------
   -- sig_bin <= data(3 downto 0) when sig_digit = "0" else
   --            data(7 downto 4);

    ------------------------------------------------------------------------
    -- Digit select (Routing the 24-bit bus)
    ------------------------------------------------------------------------
    sig_bin <= time_in(3 downto 0)   when sig_digit = "000" else  -- hh ones
               time_in(7 downto 4)   when sig_digit = "001" else  -- hh tens
               time_in(11 downto 8)  when sig_digit = "010" else  -- SS ones
               time_in(15 downto 12) when sig_digit = "011" else  -- SS tens
               time_in(19 downto 16) when sig_digit = "100" else  -- MM ones
               time_in(23 downto 20) when sig_digit = "101" else  -- MM tens
               lap_ptr            when sig_digit = "110" else  -- Lap number
               "0000";                                         -- Dig 7 dummy value
    ------------------------------------------------------------------------
    -- 7-segment decoder
    ------------------------------------------------------------------------
    decoder_0 : bin2seg
        port map (
            bin => sig_bin,
            seg => sig_seg_decoded  -- Route to our intercept signal, because for the the L for laps 

        );

        -- Inject the 'L' character on digit 7 if a lap is being displayed
    -- 'L' = segments d, e, f are ON (0), others are OFF (1). check this tommorow!
    seg <= b"111_0001" when (sig_digit = "111" and lap_ptr /= "0000") else sig_seg_decoded;

    ------------------------------------------------------------------------
    -- DONE! Anode and DP select process, will do later! below is the old code for anode select, need to add DP control and lap 'L' control
    ------------------------------------------------------------------------

    p_anode_select : process (sig_digit, lap_ptr) is
    begin
        -- Default values (everything OFF to prevent latches)
        anode <= "11111111";
        dp    <= '1'; 

        case sig_digit is
            when "000" => anode <= "11111110"; -- hh ones
            when "001" => anode <= "11111101"; -- hh tens
            when "010" => 
                anode <= "11111011"; -- SS ones
                dp    <= '0';        -- Turn ON Decimal Point!
            when "011" => anode <= "11110111"; -- SS tens
            when "100" => 
                anode <= "11101111"; -- MM ones
                dp    <= '0';        -- Turn ON Decimal Point!
            when "101" => anode <= "11011111"; -- MM tens
            when "110" =>
                if lap_ptr /= "0000" then
                    anode <= "10111111"; -- Lap number (only ON if lap_ptr > 0)
                end if;
            when "111" =>
                if lap_ptr /= "0000" then
                    anode <= "01111111"; -- 'L' character (only ON if lap_ptr > 0)
                end if;
            when others =>
                anode <= "11111111";
        end case;
    end process;
end Behavioral;