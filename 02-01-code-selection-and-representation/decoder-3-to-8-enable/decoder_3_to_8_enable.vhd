-- Three-to-eight one-hot decoder with active-high enable.
-- Disabled and invalid simulation states drive all outputs low.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_3_to_8_enable is
    port (
        sel : in  std_logic_vector(2 downto 0);
        en  : in  std_logic;
        y   : out std_logic_vector(7 downto 0)
    );
end entity decoder_3_to_8_enable;

architecture rtl of decoder_3_to_8_enable is
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
    process (sel, en)
    begin
        y <= (others => '0');

        assert en = '0' or en = '1'
            report "decoder_3_to_8_enable: en is not binary"
            severity warning;

        if en = '1' then
            assert is_binary(sel)
                report "decoder_3_to_8_enable: sel is not binary"
                severity warning;

            if is_binary(sel) then
                y(to_integer(unsigned(sel))) <= '1';
            end if;
        end if;
    end process;

end architecture rtl;
