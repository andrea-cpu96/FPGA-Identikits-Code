library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_code_counter is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        gray : out std_logic_vector(N-1 downto 0)
    );
end entity gray_code_counter;

architecture rtl of gray_code_counter is
    signal bin      : unsigned(N-1 downto 0);
    signal gray_reg : std_logic_vector(N-1 downto 0);
begin
    process (clk)
        variable next_bin : unsigned(N-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                bin <= (others => '0');
                gray_reg <= (others => '0');
            else
                next_bin := bin + 1;
                bin <= next_bin;
                gray_reg <= std_logic_vector(
                    next_bin xor shift_right(next_bin, 1));
            end if;
        end if;
    end process;

    gray <= gray_reg;
end architecture rtl;
