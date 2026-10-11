-- Single-bit toggle on edge while t high; sync active-high reset
-- Internal state avoids reading an out port in earlier VHDL revisions.
-- Inputs t and rst must meet timing relative to clk.

library ieee;
use ieee.std_logic_1164.all;

entity t_flip_flop is
    port (
        clk : in  std_logic;
        t   : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic
    );
end entity t_flip_flop;

architecture rtl of t_flip_flop is

    signal state : std_logic;

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= '0';
            elsif t = '1' then
                state <= not state;
            end if;
        end if;
    end process;

    q <= state;

end architecture rtl;
