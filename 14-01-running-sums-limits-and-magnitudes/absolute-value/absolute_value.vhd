library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity absolute_value is
    generic (N : positive := 8);
    port (
        a : in std_logic_vector(N-1 downto 0);
        absval : out std_logic_vector(N-1 downto 0)
    );
end entity absolute_value;

architecture rtl of absolute_value is
    signal input_wide, magnitude_wide : signed(N downto 0);
begin
    input_wide <= resize(signed(a), N+1);
    magnitude_wide <= abs(input_wide);
    absval <= std_logic_vector(magnitude_wide(N-1 downto 0));
end architecture rtl;
