-- Three-to-eight active-high one-hot decoder.
-- Code i asserts y(i); invalid simulation values drive zero.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_3_to_8 is
    port (
        sel : in  std_logic_vector(2 downto 0);
        y   : out std_logic_vector(7 downto 0)
    );
end entity decoder_3_to_8;

architecture rtl of decoder_3_to_8 is

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

    process (sel)
    begin
        y <= (others => '0');

        assert is_binary(sel)
            report "decoder_3_to_8: sel is not binary"
            severity warning;

        if is_binary(sel) then
            y(to_integer(unsigned(sel))) <= '1';
        end if;
    end process;

end architecture rtl;
