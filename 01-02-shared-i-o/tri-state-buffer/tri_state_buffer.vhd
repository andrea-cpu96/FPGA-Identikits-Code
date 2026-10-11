-- Top-level tri-state buffer for a bidirectional pad.
-- oe = '1' drives; every other value releases the pad.

library ieee;
use ieee.std_logic_1164.all;

entity tri_state_buffer is
    generic (
        W : positive := 8
    );
    port (
        data_out : in    std_logic_vector(W-1 downto 0);
        oe       : in    std_logic;
        pad      : inout std_logic_vector(W-1 downto 0);
        data_in  : out   std_logic_vector(W-1 downto 0)
    );
end entity tri_state_buffer;

architecture rtl of tri_state_buffer is
begin

    assert oe = '0' or oe = '1'
        report "tri_state_buffer: oe is not binary"
        severity warning;

    pad <= data_out when oe = '1' else
           (others => 'Z');

    data_in <= pad;

end architecture rtl;
