library ieee;
use ieee.std_logic_1164.all;

entity fractional_tick_generator is
    generic (
        NUM : positive := 18;
        DEN : positive := 15625
    );
    port (
        clk, rst : in  std_logic;
        restart  : in  std_logic;
        tick     : out std_logic
    );
end entity fractional_tick_generator;

architecture rtl of fractional_tick_generator is
    signal phase    : natural range 0 to DEN - 1;
    signal tick_reg : std_logic;
begin
    assert NUM <= DEN and DEN <= 2 ** 30
        report "fractional_tick_generator: bad NUM or DEN"
        severity failure;

    process (clk)
    begin
        if rising_edge(clk) then
            tick_reg <= '0';
            if rst = '1' or restart = '1' then
                phase <= 0;
            elsif phase + NUM >= DEN then
                phase    <= phase + NUM - DEN;
                tick_reg <= '1';
            else
                phase <= phase + NUM;
            end if;
        end if;
    end process;
    tick <= tick_reg;
end architecture rtl;
