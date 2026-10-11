-- After edge m settles, tap k holds x[m-k].
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity variable_length_delay_line is
    generic (
        N         : positive := 8;
        SEL_WIDTH : positive range 1 to 30 := 3
    );
    port (
        clk, rst, din : in  std_logic;
        sel  : in  std_logic_vector(SEL_WIDTH-1 downto 0);
        dout : out std_logic
    );
end entity variable_length_delay_line;

architecture rtl of variable_length_delay_line is
    signal q_reg : std_logic_vector(N-1 downto 0);
begin
    assert N <= 2 ** SEL_WIDTH
        report "delay_line: SEL_WIDTH too small" severity failure;

    process (clk)
        variable next_q : std_logic_vector(N-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_reg <= (others => '0');
            else
                next_q := std_logic_vector(shift_left(
                    unsigned(q_reg), 1));
                next_q(0) := din;
                q_reg <= next_q;
            end if;
        end if;
    end process;

    process (q_reg, sel)
        variable index_v : natural;
    begin
        dout <= '0';
        if not is_x(sel) then
            index_v := to_integer(unsigned(sel));
            if index_v < N then
                dout <= q_reg(index_v);
            else
                assert false report "delay_line: sel out of range"
                    severity warning;
            end if;
        else
            assert false report "delay_line: sel is not binary"
                severity warning;
        end if;
    end process;
end architecture rtl;
