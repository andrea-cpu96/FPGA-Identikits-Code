library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiply_accumulate is
    generic (
        N     : positive := 8;
        ACC_W : positive := 2*N
    );
    port (
        clk, rst, en : in std_logic;
        a, b : in std_logic_vector(N-1 downto 0);
        result : out
            std_logic_vector(ACC_W-1 downto 0)
    );
end entity multiply_accumulate;

architecture rtl of multiply_accumulate is
    signal acc : unsigned(ACC_W-1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                acc <= (others => '0');
            elsif en = '1' then
                acc <= acc + resize(
                    unsigned(a) * unsigned(b), ACC_W);
            end if;
        end if;
    end process;

    result <= std_logic_vector(acc);
end architecture rtl;
