-- Word storage; no reset; power-up value from signal declaration
-- d must meet timing relative to clk.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_register_initial is
    port (
        clk : in  std_logic;
        d   : in  std_logic_vector(7 downto 0);
        q   : out std_logic_vector(7 downto 0)
    );
end entity d_register_initial;

architecture rtl of d_register_initial is

    -- Initializer on the internal signal, not on the port.
    signal q_r : std_logic_vector(7 downto 0) := (others => '0');

begin

    process (clk)
    begin
        if rising_edge(clk) then
            q_r <= d;
        end if;
    end process;

    q <= q_r;

end architecture rtl;
