-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Wed, 15 Apr 2026 07:01:12 GMT
-- Request id : cfwk-fed377c2-69df37b8d30d6

library ieee;
use ieee.std_logic_1164.all;

entity tb_counter is
end tb_counter;

architecture tb of tb_counter is

    component counter
        port (clk       : in std_logic;
              rst       : in std_logic;
              en        : in std_logic;
              cnt       : out std_logic_vector (G_BITS - 1 downto 0);
              carry_out : out std_logic);
    end component;
    
    constant G_BITS : positive := 4;
    constant G_MAX  : natural := 9;
    
    signal clk       : std_logic;
    signal rst       : std_logic;
    signal en        : std_logic;
    signal cnt       : std_logic_vector (G_BITS - 1 downto 0);
    signal carry_out : std_logic;

    constant TbPeriod : time := 1000 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : counter
    port map (clk       => clk,
              rst       => rst,
              en        => en,
              cnt       => cnt,
              carry_out => carry_out);

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
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_counter of tb_counter is
    for tb
    end for;
end cfg_tb_counter;