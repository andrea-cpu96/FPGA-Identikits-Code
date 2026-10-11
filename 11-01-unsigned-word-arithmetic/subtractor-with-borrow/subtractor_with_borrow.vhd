-- W-bit unsigned subtraction; borrow is high for a < b.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor_with_borrow is
    generic (W : positive := 8);
    port (
        a, b   : in  std_logic_vector(W-1 downto 0);
        diff   : out std_logic_vector(W-1 downto 0);
        borrow : out std_logic
    );
end entity subtractor_with_borrow;

architecture rtl of subtractor_with_borrow is
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
        variable wide : unsigned(W downto 0);
    begin
        diff   <= (others => '0');
        borrow <= '0';
        assert is_binary(a) and is_binary(b)
            report "subtractor_with_borrow: invalid input"
            severity warning;
        if is_binary(a) and is_binary(b) then
            wide := ('0' & unsigned(a))
                  - ('0' & unsigned(b));
            diff   <= std_logic_vector(wide(W-1 downto 0));
            borrow <= wide(W);
        end if;
    end process;
end architecture rtl;
