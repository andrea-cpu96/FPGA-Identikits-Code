library ieee;
use ieee.std_logic_1164.all;

entity two_ff_synchronizer is
    port (
        clk : in std_logic;
        async_in : in std_logic;
        sync_out : out std_logic
    );
end entity;

architecture rtl of two_ff_synchronizer is
    signal sync : std_logic_vector(1 downto 0)
        := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            sync <= sync(0) & async_in;
        end if;
    end process;
    sync_out <= sync(1);
end architecture;
