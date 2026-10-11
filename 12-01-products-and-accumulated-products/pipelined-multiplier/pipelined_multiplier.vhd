library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipelined_multiplier is
    generic (N : positive := 8);
    port (
        clk : in std_logic;
        a, b : in std_logic_vector(N-1 downto 0);
        product : out
            std_logic_vector(2*N-1 downto 0)
    );
end entity pipelined_multiplier;

architecture rtl of pipelined_multiplier is
    signal a_reg, b_reg : unsigned(N-1 downto 0);
    signal product_reg : unsigned(2*N-1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            a_reg <= unsigned(a);
            b_reg <= unsigned(b);
            product_reg <= a_reg * b_reg;
        end if;
    end process;

    product <= std_logic_vector(product_reg);
end architecture rtl;
