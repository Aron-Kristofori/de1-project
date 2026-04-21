----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.04.2026 08:56:04
-- Design Name: 
-- Module Name: ctrl_fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ctrl_fsm is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           up : in STD_LOGIC;
           down : in STD_LOGIC;
           lap_ptr : out STD_LOGIC_VECTOR (3 downto 0);
           cnt_en : out STD_LOGIC);
end ctrl_fsm;

architecture Behavioral of ctrl_fsm is

type ctrl_state is (STOPPED, RUNNING);
signal current_state : ctrl_state;
signal cnt_lap : integer range 0 to 9 := 0;

begin

    p_control : process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                -- Reset state
                current_state <= STOPPED;
                lap_ptr <= "0000";
                cnt_en <= '0';
            elsif start = '1' then
                case current_state is
                    when STOPPED =>
                        cnt_en <= '1';
                        current_state <= RUNNING;
                    when RUNNING =>
                        cnt_en <= '0';
                        current_state <= STOPPED;
                    when others =>
                        cnt_en <= '0';
                        current_state <= STOPPED;
                 end case;
            elsif up = '1' then
                cnt_lap <= cnt_lap + 1;
            elsif down = '1' then
                cnt_lap <= cnt_lap - 1;
            end if;
         end if;
    end process p_control;   
    lap_ptr <= STD_LOGIC_VECTOR(to_unsigned(cnt_lap, 4));
end Behavioral;
