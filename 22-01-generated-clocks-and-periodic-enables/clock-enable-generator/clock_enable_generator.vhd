library ieee;
use ieee.std_logic_1164.all;

entity clock_enable_generator is
    generic (
        DIV : positive := 4
    );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        tick : out std_logic
    );
end entity;

architecture rtl of clock_enable_generator is
    signal cnt    : natural range 0 to DIV - 1;
    signal tick_q : std_logic;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= 0;
                tick_q <= '0';
            elsif cnt = DIV - 1 then
                cnt <= 0;
                tick_q <= '1';
            else
                cnt <= cnt + 1;
                tick_q <= '0';
            end if;
        end if;
    end process;
    tick <= tick_q;
end architecture;
