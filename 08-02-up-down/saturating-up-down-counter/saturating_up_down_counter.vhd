library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity saturating_up_down_counter is
    generic (N : positive := 8);
    port (
        clk, rst : in  std_logic;
        en, dir  : in  std_logic;
        q        : out std_logic_vector(N-1 downto 0)
    );
end entity saturating_up_down_counter;

architecture rtl of saturating_up_down_counter is
    constant C_MAX : unsigned(N-1 downto 0) :=
        (others => '1');
    signal cnt : unsigned(N-1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= (others => '0');
            elsif en = '1' then
                if dir = '1' and cnt /= C_MAX then
                    cnt <= cnt + 1;
                elsif dir = '0' and cnt /= 0 then
                    cnt <= cnt - 1;
                end if;
            end if;
        end if;
    end process;
    q <= std_logic_vector(cnt);
end architecture rtl;
