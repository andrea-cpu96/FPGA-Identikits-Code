-- PIPO: parallel load, parallel output, synchronous reset.
library ieee;
use ieee.std_logic_1164.all;

entity pipo_register is
    generic (N : positive := 8);
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        d    : in  std_logic_vector(N-1 downto 0);
        load : in  std_logic;
        q    : out std_logic_vector(N-1 downto 0)
    );
end entity pipo_register;

architecture rtl of pipo_register is
    signal q_reg : std_logic_vector(N-1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_reg <= (others => '0');
            elsif load = '1' then
                q_reg <= d;
            end if;
        end if;
    end process;

    q <= q_reg;
end architecture rtl;
