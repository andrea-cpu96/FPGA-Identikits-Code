-- Eight-to-three priority encoder; d(7) has highest priority.
-- Invalid simulation values produce valid = '0' and y = zero.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity priority_encoder_8_to_3 is
    port (
        d     : in  std_logic_vector(7 downto 0);
        y     : out std_logic_vector(2 downto 0);
        valid : out std_logic
    );
end entity priority_encoder_8_to_3;

architecture rtl of priority_encoder_8_to_3 is

    function is_binary(value : std_logic_vector) return boolean is
    begin
        for i in value'range loop
            if value(i) /= '0' and value(i) /= '1' then
                return false;
            end if;
        end loop;
        return true;
    end function;

begin

    process (d)
    begin
        y     <= (others => '0');
        valid <= '0';

        assert is_binary(d)
            report "priority_encoder_8_to_3: d is not binary"
            severity warning;

        if is_binary(d) then
            for i in d'range loop
                if d(i) = '1' then
                    y <= std_logic_vector(
                        to_unsigned(i, y'length));
                    valid <= '1';
                    exit;
                end if;
            end loop;
        end if;
    end process;

end architecture rtl;
