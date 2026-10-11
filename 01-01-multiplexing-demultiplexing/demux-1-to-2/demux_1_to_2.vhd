-- One-to-two, W-bit combinational demultiplexer.
-- The selected output follows din; the other output is zero.

library ieee;
use ieee.std_logic_1164.all;

entity demux_1_to_2 is
    generic (
        W : positive := 8
    );
    port (
        din : in  std_logic_vector(W-1 downto 0);
        sel : in  std_logic;
        y0  : out std_logic_vector(W-1 downto 0);
        y1  : out std_logic_vector(W-1 downto 0)
    );
end entity demux_1_to_2;

architecture rtl of demux_1_to_2 is
begin

    assert sel = '0' or sel = '1'
        report "demux_1_to_2: sel is not binary"
        severity warning;

    process (din, sel)
    begin
        y0 <= (others => '0');
        y1 <= (others => '0');

        case sel is
            when '0'    => y0 <= din;
            when '1'    => y1 <= din;
            when others => null;
        end case;
    end process;

end architecture rtl;
