library ieee;
use ieee.std_logic_1164.all;

entity falling_edge_detector is
    port (
        clk  : in  std_logic;
        d    : in  std_logic;
        fall : out std_logic
    );
end entity;

architecture rtl of falling_edge_detector is
    signal d_prev : std_logic := '0';
    signal fall_q : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            fall_q <= (not d) and d_prev;
            d_prev <= d;
        end if;
    end process;
    fall <= fall_q;
end architecture;
