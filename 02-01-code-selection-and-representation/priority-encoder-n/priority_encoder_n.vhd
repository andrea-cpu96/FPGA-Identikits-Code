package priority_encoder_n_support is
    function index_width(n : positive) return positive;
end package;
package body priority_encoder_n_support is
    function index_width(n : positive) return positive is
        variable remaining : natural := n - 1;
        variable width_v : natural := 0;
    begin
        while remaining > 0 loop
            width_v := width_v + 1;
            remaining := remaining / 2;
        end loop;
        if width_v = 0 then return 1; end if;
        return width_v;
    end function;
end package body;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.priority_encoder_n_support.all;
entity priority_encoder_n is
    generic (N : positive range 1 to 1073741824 := 8);
    port (
        d     : in  std_logic_vector(N-1 downto 0);
        y     : out std_logic_vector(index_width(N)-1 downto 0);
        valid : out std_logic
    );
end entity;
architecture rtl of priority_encoder_n is
    function is_binary(v : std_logic_vector) return boolean is
    begin
        for i in v'range loop
            if v(i) /= '0' and v(i) /= '1' then
                return false;
            end if;
        end loop;
        return true;
    end function;
begin
    process (d)
    begin
        y <= (others => '0'); valid <= '0';
        assert is_binary(d)
            report "priority_encoder_n: d is not binary"
            severity warning;
        if is_binary(d) then
            for i in d'range loop
                if d(i) = '1' then
                    y <= std_logic_vector(to_unsigned(i, y'length));
                    valid <= '1';
                    exit;
                end if;
            end loop;
        end if;
    end process;
end architecture;
