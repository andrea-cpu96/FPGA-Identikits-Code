-- W-bit unsigned result: op = '0' adds, '1' subtracts.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_subtractor is
    generic (W : positive := 8);
    port (
        a, b   : in  std_logic_vector(W-1 downto 0);
        op     : in  std_logic;
        result : out std_logic_vector(W-1 downto 0)
    );
end entity adder_subtractor;

architecture rtl of adder_subtractor is
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
    process (a, b, op)
    begin
        result <= (others => '0');
        assert is_binary(a) and is_binary(b)
               and (op = '0' or op = '1')
            report "adder_subtractor: invalid input"
            severity warning;
        if is_binary(a) and is_binary(b)
           and (op = '0' or op = '1') then
            if op = '0' then
                result <= std_logic_vector(
                    unsigned(a) + unsigned(b));
            else
                result <= std_logic_vector(
                    unsigned(a) - unsigned(b));
            end if;
        end if;
    end process;
end architecture rtl;
