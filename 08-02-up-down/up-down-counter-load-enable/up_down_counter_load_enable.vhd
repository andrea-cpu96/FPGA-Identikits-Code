library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_down_counter_load_enable is
    generic (N : positive := 8);
    port (
        clk, rst : in  std_logic;
        load, en : in  std_logic;
        dir      : in  std_logic;
        d        : in  std_logic_vector(N-1 downto 0);
        q        : out std_logic_vector(N-1 downto 0)
    );
end entity up_down_counter_load_enable;

architecture rtl of up_down_counter_load_enable is
    signal cnt : unsigned(N-1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= (others => '0');
            elsif load = '1' then
                cnt <= unsigned(d);
            elsif en = '1' then
                if dir = '1' then
                    cnt <= cnt + 1;
                elsif dir = '0' then
                    cnt <= cnt - 1;
                else
                    assert false report "invalid dir"
                        severity warning;
                end if;
            end if;
        end if;
    end process;
    q <= std_logic_vector(cnt);
end architecture rtl;
