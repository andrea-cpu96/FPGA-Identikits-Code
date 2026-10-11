-- Hexadecimal digit to active-high abcdefg segments.
library ieee;
use ieee.std_logic_1164.all;

entity seven_segment_decoder is
    port (
        digit    : in  std_logic_vector(3 downto 0);
        segments : out std_logic_vector(6 downto 0)
    );
end entity seven_segment_decoder;

architecture rtl of seven_segment_decoder is
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
    process (digit)
    begin
        segments <= "0000000";

        assert is_binary(digit)
            report "seven_segment_decoder: invalid digit"
            severity warning;

        if is_binary(digit) then
            case digit is
                when x"0" => segments <= "1111110";
                when x"1" => segments <= "0110000";
                when x"2" => segments <= "1101101";
                when x"3" => segments <= "1111001";
                when x"4" => segments <= "0110011";
                when x"5" => segments <= "1011011";
                when x"6" => segments <= "1011111";
                when x"7" => segments <= "1110000";
                when x"8" => segments <= "1111111";
                when x"9" => segments <= "1111011";
                when x"A" => segments <= "1110111";
                when x"B" => segments <= "0011111";
                when x"C" => segments <= "1001110";
                when x"D" => segments <= "0111101";
                when x"E" => segments <= "1001111";
                when x"F" => segments <= "1000111";
                when others => null;
            end case;
        end if;
    end process;
end architecture rtl;
