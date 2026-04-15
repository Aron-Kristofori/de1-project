-------------------------------------------------
-- Testbench pre N-bitovy citac
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tb_counter is
end tb_counter;

architecture tb of tb_counter is

    -- 1. Definicia parametrov (zhodne s counter.vhd)
    constant G_BITS   : positive := 4;
    constant G_MAX    : natural  := 9;
    constant TbPeriod : time     := 10 ns; -- 100 MHz hodinovy signal

    -- 2. Deklaracia komponentu s generikami
    component counter
        generic (
            G_MAX  : natural;
            G_BITS : positive
        );
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            en        : in  std_logic;
            cnt       : out std_logic_vector(G_BITS - 1 downto 0);
            carry_out : out std_logic
        );
    end component;

    -- 3. Interne signaly pre prepojenie testbenchu a citaca
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal en        : std_logic := '0';
    signal cnt       : std_logic_vector(G_BITS - 1 downto 0);
    signal carry_out : std_logic;

    -- Signal pre ukoncenie simulacie
    signal TbSimEnded : std_logic := '0';

begin

    -- 4. Instancia testovaneho modulu (DUT - Device Under Test)
    dut : counter
        generic map (
            G_MAX  => G_MAX,
            G_BITS => G_BITS
        )
        port map (
            clk       => clk,
            rst       => rst,
            en        => en,
            cnt       => cnt,
            carry_out => carry_out
        );

    -- 5. Generovanie hodin (Clock process)
    p_clk_gen : process
    begin
        while TbSimEnded /= '1' loop
            clk <= '0';
            wait for TbPeriod / 2;
            clk <= '1';
            wait for TbPeriod / 2;
        end loop;
        wait;
    end process p_clk_gen;

    -- 6. Stimulus proces (Samotne testovanie)
    p_stimuli : process
    begin
        -- Inicializacia
        en  <= '0';
        rst <= '0';
        wait for TbPeriod;

        -- Reset test (Synchronny reset potrebuje nabeznu hranu)
        rst <= '1';
        wait for TbPeriod * 2;
        rst <= '0';
        wait for TbPeriod;

        -- TEST 1: Povolenie pocitania (en = 1)
        en <= '1';
        -- Nechame ho pocitat dostatocne dlho, aby presiel cez G_MAX (9)
        -- Mal by si vidiet: 0, 1, 2 ... 8, 9, 0, 1 ...
        wait for TbPeriod * 15;

        -- TEST 2: Zastavenie pocitania (en = 0)
        en <= '0';
        wait for TbPeriod * 5;

        -- TEST 3: Opatovne spustenie a kontrola Carry Out
        en <= '1';
        wait for TbPeriod * 10;

        -- Ukoncenie simulacie
        TbSimEnded <= '1';
        report "Simulacia uspesne dokoncena!";
        wait;
    end process p_stimuli;

end tb;