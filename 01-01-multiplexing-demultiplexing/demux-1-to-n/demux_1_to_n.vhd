-- One-to-N, W-bit combinational demultiplexer.
-- Route 0 occupies the least-significant W output bits.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux_1_to_n is
    generic (
        N         : positive := 4;
        W         : positive := 8;
        SEL_WIDTH : positive range 1 to 30 := 2
    );
    port (
        din : in  std_logic_vector(W-1 downto 0);
        sel : in  std_logic_vector(SEL_WIDTH-1 downto 0);
        y   : out std_logic_vector(N*W-1 downto 0)
    );
end entity demux_1_to_n;

architecture rtl of demux_1_to_n is
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
        report "demux_1_to_n: SEL_WIDTH is too small for N"
        severity failure;

    process (din, sel)
        variable index_v : natural;
    begin
        y <= (others => '0');

        assert is_binary(sel)
            report "demux_1_to_n: sel is not binary"
            severity warning;

        if is_binary(sel) then
            index_v := to_integer(unsigned(sel));
            if index_v < N then
                y((index_v+1)*W-1 downto index_v*W) <= din;
            end if;
        end if;
    end process;
end architecture rtl;
