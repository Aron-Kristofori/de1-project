library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stopwatch_top is
    Port ( 
        clk   : in  STD_LOGIC;
        btnl  : in  STD_LOGIC; -- Global Reset
        btnu  : in  STD_LOGIC; -- Up
        btnd  : in  STD_LOGIC; -- Down
        btnc  : in  STD_LOGIC; -- Lap
        btnr  : in  STD_LOGIC; -- Start/Stop
        
        seg   : out STD_LOGIC_VECTOR (6 downto 0);
        an    : out STD_LOGIC_VECTOR (7 downto 0);
        dp    : out STD_LOGIC
    );
end stopwatch_top;
----------------------------------------------------------------------------------
architecture Structural of stopwatch_top is

    ------------------------------------------------------------------------
    -- Component Declarations
    ------------------------------------------------------------------------
    
    -- 1. Debouncer (from previous labs)
    component debounce is
       port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           btn_state : out STD_LOGIC;
           btn_press : out STD_LOGIC
           );
    end component debounce;

    -- 2. Control FSM (Aron  wrote this)
  component ctrl_fsm is
        Port ( 
           clk     : in STD_LOGIC;
           rst     : in STD_LOGIC;
           start   : in STD_LOGIC;
           up      : in STD_LOGIC;
           down    : in STD_LOGIC;
           lap_ptr : out STD_LOGIC_VECTOR (3 downto 0);
           cnt_en  : out STD_LOGIC
        );
    end component ctrl_fsm;

    -- 3. Lap Register (Tom wrote this)
    component lap_register is
        port ( 
            clk      : in  std_logic;
            rst      : in  std_logic;
            lap_we   : in  std_logic;
            time_in  : in  std_logic_vector(23 downto 0);
            lap_ptr  : in  std_logic_vector(3 downto 0);
            time_out : out std_logic_vector(23 downto 0) 
        );
    end component lap_register;

    -- 4. Stopwatch (Aron is writing this)
    component stopwatch is
        port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            en    : in  std_logic;
            time_out  : out std_logic_vector(23 downto 0)
        );
    end component stopwatch;

    -- 5. Clock (from previous labs)
    component clk_en is
      generic ( G_MAX : positive  := 5); 
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce : out STD_LOGIC
        );
    end component clk_en;

    -- 6. Display Driver (Tom updated this)
    component display_driver is
        port ( 
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           time_in : in STD_LOGIC_VECTOR (23 downto 0); --! 6 BCD digits (MM.SS.hh)
           lap_ptr : in STD_LOGIC_VECTOR (3 downto 0); --! State from FSM (0-8)
           dp  : out STD_LOGIC;                       --! Decimal points
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (7 downto 0) --! 8 anodes
        );
    end component display_driver;

    ------------------------------------------------------------------------
    -- Internal Signals
    ------------------------------------------------------------------------
    -- Debounced buttons
    signal sig_btn_up    : std_logic;
    signal sig_btn_down  : std_logic;
    signal sig_btn_lap   : std_logic;
    signal sig_btn_start : std_logic;

    -- FSM & Control signals -- jeste nejsou ve schematu, pokud budou jinak zmenit !! Update: DONE! uz jsou...
    signal sig_cnt_en    : std_logic;
    signal sig_lap_ptr   : std_logic_vector(3 downto 0);
    
    -- Timer & Enable signals
    signal sig_ce           : std_logic;
    signal sig_en : std_logic;

    -- Data buses
    signal sig_time : std_logic_vector(23 downto 0);
    signal sig_register      : std_logic_vector(23 downto 0);
    signal sig_display  : std_logic_vector(23 downto 0);

begin

    ------------------------------------------------------------------------
    -- Button Debouncers
    ------------------------------------------------------------------------
    debounce_up : debounce
        port map ( 
            clk => clk, 
            rst => btnl, 
            btn_in => btnu, 
            btn_press => sig_btn_up,
            btn_state => open
            );

    debounce_down : debounce
        port map ( 
            clk => clk,
            rst => btnl, 
            btn_in => btnd, 
            btn_press => sig_btn_down,
            btn_state => open
            );

    debounce_lap : debounce
        port map ( 
            clk => clk, 
            rst => btnl, 
            btn_in => btnc, 
            btn_press => sig_btn_lap,
            btn_state => open
            );

    debounce_start : debounce
        port map ( 
            clk => clk, 
            rst => btnl, 
            btn_in => btnr, 
            btn_press => sig_btn_start,
            btn_state => open
            );

    ----------------    --------------------------------------------------------
    -- Control FSM
    ------------------------------------------------------------------------
    fsm_0 : ctrl_fsm
        port map (
            clk     => clk,
            rst     => btnl,
            up      => sig_btn_up,
            down    => sig_btn_down,
            start   => sig_btn_start,
            cnt_en  => sig_cnt_en,
            lap_ptr => sig_lap_ptr
        );

    ------------------------------------------------------------------------
    -- Lap Register Memory
    ------------------------------------------------------------------------
    lap_reg_0 : lap_register
        port map (
            clk      => clk,
            rst      => btnl,
            lap_we   => sig_btn_lap,
            time_in  => sig_time,
            lap_ptr  => sig_lap_ptr,
            time_out => sig_register
        );

    ------------------------------------------------------------------------
    -- Stopwatch Timer & Clock Enable
    ------------------------------------------------------------------------
    ce_100Hz : clk_en
        generic map ( G_MAX => 1_000_000 ) -- 100 Hz tick (10 ms) for the stopwatch
        port map ( 
            clk => clk, 
            rst => btnl, 
            ce => sig_ce
             );

    -- AND Gate for Stopwatch enable
    sig_en <= sig_ce and sig_cnt_en;

    timer_0 : stopwatch
        port map (
            clk  => clk,
            rst  => btnl,
            en   => sig_en,
            time_out => sig_time
        );

    ------------------------------------------------------------------------
    -- Display Multiplexer & Driver
    ------------------------------------------------------------------------
        -- MUX to choose live time vs lap memory
    -- If lap pointer is 0, show live time. Otherwise, show the saved lap.
    sig_display <= sig_time when (sig_lap_ptr = "0000") else sig_register;

    display_0 : display_driver
        port map (
            clk     => clk,
            rst     => btnl,
            time_in    => sig_display,
            lap_ptr => sig_lap_ptr,
            dp      => dp,
            seg     => seg,
            anode   => an
        );

end Structural;