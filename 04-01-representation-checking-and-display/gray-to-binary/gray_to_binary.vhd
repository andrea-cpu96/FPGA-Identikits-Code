-- Reflected Gray code to binary with a prefix-XOR chain.
library ieee;
use ieee.std_logic_1164.all;

entity gray_to_binary is
    generic (W : positive := 4);
    port (
        gray_in    : in  std_logic_vector(W-1 downto 0);
        binary_out : out std_logic_vector(W-1 downto 0)
    );
end entity gray_to_binary;

architecture rtl of gray_to_binary is
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
    process (gray_in)
        variable decoded : std_logic_vector(W-1 downto 0);
    begin
        binary_out <= (others => '0');

        assert is_binary(gray_in)
            report "gray_to_binary: invalid input"
            severity warning;

        if is_binary(gray_in) then
            decoded(W-1) := gray_in(W-1);
            for i in W-2 downto 0 loop
                decoded(i) := decoded(i+1) xor gray_in(i);
            end loop;
            binary_out <= decoded;
        end if;
    end process;
end architecture rtl;
