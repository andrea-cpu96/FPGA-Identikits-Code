-- Word storage; rising-edge trigger; no reset
-- d must meet timing relative to clk.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_register is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register;

architecture rtl of d_register is
begin

    process (clk)
    begin
        if rising_edge(clk) then
            q <= d;
        end if;
    end process;

end architecture rtl;
