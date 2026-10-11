library ieee;
use ieee.std_logic_1164.all;

entity pulse_synchronizer is
    port (
        clk_src, clk_dst : in std_logic;
        pulse_in : in std_logic;
        pulse_out : out std_logic
    );
end entity;

architecture rtl of pulse_synchronizer is
    signal toggle : std_logic := '0';
    signal sync : std_logic_vector(2 downto 0)
        := (others => '0');
begin
    process (clk_src)
    begin
        if rising_edge(clk_src) then
            if pulse_in = '1' then
                toggle <= not toggle;
            end if;
        end if;
    end process;

    process (clk_dst)
    begin
        if rising_edge(clk_dst) then
            sync <= sync(1 downto 0) & toggle;
        end if;
    end process;

    pulse_out <= sync(2) xor sync(1);
end architecture;
