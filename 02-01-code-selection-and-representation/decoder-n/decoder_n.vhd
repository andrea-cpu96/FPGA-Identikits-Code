package decoder_n_support is
    function index_width(n : positive) return positive;
end package;
package body decoder_n_support is
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
use work.decoder_n_support.all;
entity decoder_n is
    generic (N : positive range 1 to 1073741824 := 8);
    port (
        sel : in  std_logic_vector(index_width(N)-1 downto 0);
        y   : out std_logic_vector(N-1 downto 0)
    );
end entity;
architecture rtl of decoder_n is
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
    process (sel)
        variable index_v : natural;
    begin
        y <= (others => '0');
        assert is_binary(sel)
            report "decoder_n: sel is not binary" severity warning;
        if is_binary(sel) then
            index_v := to_integer(unsigned(sel));
            if index_v < N then y(index_v) <= '1'; end if;
        end if;
    end process;
end architecture;
