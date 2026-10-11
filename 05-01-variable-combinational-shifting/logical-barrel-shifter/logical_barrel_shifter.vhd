-- Variable logical shift; amounts of W or more give zero.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logical_barrel_shifter is
    generic (
        W     : positive := 8;
        AMT_W : positive := 4
    );
    port (
        d   : in  std_logic_vector(W-1 downto 0);
        amt : in  std_logic_vector(AMT_W-1 downto 0);
        dir : in  std_logic;
        q   : out std_logic_vector(W-1 downto 0)
    );
end entity logical_barrel_shifter;

architecture rtl of logical_barrel_shifter is
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
    process (d, amt, dir)
        variable count : natural;
    begin
        q <= (others => '0');
        assert is_binary(d & amt & dir)
            report "logical_barrel_shifter: invalid input"
            severity warning;

        if is_binary(d & amt & dir) then
            count := to_integer(unsigned(amt));
            if dir = '1' then
                q <= std_logic_vector(
                         shift_left(unsigned(d), count));
            else
                q <= std_logic_vector(
                         shift_right(unsigned(d), count));
            end if;
        end if;
    end process;
end architecture rtl;
