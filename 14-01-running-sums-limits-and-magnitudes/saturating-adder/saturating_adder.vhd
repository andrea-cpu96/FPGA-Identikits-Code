library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity saturating_adder is
    generic (N : positive := 8);
    port (
        a, b : in std_logic_vector(N-1 downto 0);
        sum : out std_logic_vector(N-1 downto 0)
    );
end entity saturating_adder;

architecture rtl of saturating_adder is
    signal wide_sum : unsigned(N downto 0);
begin
    wide_sum <= ('0' & unsigned(a))
              + ('0' & unsigned(b));

    sum <= (others => '1') when wide_sum(N) = '1'
        else std_logic_vector(wide_sum(N-1 downto 0));
end architecture rtl;
