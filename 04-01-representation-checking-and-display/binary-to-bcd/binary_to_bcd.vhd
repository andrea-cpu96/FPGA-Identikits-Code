library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_to_bcd is
    port (
        binary_in : in  std_logic_vector(7 downto 0);
        bcd_out   : out std_logic_vector(11 downto 0)
    );
end entity binary_to_bcd;

architecture rtl of binary_to_bcd is
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
    process (binary_in)
        variable digits : unsigned(11 downto 0);
        variable nibble : unsigned(3 downto 0);
    begin
        bcd_out <= (others => '0');
        assert is_binary(binary_in)
            report "binary_to_bcd: invalid input"
            severity warning;

        if is_binary(binary_in) then
            digits := (others => '0');
            for bit_index in binary_in'range loop
                for d in 0 to 2 loop
                    nibble := digits(4*d+3 downto 4*d);
                    if nibble > 4 then
                        digits(4*d+3 downto 4*d) :=
                            nibble + 3;
                    end if;
                end loop;
                digits := digits(10 downto 0) &
                          binary_in(bit_index);
            end loop;
            bcd_out <= std_logic_vector(digits);
        end if;
    end process;
end architecture rtl;
