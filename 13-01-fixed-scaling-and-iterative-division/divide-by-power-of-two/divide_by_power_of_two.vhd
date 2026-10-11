library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divide_by_power_of_two is
    generic (
        N : positive := 8;
        K : natural := 1
    );
    port (
        a : in  std_logic_vector(N-1 downto 0);
        q : out std_logic_vector(N-1 downto 0)
    );
end entity divide_by_power_of_two;

architecture rtl of divide_by_power_of_two is
begin
    q <= std_logic_vector(shift_right(unsigned(a), K));
end architecture rtl;
