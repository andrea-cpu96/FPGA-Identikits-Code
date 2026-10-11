-- Galois LFSR: same polynomial, right-shift mask B400.
library ieee;
use ieee.std_logic_1164.all;

entity lfsr_galois_16 is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic_vector(15 downto 0)
    );
end entity lfsr_galois_16;

architecture rtl of lfsr_galois_16 is
    signal q_reg : std_logic_vector(15 downto 0);
begin
    process (clk)
        variable next_q : std_logic_vector(15 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q_reg <= x"0001";
            else
                next_q := '0' & q_reg(15 downto 1);
                case q_reg(0) is
                    when '0' => q_reg <= next_q;
                    when '1' =>
                        q_reg <= next_q xor x"B400";
                    when others =>
                        assert false
                            report "invalid Galois state"
                            severity warning;
                end case;
            end if;
        end if;
    end process;

    q <= q_reg;
end architecture rtl;
