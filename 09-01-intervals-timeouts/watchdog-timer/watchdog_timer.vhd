library ieee;
use ieee.std_logic_1164.all;

entity watchdog_timer is
    generic (
        TIMEOUT : integer range 2 to integer'high := 1000
    );
    port (
        clk, rst : in  std_logic;
        arm      : in  std_logic;
        kick     : in  std_logic;
        armed    : out std_logic;
        expired  : out std_logic
    );
end entity watchdog_timer;

architecture rtl of watchdog_timer is
    signal cnt         : natural range 0 to TIMEOUT - 1;
    signal armed_reg   : std_logic;
    signal expired_reg : std_logic;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt         <= TIMEOUT - 1;
                armed_reg   <= '0';
                expired_reg <= '0';
            elsif armed_reg = '0' then
                if arm = '1' then
                    cnt       <= TIMEOUT - 1;
                    armed_reg <= '1';
                end if;
            elsif expired_reg = '0' then
                if cnt = 0 then
                    expired_reg <= '1';
                elsif kick = '1' then
                    cnt <= TIMEOUT - 1;
                else
                    cnt <= cnt - 1;
                end if;
            end if;
        end if;
    end process;
    armed   <= armed_reg;
    expired <= expired_reg;
end architecture rtl;
