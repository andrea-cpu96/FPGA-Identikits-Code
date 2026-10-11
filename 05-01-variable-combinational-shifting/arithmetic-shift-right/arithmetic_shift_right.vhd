-- Variable arithmetic right shift: the original MSB fills.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arithmetic_shift_right is
    generic (W : positive := 8);
    port (
        d   : in  std_logic_vector(W-1 downto 0);
        amt : in  natural range 0 to W-1;
        q   : out std_logic_vector(W-1 downto 0)
    );
end entity arithmetic_shift_right;

architecture rtl of arithmetic_shift_right is
    function is_binary(v : std_logic_vector)
        return boolean is
    begin
        for i in v'range loop
            if v(i) /= '0' and v(i) /= '1' then
                return false;
            end if;
        end loop;
        return true;
    end function;
begin
    process (d, amt)
    begin
        q <= (others => '0');

        assert is_binary(d)
            report "arithmetic_shift_right: invalid data"
            severity warning;

        if is_binary(d) then
            q <= std_logic_vector(
                     shift_right(signed(d), amt));
        end if;
    end process;
end architecture rtl;
