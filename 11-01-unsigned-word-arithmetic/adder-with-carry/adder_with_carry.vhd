-- W-bit unsigned addition with carry-in and carry-out.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_with_carry is
    generic (W : positive := 8);
    port (
        a, b : in  std_logic_vector(W-1 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(W-1 downto 0);
        cout : out std_logic
    );
end entity adder_with_carry;

architecture rtl of adder_with_carry is
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
    process (a, b, cin)
        variable wide : unsigned(W downto 0);
    begin
        sum  <= (others => '0');
        cout <= '0';
        assert is_binary(a) and is_binary(b)
               and (cin = '0' or cin = '1')
            report "adder_with_carry: invalid input"
            severity warning;
        if is_binary(a) and is_binary(b)
           and (cin = '0' or cin = '1') then
            wide := ('0' & unsigned(a))
                  + ('0' & unsigned(b));
            if cin = '1' then
                wide := wide + 1;
            end if;
            sum  <= std_logic_vector(wide(W-1 downto 0));
            cout <= wide(W);
        end if;
    end process;
end architecture rtl;
