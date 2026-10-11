library ieee;
use ieee.std_logic_1164.all;

entity clock_divide_by_2 is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        clk_div2 : out std_logic
    );
end entity;

architecture rtl of clock_divide_by_2 is
    signal q : std_logic;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= '0';
            else
                q <= not q;
            end if;
        end if;
    end process;
    clk_div2 <= q;
end architecture;
