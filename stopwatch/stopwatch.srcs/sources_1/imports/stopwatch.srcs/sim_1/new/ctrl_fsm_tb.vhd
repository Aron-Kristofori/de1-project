-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Tue, 21 Apr 2026 07:27:46 GMT
-- Request id : cfwk-fed377c2-69e726f218125

library ieee;
use ieee.std_logic_1164.all;

entity tb_ctrl_fsm is
end tb_ctrl_fsm;

architecture tb of tb_ctrl_fsm is

    component ctrl_fsm
        port (clk     : in std_logic;
              rst     : in std_logic;
              start   : in std_logic;
              up      : in std_logic;
              down    : in std_logic;
              lap_ptr : out std_logic_vector (3 downto 0);
              cnt_en  : out std_logic);
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal start   : std_logic;
    signal up      : std_logic;
    signal down    : std_logic;
    signal lap_ptr : std_logic_vector (3 downto 0);
    signal cnt_en  : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : ctrl_fsm
    port map (clk     => clk,
              rst     => rst,
              start   => start,
              up      => up,
              down    => down,
              lap_ptr => lap_ptr,
              cnt_en  => cnt_en);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        -- Input initialization
        start <= '0';
        up <= '0';
        down <= '0';
        -- Reset generation
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;
        -- Stimuli
        -- 1. Functionality of start/stop
        start <= '1';
        wait for TbPeriod;
        start <= '0';
        wait for TbPeriod; -- one button press, cnt_en should go high to start the counter
        start <= '1';
        wait for TbPeriod;
        start <= '0';
        wait for TbPeriod; -- two button presses, cnt_en should go low and stop the counter
        -- 2. Functionality of lap_ptr
        -- Increment lap_ptr and test overflow from 9 to 0
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 1
        up <= '1';
        wait for TbPeriod; 
        up <= '0';
        wait for TbPeriod; -- 2
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 3
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 4
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 5
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 6
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 7
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 8
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 9
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 10 - wrap around to 0
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 11
        up <= '1';
        wait for TbPeriod;
        up <= '0';
        wait for TbPeriod; -- 12
        --Start decrementing
        down <= '1';
        wait for TbPeriod;
        down <= '0';
        wait for TbPeriod; -- 13
        down <= '1';
        wait for TbPeriod;
        down <= '0';
        wait for TbPeriod; -- 14
        down <= '1';
        wait for TbPeriod;
        down <= '0';
        wait for TbPeriod; -- 15
        down <= '1';
        wait for TbPeriod;
        down <= '0';
        wait for TbPeriod; -- 16
        down <= '1';
        wait for TbPeriod;
        down <= '0';
        wait for TbPeriod; -- 17
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_ctrl_fsm of tb_ctrl_fsm is
    for tb
    end for;
end cfg_tb_ctrl_fsm;