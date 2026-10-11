-- Word storage; clock enable + sync active-high reset
-- d, en and rst must meet timing relative to clk.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_register_enable is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        rst : in  std_logic;
        en  : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register_enable;

architecture rtl of d_register_enable is
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= (others => '0');
            elsif en = '1' then
                q <= d;
            end if;
        end if;
    end process;

end architecture rtl;
