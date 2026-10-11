-- W-bit combinational unsigned magnitude comparator.
-- Invalid simulation values warn and force all flags low.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity magnitude_comparator is
    generic (
        W : positive := 8
    );
    port (
        a  : in  std_logic_vector(W-1 downto 0);
        b  : in  std_logic_vector(W-1 downto 0);
        lt : out std_logic;
        eq : out std_logic;
        gt : out std_logic
    );
end entity magnitude_comparator;
architecture rtl of magnitude_comparator is
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
    process (a, b)
    begin
        lt <= '0';
        eq <= '0';
        gt <= '0';
        assert is_binary(a) and is_binary(b)
            report "magnitude_comparator: invalid operand"
            severity warning;
        if is_binary(a) and is_binary(b) then
            if unsigned(a) < unsigned(b) then
                lt <= '1';
            elsif unsigned(a) = unsigned(b) then
                eq <= '1';
            else
                gt <= '1';
            end if;
        end if;
    end process;
end architecture rtl;
