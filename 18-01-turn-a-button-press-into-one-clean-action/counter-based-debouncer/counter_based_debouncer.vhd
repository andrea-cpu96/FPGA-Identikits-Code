library ieee;
use ieee.std_logic_1164.all;

entity counter_based_debouncer is
    generic (STABLE : positive := 500000);
    port (
        clk, btn : in std_logic;
        debounced : out std_logic
    );
end entity;

architecture rtl of counter_based_debouncer is
    signal sync : std_logic_vector(1 downto 0)
        := (others => '0');
    signal count : natural range 0 to STABLE-1 := 0;
    signal level : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            sync <= sync(0) & btn;
            if sync(1) = level then
                count <= 0;
            elsif count = STABLE-1 then
                level <= sync(1);
                count <= 0;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    debounced <= level;
end architecture;
