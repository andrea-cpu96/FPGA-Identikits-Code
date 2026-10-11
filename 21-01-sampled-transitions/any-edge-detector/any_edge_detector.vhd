library ieee;
use ieee.std_logic_1164.all;

entity any_edge_detector is
    port (
        clk        : in  std_logic;
        d          : in  std_logic;
        edge_pulse : out std_logic
    );
end entity;

architecture rtl of any_edge_detector is
    signal d_prev : std_logic := '0';
    signal edge_q : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            edge_q <= d xor d_prev;
            d_prev <= d;
        end if;
    end process;
    edge_pulse <= edge_q;
end architecture;
