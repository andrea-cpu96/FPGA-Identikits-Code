-- Parallel load + enable-gated left shift; async reset.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_register_load_enable is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        d    : in  std_logic_vector(N-1 downto 0);
        si   : in  std_logic;
        load : in  std_logic;
        en   : in  std_logic;
        q    : out std_logic_vector(N-1 downto 0)
    );
end entity shift_register_load_enable;

architecture rtl of shift_register_load_enable is
    signal q_reg : std_logic_vector(N-1 downto 0);
begin
    process (clk, rst)
        variable next_q : std_logic_vector(N-1 downto 0);
    begin
        if rst = '1' then
            q_reg <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                q_reg <= d;
            elsif en = '1' then
                next_q := std_logic_vector(
                    shift_left(unsigned(q_reg), 1));
                next_q(0) := si;
                q_reg <= next_q;
            end if;
        end if;
    end process;
    q <= q_reg;
end architecture rtl;
