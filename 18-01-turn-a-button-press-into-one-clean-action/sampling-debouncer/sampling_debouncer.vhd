library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sampling_debouncer is
    generic (K : positive := 8);
    port (
        clk, btn : in std_logic;
        debounced : out std_logic
    );
end entity;

architecture rtl of sampling_debouncer is
    constant ONES : std_logic_vector(K-1 downto 0)
        := (others => '1');
    constant ZEROS : std_logic_vector(K-1 downto 0)
        := (others => '0');
    signal sync : std_logic_vector(1 downto 0)
        := (others => '0');
    signal history : std_logic_vector(K-1 downto 0)
        := (others => '0');
    signal level : std_logic := '0';
begin
    process (clk)
    begin
        if rising_edge(clk) then
            sync <= sync(0) & btn;
            history <= std_logic_vector(
                shift_left(unsigned(history), 1));
            history(0) <= sync(1);
            if history = ONES then
                level <= '1';
            elsif history = ZEROS then
                level <= '0';
            end if;
        end if;
    end process;
    debounced <= level;
end architecture;
