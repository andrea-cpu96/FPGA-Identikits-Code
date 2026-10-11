-- Single-bit storage; rising-edge trigger; sync active-high reset
-- d and rst must meet timing relative to clk.

library ieee;
use ieee.std_logic_1164.all;

entity d_flip_flop is
    port (
        clk : in  std_logic;
        d   : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic
    );
end entity d_flip_flop;

architecture rtl of d_flip_flop is
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= '0';
            else
                q <= d;
            end if;
        end if;
    end process;

end architecture rtl;
