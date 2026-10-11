library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity free_running_tick_generator is
    generic (
        N       : positive range 1 to 30 := 8;
        TIMEOUT : positive := 10
    );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        tick : out std_logic
    );
end entity free_running_tick_generator;

architecture rtl of free_running_tick_generator is
    signal cnt      : unsigned(N-1 downto 0);
    signal tick_reg : std_logic;
begin
    assert TIMEOUT <= 2 ** N
        report "tick_generator: TIMEOUT too large"
        severity failure;

    process (clk)
    begin
        if rising_edge(clk) then
            tick_reg <= '0';
            if rst = '1' then
                cnt <= (others => '0');
            elsif cnt >= TIMEOUT - 1 then
                cnt <= (others => '0');
                tick_reg <= '1';
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    tick <= tick_reg;
end architecture rtl;
