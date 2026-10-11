-- SISO shift left: din enters q(0), dout is q(N-1).
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity siso_shift_left is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        din  : in  std_logic;
        dout : out std_logic
    );
end entity siso_shift_left;

architecture rtl of siso_shift_left is
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
                    shift_left(unsigned(q), 1));
                next_q(0) := din;
                q <= next_q;
            end if;
        end if;
    end process;

    dout <= q(N-1);
end architecture rtl;
