-- W-bit signed result: op = '0' adds, '1' subtracts.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_add_sub is
    generic (W : positive := 8);
    port (
        a, b   : in  std_logic_vector(W-1 downto 0);
        op     : in  std_logic;
        result : out std_logic_vector(W-1 downto 0);
        ovf    : out std_logic
    );
end entity signed_add_sub;

architecture rtl of signed_add_sub is
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
        variable r : signed(W-1 downto 0);
    begin
        result <= (others => '0');
        ovf    <= '0';
        assert is_binary(a) and is_binary(b)
               and (op = '0' or op = '1')
            report "signed_add_sub: invalid input"
            severity warning;
        if is_binary(a) and is_binary(b)
           and (op = '0' or op = '1') then
            if op = '0' then
                r := signed(a) + signed(b);
                ovf <= (a(W-1) xnor b(W-1))
                       and (r(W-1) xor a(W-1));
            else
                r := signed(a) - signed(b);
                ovf <= (a(W-1) xor b(W-1))
                       and (r(W-1) xor a(W-1));
            end if;
            result <= std_logic_vector(r);
        end if;
    end process;
end architecture rtl;
