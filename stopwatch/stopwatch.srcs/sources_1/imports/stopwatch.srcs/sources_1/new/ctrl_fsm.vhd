library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ctrl_fsm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           -- Button inputs
           start : in STD_LOGIC;
           up : in STD_LOGIC;
           down : in STD_LOGIC;
           -- Points to index of memory array with stored times in lap_register
           lap_ptr : out STD_LOGIC_VECTOR (3 downto 0) := "0000";
           -- Signal to turn on the stopwatch module
           cnt_en : out STD_LOGIC := '0');
end ctrl_fsm;

architecture Behavioral of ctrl_fsm is

type ctrl_state is (STOPPED, RUNNING); -- STOPPED: cnt_en is '0' and stopwatch isnt counting | RUNNING: cnt_en is '1', stopwatch running
signal current_state : ctrl_state := STOPPED;

begin

    p_control : process (clk)
    variable cnt_lap : integer := 0;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Reset state
                current_state <= STOPPED;
                lap_ptr <= "0000";
                cnt_en <= '0';
            elsif start = '1' then
                case current_state is
                    when STOPPED => -- turn on the stopwatch
                        cnt_en <= '1';
                        current_state <= RUNNING;
                    when RUNNING => -- turn off the stopwatch
                        cnt_en <= '0';
                        current_state <= STOPPED;
                    when others => -- catch all state
                        cnt_en <= '0';
                        current_state <= STOPPED;
                 end case;
            -- logic for browsing saved laps 
            elsif up = '1' then
                cnt_lap := cnt_lap + 1;
                if cnt_lap > 9 then
                    cnt_lap := 0;
                    end if;
            elsif down = '1' then
                cnt_lap := cnt_lap - 1;
                if cnt_lap < 0 then
                    cnt_lap := 9;
                    end if;
            end if;
         end if;
         lap_ptr <= std_logic_vector(to_unsigned(cnt_lap, 4)); 
    end process p_control;   
    
end Behavioral;
