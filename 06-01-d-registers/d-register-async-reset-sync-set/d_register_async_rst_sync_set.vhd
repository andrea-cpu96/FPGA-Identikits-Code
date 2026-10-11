-- Async reset (immediate priority) + sync set (loads all ones)
-- d and set must meet timing relative to clk.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_register_async_rst_sync_set is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        set : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register_async_rst_sync_set;

architecture rtl of d_register_async_rst_sync_set is
begin

    process (clk, rst)
    begin
        if rst = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if set = '1' then
                q <= (others => '1');
            else
                q <= d;
            end if;
        end if;
    end process;

end architecture rtl;
