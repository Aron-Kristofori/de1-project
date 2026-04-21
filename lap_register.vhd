library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Needed for unsigned math (pointers)

entity lap_register is
    Port ( 
        clk     : in  std_logic;
        rst     : in  std_logic;
        
        -- Write interface (from Debounce & Stopwatch)
        lap_we  : in  std_logic;                      -- Write enable pulse
        time_in : in  std_logic_vector(23 downto 0);  -- 24-bit time from stopwatch
        
        -- Read interface (from FSM)
        lap_ptr : in  std_logic_vector(4 downto 0);   -- 5-bit read address (0 to 31)
        
        -- Output to display multiplexer
        time_out : out std_logic_vector(23 downto 0) 
    );
end lap_register;

architecture Behavioral of lap_register is

    -- 1. Define the Memory Array (32 slots of 24 bits)
    type t_memory is array (0 to 31) of std_logic_vector(23 downto 0);
    signal mem : t_memory := (others => (others => '0'));
    
    -- 2. Define the Internal Write Pointer
    signal write_ptr : unsigned(4 downto 0) := (others => '0');

begin

    ------------------------------------------------------------------------
    -- Fully Synchronous Process (Write and Read)
    ------------------------------------------------------------------------
    p_lap_memory : process(clk)
    begin
        -- Test of clock rising edge
        if rising_edge(clk) then
            
            -- Synchronous reset
            if rst = '1' then
                write_ptr <= (others => '0');
                mem       <= (others => (others => '0')); 
                time_out  <= (others => '0');
                
            else
                -- Synchronous Write: Save lap if button is pressed
                if lap_we = '1' then
                    mem(to_integer(write_ptr)) <= time_in;
                    write_ptr <= write_ptr + 1;
                end if;
                
                -- Synchronous Read: Always output the requested lap
                time_out <= mem(to_integer(unsigned(lap_ptr)));
                
            end if;
        end if;
    end process;

end Behavioral;