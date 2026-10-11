-- Ring counter: one hot bit rotates toward lower indices.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ring_counter is
    generic (N : positive := 8);
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity ring_counter;

architecture rtl of ring_counter is
    signal q_reg : std_logic_vector(N-1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_reg <= (0 => '1', others => '0');
            else
                q_reg <= std_logic_vector(
                    rotate_right(unsigned(q_reg), 1));
            end if;
        end if;
    end process;

    q <= q_reg;
end architecture rtl;
