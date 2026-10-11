-- Binary to reflected Gray code: g = b xor (b >> 1).
library ieee;
use ieee.std_logic_1164.all;

entity binary_to_gray is
    generic (W : positive := 4);
    port (
        binary_in : in  std_logic_vector(W-1 downto 0);
        gray_out  : out std_logic_vector(W-1 downto 0)
    );
end entity binary_to_gray;

architecture rtl of binary_to_gray is
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
    begin
        gray_out <= (others => '0');

        assert is_binary(binary_in)
            report "binary_to_gray: invalid input"
            severity warning;

        if is_binary(binary_in) then
            gray_out <= binary_in xor
                        ('0' & binary_in(W-1 downto 1));
        end if;
    end process;
end architecture rtl;
