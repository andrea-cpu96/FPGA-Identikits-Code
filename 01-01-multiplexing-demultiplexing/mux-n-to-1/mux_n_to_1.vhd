-- N-input, W-bit combinational multiplexer.
-- d packs source 0 in its least-significant W bits.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_n_to_1 is
    generic (
        N         : positive := 4;
        W         : positive := 8;
        SEL_WIDTH : positive range 1 to 30 := 2
    );
    port (
        d   : in  std_logic_vector(N*W-1 downto 0);
        sel : in  std_logic_vector(SEL_WIDTH-1 downto 0);
        y   : out std_logic_vector(W-1 downto 0)
    );
end entity mux_n_to_1;

architecture rtl of mux_n_to_1 is

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

    assert N <= 2 ** SEL_WIDTH
        report "mux_n_to_1: SEL_WIDTH is too small for N"
        severity failure;

    process (d, sel)
        variable index_v : natural;
    begin
        y <= (others => '0');

        assert is_binary(sel)
            report "mux_n_to_1: sel is not binary"
            severity warning;

        if is_binary(sel) then
            index_v := to_integer(unsigned(sel));
            if index_v < N then
                y <= d((index_v+1)*W-1 downto index_v*W);
            end if;
        end if;
    end process;

end architecture rtl;
