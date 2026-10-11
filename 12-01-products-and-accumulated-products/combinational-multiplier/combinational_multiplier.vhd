library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity combinational_multiplier is
    generic (
        A_W : positive := 8;
        B_W : positive := 8
    );
    port (
        a : in std_logic_vector(A_W-1 downto 0);
        b : in std_logic_vector(B_W-1 downto 0);
        product : out
            std_logic_vector(A_W+B_W-1 downto 0)
    );
end entity combinational_multiplier;

architecture rtl of combinational_multiplier is
begin
    product <= std_logic_vector(
        unsigned(a) * unsigned(b));
end architecture rtl;
