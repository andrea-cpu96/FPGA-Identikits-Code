library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity up_down_counter is
    generic (N : positive := 8);
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        dir : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity up_down_counter;

architecture rtl of up_down_counter is
    signal cnt : unsigned(N-1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= (others => '0');
            elsif dir = '1' then
                cnt <= cnt + 1;
            elsif dir = '0' then
                cnt <= cnt - 1;
            else
                assert false report
                    "up_down_counter: invalid dir"
                    severity warning;
            end if;
        end if;
    end process;
    q <= std_logic_vector(cnt);
end architecture rtl;
