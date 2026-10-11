library ieee;
use ieee.std_logic_1164.all;

entity pulse_stretcher is
    generic (PULSE_CYCLES : positive := 4);
    port (
        clk, rst : in  std_logic;
        trig     : in  std_logic;
        q        : out std_logic
    );
end entity pulse_stretcher;

architecture rtl of pulse_stretcher is
    signal remaining : natural range 0 to PULSE_CYCLES;
    signal q_reg     : std_logic;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                remaining <= 0;
                q_reg <= '0';
            elsif trig = '1' then
                remaining <= PULSE_CYCLES;
                q_reg <= '1';
            elsif remaining > 1 then
                remaining <= remaining - 1;
            elsif remaining = 1 then
                remaining <= 0;
                q_reg <= '0';
            end if;
        end if;
    end process;
    q <= q_reg;
end architecture rtl;
