-- Eight-bit one-hot to three-bit binary encoder.
-- Valid only for exactly one literal '1'; invalid states drive zero.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity one_hot_to_binary_8_to_3 is
    port (
        onehot : in  std_logic_vector(7 downto 0);
        bin    : out std_logic_vector(2 downto 0);
        valid  : out std_logic
    );
end entity one_hot_to_binary_8_to_3;

architecture rtl of one_hot_to_binary_8_to_3 is
    function is_one_hot(value : std_logic_vector) return boolean is
        variable found_one : boolean := false;
    begin
        for i in value'range loop
            if value(i) = '1' then
                if found_one then
                    return false;
                end if;
                found_one := true;
            elsif value(i) /= '0' then
                return false;
            end if;
        end loop;
        return found_one;
end function;
begin
    process (onehot)
    begin
        bin   <= (others => '0');
        valid <= '0';

        assert is_one_hot(onehot)
            report "one_hot_to_binary_8_to_3: not one-hot"
            severity warning;

        if is_one_hot(onehot) then
            valid <= '1';
            for i in onehot'range loop
                if onehot(i) = '1' then
                    bin <= std_logic_vector(
                        to_unsigned(i, bin'length));
                end if;
            end loop;
        end if;
    end process;

end architecture rtl;
