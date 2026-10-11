-- Variable rotate right; amt is always in the legal range.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter is
    generic (W : positive := 8);
    port (
        d   : in  std_logic_vector(W-1 downto 0);
        amt : in  natural range 0 to W-1;
        q   : out std_logic_vector(W-1 downto 0)
    );
end entity barrel_shifter;

architecture rtl of barrel_shifter is
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
            report "barrel_shifter: invalid data"
            severity warning;

        if is_binary(d) then
            q <= std_logic_vector(
                     rotate_right(unsigned(d), amt));
        end if;
    end process;
end architecture rtl;
