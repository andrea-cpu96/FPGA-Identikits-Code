-- PISO serializer: current q(0) is the serial output.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity piso_register is
    generic (N : positive := 8);
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        d     : in  std_logic_vector(N-1 downto 0);
        load  : in  std_logic;
        shift : in  std_logic;
        so    : out std_logic
    );
end entity piso_register;

architecture rtl of piso_register is
    signal q : std_logic_vector(N-1 downto 0);
begin
    process (clk)
        variable next_q : std_logic_vector(N-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q <= (others => '0');
            elsif load = '1' then
                q <= d;
            elsif shift = '1' then
                next_q := std_logic_vector(
                    shift_right(unsigned(q), 1));
                next_q(N-1) := '0';
                q <= next_q;
            end if;
        end if;
    end process;

    so <= q(0);
end architecture rtl;
