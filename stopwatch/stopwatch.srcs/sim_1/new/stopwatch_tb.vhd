-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Tue, 28 Apr 2026 17:37:14 GMT
-- Request id : cfwk-fed377c2-69f0f04a4b52a

library ieee;
use ieee.std_logic_1164.all;

entity tb_stopwatch is
end tb_stopwatch;

architecture tb of tb_stopwatch is

    component stopwatch
        port (clk      : in std_logic;
              rst      : in std_logic;
              en       : in std_logic;
              time_out : out std_logic_vector (23 downto 0));
    end component;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal en       : std_logic;
    signal time_out : std_logic_vector (23 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : stopwatch
    port map (clk      => clk,
              rst      => rst,
              en       => en,
              time_out => time_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        en <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        en <= '1';
        wait for 90000ns;
        -- ***EDIT*** Add stimuli here
        

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_stopwatch of tb_stopwatch is
    for tb
    end for;
end cfg_tb_stopwatch;