library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator is
    generic (N : positive := 8);
    port (
        clk, rst, en : in std_logic;
        din : in std_logic_vector(N-1 downto 0);
        sum : out std_logic_vector(N-1 downto 0)
    );
end entity accumulator;

architecture rtl of accumulator is
    signal acc : unsigned(N-1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                acc <= (others => '0');
            elsif en = '1' then
                acc <= acc + unsigned(din);
            end if;
        end if;
    end process;

    sum <= std_logic_vector(acc);
end architecture rtl;
