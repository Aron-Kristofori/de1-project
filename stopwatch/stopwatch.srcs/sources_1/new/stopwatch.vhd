library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stopwatch is
    Port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        en       : in  std_logic;
        time_out : out std_logic_vector(23 downto 0)
    );
end stopwatch;

architecture Behavioral of stopwatch is

    -- Internal signals for the 6 individual BCD digits
    signal h_ones : unsigned(3 downto 0) := (others => '0'); -- Hundredths ones (0-9)
    signal h_tens : unsigned(3 downto 0) := (others => '0'); -- Hundredths tens (0-9)
    signal s_ones : unsigned(3 downto 0) := (others => '0'); -- Seconds ones (0-9)
    signal s_tens : unsigned(3 downto 0) := (others => '0'); -- Seconds tens (0-5)
    signal m_ones : unsigned(3 downto 0) := (others => '0'); -- Minutes ones (0-9)
    signal m_tens : unsigned(3 downto 0) := (others => '0'); -- Minutes tens (0-5)

begin

    ------------------------------------------------------------------------
    -- Synchronous Cascade BCD Counter
    ------------------------------------------------------------------------
    p_stopwatch_count : process(clk)
    begin
        -- Test of clock rising edge
        if rising_edge(clk) then
            
            -- Synchronous reset
            if rst = '1' then
                h_ones <= (others => '0');
                h_tens <= (others => '0');
                s_ones <= (others => '0');
                s_tens <= (others => '0');
                m_ones <= (others => '0');
                m_tens <= (others => '0');
                
            -- Count only when enable is high (100 Hz tick AND FSM running)
            elsif en = '1' then
                
                -- 1. Hundredths ones (0 to 9)
                if h_ones = 9 then
                    h_ones <= (others => '0');
                    
                    -- 2. Hundredths tens (0 to 9)
                    if h_tens = 9 then
                        h_tens <= (others => '0');
                        
                        -- 3. Seconds ones (0 to 9)
                        if s_ones = 9 then
                            s_ones <= (others => '0');
                            
                            -- 4. Seconds tens (0 to 5)
                            if s_tens = 5 then
                                s_tens <= (others => '0');
                                
                                -- 5. Minutes ones (0 to 9)
                                if m_ones = 9 then
                                    m_ones <= (others => '0');
                                    
                                    -- 6. Minutes tens (0 to 5)
                                    if m_tens = 5 then
                                        m_tens <= (others => '0'); -- Max time 59:59.99 reached, rollover
                                    else
                                        m_tens <= m_tens + 1;
                                    end if;
                                else
                                    m_ones <= m_ones + 1;
                                end if;
                            else
                                s_tens <= s_tens + 1;
                            end if;
                        else
                            s_ones <= s_ones + 1;
                        end if;
                    else
                        h_tens <= h_tens + 1;
                    end if;
                else
                    h_ones <= h_ones + 1;
                end if;
                
            end if;
        end if;
    end process;

    ------------------------------------------------------------------------
    -- Output Concatenation
    ------------------------------------------------------------------------
    -- Stitch the 6 individual 4-bit vectors together into one 24-bit bus
    time_out <= std_logic_vector(m_tens & m_ones & s_tens & s_ones & h_tens & h_ones);

end Behavioral;