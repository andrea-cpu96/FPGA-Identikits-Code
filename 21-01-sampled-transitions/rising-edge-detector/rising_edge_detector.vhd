library ieee;
use ieee.std_logic_1164.all;

entity rising_edge_detector is
    port (
        clk  : in  std_logic;
        d    : in  std_logic;
        rise : out std_logic
    );
end entity;

architecture rtl of rising_edge_detector is
    signal d_prev : std_logic := '0';
    signal rise_q : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            rise_q <= d and not d_prev;
            d_prev <= d;
        end if;
    end process;
    rise <= rise_q;
end architecture;
