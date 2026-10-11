-- 00 hold, 01 shift right, 10 shift left, 11 load.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity universal_shift_register is
    generic (N : positive := 8);
    port (
        clk, rst : in  std_logic;
        d        : in  std_logic_vector(N-1 downto 0);
        sel      : in  std_logic_vector(1 downto 0);
        si_l     : in  std_logic;
        si_r     : in  std_logic;
        q        : out std_logic_vector(N-1 downto 0)
    );
end entity universal_shift_register;

architecture rtl of universal_shift_register is
    signal q_reg : std_logic_vector(N-1 downto 0);
begin
    process (clk)
        variable next_q : std_logic_vector(N-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_reg <= (others => '0');
            else
                case sel is
                    when "00" => null;
                    when "01" =>
                        next_q := std_logic_vector(
                            shift_right(unsigned(q_reg), 1));
                        next_q(N-1) := si_r;
                        q_reg <= next_q;
                    when "10" =>
                        next_q := std_logic_vector(
                            shift_left(unsigned(q_reg), 1));
                        next_q(0) := si_l;
                        q_reg <= next_q;
                    when "11" => q_reg <= d;
                    when others =>
                        assert false report "invalid sel"
                            severity warning;
                end case;
            end if;
        end if;
    end process;
    q <= q_reg;
end architecture rtl;
