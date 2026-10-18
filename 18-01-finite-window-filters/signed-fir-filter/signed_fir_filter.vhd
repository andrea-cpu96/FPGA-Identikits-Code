package fir_support is
    function ceil_log2(n : positive) return natural;
end package;
package body fir_support is
    function ceil_log2(n : positive) return natural is
        variable v : natural := n-1;
        variable b : natural := 0;
    begin
        while v > 0 loop b := b+1; v := v/2; end loop;
        return b;
    end function;
end package body;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_support.all;
entity signed_fir_filter is
    generic (W : positive := 16;
             CW : positive range 1 to 16 := 8;
             C : integer_vector := (1, 2, 1));
    port (clk, rst, ce : in std_logic;
          din : in signed(W-1 downto 0);
          dout : out signed(W+CW+ceil_log2(C'length)-1 downto 0);
          valid : out std_logic);
end entity;
architecture rtl of signed_fir_filter is
    constant T : positive := C'length;
    constant A : positive := W+CW+ceil_log2(T);
    type history_t is array (0 to T-1) of signed(W-1 downto 0);
    signal history : history_t;
begin
    assert C'ascending and C'left = 0
        report "C must be ascending and zero-based" severity failure;
    check_c : for i in 0 to T-1 generate
        assert C(i) >= -(2**(CW-1)) and C(i) < 2**(CW-1)
            report "Coefficient outside CW range" severity failure;
    end generate;
    process (clk)
        variable acc : signed(A-1 downto 0);
    begin
        if rising_edge(clk) then
            valid <= '0';
            if rst = '1' then
                history <= (others => (others => '0'));
                dout <= (others => '0');
            elsif ce = '1' then
                acc := resize(din * to_signed(C(0), CW), A);
                for i in 1 to T-1 loop
                    acc := acc + resize(history(i-1)
                                      * to_signed(C(i), CW), A);
                end loop;
                for i in T-1 downto 1 loop
                    history(i) <= history(i-1);
                end loop;
                history(0) <= din;
                dout <= acc;
                valid <= '1';
            end if;
        end if;
    end process;
end architecture;
