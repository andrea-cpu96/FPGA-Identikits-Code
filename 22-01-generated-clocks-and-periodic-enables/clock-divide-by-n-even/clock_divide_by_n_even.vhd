library ieee;
use ieee.std_logic_1164.all;

entity clock_divide_by_n_even is
    generic (
        DIV : natural range 2 to integer'high := 6
    );
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        clk_div : out std_logic
    );
end entity;

architecture rtl of clock_divide_by_n_even is
    constant HALF : positive := DIV / 2;
    signal cnt : natural range 0 to HALF - 1;
    signal q   : std_logic;
begin
    assert DIV mod 2 = 0
        report "DIV must be even"
        severity failure;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= 0;
                q <= '0';
            elsif cnt = HALF - 1 then
                cnt <= 0;
                q <= not q;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    clk_div <= q;
end architecture;
