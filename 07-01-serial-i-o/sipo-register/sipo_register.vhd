-- SIPO: newest bit at q(0), oldest retained bit at q(N-1).
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sipo_register is
    generic (N : positive := 8);
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        si  : in  std_logic;
        q   : out std_logic_vector(N-1 downto 0)
    );
end entity sipo_register;

architecture rtl of sipo_register is
    signal q_reg : std_logic_vector(N-1 downto 0);
begin
    process (clk)
        variable next_q : std_logic_vector(N-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_reg <= (others => '0');
            else
                next_q := std_logic_vector(
                    shift_left(unsigned(q_reg), 1));
                next_q(0) := si;
                q_reg <= next_q;
            end if;
        end if;
    end process;

    q <= q_reg;
end architecture rtl;
