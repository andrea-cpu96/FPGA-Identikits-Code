-- Even-parity generator and checker for one W-bit word.
library ieee;
use ieee.std_logic_1164.all;
entity parity_generator_checker is
    generic (W : positive := 8);
    port (
        data       : in  std_logic_vector(W-1 downto 0);
        parity_in  : in  std_logic;
        parity_out : out std_logic;
        error      : out std_logic
    );
end entity parity_generator_checker;
architecture rtl of parity_generator_checker is
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
    process (data, parity_in)
        variable generated : std_logic;
    begin
        parity_out <= '0';
        error      <= '0';
        assert is_binary(data)
            report "parity: invalid data"
            severity warning;
        assert parity_in = '0' or parity_in = '1'
            report "parity: invalid parity_in"
            severity warning;
        generated := '0';
        if is_binary(data) then
            for i in data'range loop
                generated := generated xor data(i);
            end loop;
            parity_out <= generated;
            if (parity_in = '0' or parity_in = '1') and
               generated /= parity_in then
                error <= '1';
            end if;
        end if;
    end process;
end architecture rtl;
