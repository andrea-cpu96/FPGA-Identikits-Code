package popcount_width is
    function count_width(max_count : positive)
        return positive;
end package popcount_width;
package body popcount_width is
    function count_width(max_count : positive)
        return positive is
        variable remaining : natural := max_count;
        variable bits     : natural := 0;
    begin
        while remaining > 0 loop
            bits := bits + 1;
            remaining := remaining / 2;
        end loop;
        return bits;
    end function;
end package body popcount_width;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.popcount_width.all;
entity population_count is
    generic (W : positive := 8);
    port (
        data_in   : in  std_logic_vector(W-1 downto 0);
        count_out : out unsigned(count_width(W)-1 downto 0)
    );
end entity population_count;
architecture rtl of population_count is
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
    process (data_in)
        variable total : unsigned(count_width(W)-1 downto 0);
    begin
        total := (others => '0');
        assert is_binary(data_in)
            report "population_count: invalid input"
            severity warning;
        if is_binary(data_in) then
            for i in data_in'range loop
                if data_in(i) = '1' then
                    total := total + 1;
                end if;
            end loop;
        end if;
        count_out <= total;
    end process;
end architecture rtl;
