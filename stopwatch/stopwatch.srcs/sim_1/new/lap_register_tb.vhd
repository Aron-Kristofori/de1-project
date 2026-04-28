-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : Tue, 28 Apr 2026 11:42:21 GMT
-- Request id : cfwk-fed377c2-69f09d1d986fc

library ieee;
use ieee.std_logic_1164.all;

entity tb_lap_register is
end tb_lap_register;

architecture tb of tb_lap_register is

    component lap_register
        port (clk      : in std_logic;
              rst      : in std_logic;
              lap_we   : in std_logic;
              time_in  : in std_logic_vector (23 downto 0);
              lap_ptr  : in std_logic_vector (3 downto 0);
              time_out : out std_logic_vector (23 downto 0));
    end component;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal lap_we   : std_logic;
    signal time_in  : std_logic_vector (23 downto 0);
    signal lap_ptr  : std_logic_vector (3 downto 0);
    signal time_out : std_logic_vector (23 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : lap_register
    port map (clk      => clk,
              rst      => rst,
              lap_we   => lap_we,
              time_in  => time_in,
              lap_ptr  => lap_ptr,
              time_out => time_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

    stimuli : process
    begin
        lap_we <= '0';
        time_in <= (others => '0');
        lap_ptr <= (others => '0');
        -- Reset generation
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;
        -- Stimuli
        -- 1. Filling up the register
        time_in <= x"000001";
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        time_in <= x"000002";
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        time_in <= x"000003";
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        time_in <= x"000004";
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        time_in <= x"000005";
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        time_in <= x"000006";
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        time_in <= x"000007";
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        time_in <= x"000008";
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        time_in <= x"000009";
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        -- 2. Testing behaviour of full register
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        wait for 10ns;
        lap_we <= '1';
        wait for 10ns;
        lap_we <= '0';
        -- 3. Displaying values from register
        lap_ptr <= "0001";
        wait for 20ns;
        lap_ptr <= "0100";
        wait for 20ns;
        lap_ptr <= "0101";
        wait for 20ns;
        

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.
configuration cfg_tb_lap_register of tb_lap_register is
    for tb
    end for;
end cfg_tb_lap_register;