library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity first_order_iir_filter is
    generic (W : positive := 16;
             K : positive range 1 to 16 := 3;
             F : positive range 1 to 24 := 8);
    port (clk, rst, ce : in std_logic;
          din : in signed(W-1 downto 0);
          dout : out signed(W-1 downto 0);
          valid : out std_logic);
end entity;
architecture rtl of first_order_iir_filter is
    constant S : positive := W+F;
    signal state : signed(S-1 downto 0);
begin
    assert F >= K report "Require F >= K" severity failure;
    process (clk)
        variable target, delta, next_state : signed(S downto 0);
    begin
        if rising_edge(clk) then
            valid <= '0';
            if rst = '1' then
                state <= (others => '0');
                dout <= (others => '0');
            elsif ce = '1' then
                target := shift_left(resize(din, S+1), F);
                delta := target - resize(state, S+1);
                next_state := resize(state, S+1)
                              + shift_right(delta, K);
                state <= resize(next_state, S);
                dout <= resize(shift_right(next_state, F), W);
                valid <= '1';
            end if;
        end if;
    end process;
end architecture;
