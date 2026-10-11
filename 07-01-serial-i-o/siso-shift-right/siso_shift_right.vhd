-- SISO shift right: din enters q(N-1), dout is q(0).
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity siso_shift_right is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        din  : in  std_logic;
        dout : out std_logic
    );
end entity siso_shift_right;

architecture rtl of siso_shift_right is
    signal q : std_logic_vector(N-1 downto 0);
begin
    process (clk)
        variable next_q : std_logic_vector(N-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= (others => '0');
            else
                next_q := std_logic_vector(
                    shift_right(unsigned(q), 1));
                next_q(N-1) := din;
                q <= next_q;
            end if;
        end if;
    end process;

    dout <= q(0);
end architecture rtl;
