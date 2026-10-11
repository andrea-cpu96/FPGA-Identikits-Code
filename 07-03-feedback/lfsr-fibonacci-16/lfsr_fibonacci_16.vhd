-- Fibonacci LFSR: x^16 + x^14 + x^13 + x^11 + 1.
library ieee;
use ieee.std_logic_1164.all;

entity lfsr_fibonacci_16 is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(15 downto 0)
    );
end entity lfsr_fibonacci_16;

architecture rtl of lfsr_fibonacci_16 is
    signal q_reg : std_logic_vector(15 downto 0);
    signal fb    : std_logic;
begin
    fb <= q_reg(0) xor q_reg(2) xor
          q_reg(3) xor q_reg(5);

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_reg <= x"0001";
            else
                q_reg <= fb & q_reg(15 downto 1);
            end if;
        end if;
    end process;

    q <= q_reg;
end architecture rtl;
