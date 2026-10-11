-- W-bit combinational equality comparator.
-- Invalid simulation values warn and force eq low.

library ieee;
use ieee.std_logic_1164.all;

entity equality_comparator is
    generic (
        W : positive := 8
    );
    port (
        a  : in  std_logic_vector(W-1 downto 0);
        b  : in  std_logic_vector(W-1 downto 0);
        eq : out std_logic
    );
end entity equality_comparator;

architecture rtl of equality_comparator is

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
        eq <= '0';

        assert is_binary(a) and is_binary(b)
            report "equality_comparator: invalid operand"
            severity warning;

        if is_binary(a) and is_binary(b) then
            if a = b then
                eq <= '1';
            end if;
        end if;
    end process;

end architecture rtl;
