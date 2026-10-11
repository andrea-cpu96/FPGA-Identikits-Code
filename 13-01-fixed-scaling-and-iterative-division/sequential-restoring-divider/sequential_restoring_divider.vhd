library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sequential_restoring_divider is
    generic (N : positive := 8);
    port (
        clk, rst, start : in std_logic;
        a, b : in std_logic_vector(N-1 downto 0);
        q, r : out std_logic_vector(N-1 downto 0);
        busy, done : out std_logic
    );
end entity sequential_restoring_divider;

architecture rtl of sequential_restoring_divider is
    signal remainder_reg, quotient_reg, divisor_reg :
        unsigned(N-1 downto 0);
    signal count : natural range 0 to N;
    signal active, finished : std_logic;
begin
    process (clk)
        variable shifted, difference : unsigned(N downto 0);
    begin
        if rising_edge(clk) then
            finished <= '0';
            if rst = '1' then
                remainder_reg <= (others => '0');
                quotient_reg <= (others => '0');
                divisor_reg <= (others => '0');
                count <= 0;
                active <= '0';
            elsif active = '0' then
                if start = '1' then
                    remainder_reg <= (others => '0');
                    quotient_reg <= unsigned(a);
                    divisor_reg <= unsigned(b);
                    count <= N;
                    active <= '1';
                end if;
            else
                shifted := remainder_reg & quotient_reg(N-1);
                difference := shifted - ('0' & divisor_reg);
                quotient_reg <= shift_left(quotient_reg, 1);
                if difference(N) = '0' then
                    remainder_reg <= difference(N-1 downto 0);
                    quotient_reg(0) <= '1';
                else
                    remainder_reg <= shifted(N-1 downto 0);
                end if;
                count <= count - 1;
                if count = 1 then
                    active <= '0';
                    finished <= '1';
                end if;
            end if;
        end if;
    end process;
    q <= std_logic_vector(quotient_reg);
    r <= std_logic_vector(remainder_reg);
    busy <= active;
    done <= finished;
end architecture rtl;
