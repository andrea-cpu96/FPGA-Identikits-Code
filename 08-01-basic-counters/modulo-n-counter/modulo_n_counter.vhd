library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity modulo_n_counter is
    generic (
        N       : positive range 1 to 30 := 8;
        MOD_VAL : positive := 10
    );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity modulo_n_counter;

architecture rtl of modulo_n_counter is
    signal cnt : unsigned(N-1 downto 0);
begin
    assert MOD_VAL >= 2 and MOD_VAL <= 2 ** N
        report "modulo_n_counter: invalid MOD_VAL"
        severity failure;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or cnt >= MOD_VAL - 1 then
                cnt <= (others => '0');
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    q <= std_logic_vector(cnt);
end architecture rtl;
