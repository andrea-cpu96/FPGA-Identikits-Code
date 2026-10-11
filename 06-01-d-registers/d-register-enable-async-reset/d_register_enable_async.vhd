-- Word storage; clock enable + async active-high reset
-- d and en must meet timing relative to clk.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_register_enable_async is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register_enable_async;

architecture rtl of d_register_enable_async is
begin

    process (clk, rst)
    begin
        if rst = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                q <= d;
            end if;
        end if;
    end process;

end architecture rtl;
