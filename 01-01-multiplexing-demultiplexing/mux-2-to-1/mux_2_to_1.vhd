-- Two-input, W-bit combinational multiplexer.
-- sel = '0' selects d0; sel = '1' selects d1.

library ieee;
use ieee.std_logic_1164.all;

entity mux_2_to_1 is
    generic (
        W : positive := 8
    );
    port (
        d0  : in  std_logic_vector(W-1 downto 0);
        d1  : in  std_logic_vector(W-1 downto 0);
        sel : in  std_logic;
        y   : out std_logic_vector(W-1 downto 0)
    );
end entity mux_2_to_1;

architecture rtl of mux_2_to_1 is
begin

    assert sel = '0' or sel = '1'
        report "mux_2_to_1: sel is not binary"
        severity warning;

    with sel select
        y <= d0              when '0',
             d1              when '1',
             (others => '0') when others;

end architecture rtl;
