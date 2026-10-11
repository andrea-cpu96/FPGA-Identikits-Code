-- Single-bit set/reset on s,r; sync active-high reset
-- s = r = '1' is illegal: no branch fires, q holds. Avoid it.

library ieee;
use ieee.std_logic_1164.all;

entity sr_flip_flop is
    port (
        clk : in  std_logic;
        s   : in  std_logic;
        r   : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic
    );
end entity sr_flip_flop;

architecture rtl of sr_flip_flop is
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= '0';
            elsif s = '1' and r = '0' then
                q <= '1';
            elsif r = '1' and s = '0' then
                q <= '0';
            end if;
        end if;
    end process;

end architecture rtl;
