library ieee;
use ieee.std_logic_1164.all;

entity reset_synchronizer is
    port (
        clk : in std_logic;
        arst_n : in std_logic;
        rst_sync_n : out std_logic
    );
end entity;

architecture rtl of reset_synchronizer is
    signal sync : std_logic_vector(1 downto 0);
begin
    process (clk, arst_n)
    begin
        if arst_n = '0' then
            sync <= (others => '0');
        elsif rising_edge(clk) then
            sync <= sync(0) & '1';
        end if;
    end process;
    rst_sync_n <= sync(1);
end architecture;
