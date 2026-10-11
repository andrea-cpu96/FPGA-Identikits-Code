-- Single-bit hold/set/reset/toggle on j,k; sync active-high reset
-- Internal state avoids reading an out port in earlier VHDL revisions.
-- Inputs j, k and rst must meet timing relative to clk.

library ieee;
use ieee.std_logic_1164.all;

entity jk_flip_flop is
    port (
        clk : in  std_logic;
        j   : in  std_logic;
        k   : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic
    );
end entity jk_flip_flop;

architecture rtl of jk_flip_flop is

    signal state : std_logic;

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= '0';
            elsif j = '1' and k = '1' then
                state <= not state;
            elsif j = '1' then
                state <= '1';
            elsif k = '1' then
                state <= '0';
            end if;
        end if;
    end process;

    q <= state;

end architecture rtl;
