library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity moving_average_filter is
    generic (W : positive := 16;
             K : positive range 1 to 10 := 2);
    port (clk, rst, ce : in std_logic;
          din : in signed(W-1 downto 0);
          dout : out signed(W-1 downto 0);
          valid : out std_logic);
end entity;
architecture rtl of moving_average_filter is
    constant L : positive := 2**K;
    type history_t is array (0 to L-1) of signed(W-1 downto 0);
    signal history : history_t;
    signal ptr : natural range 0 to L-1;
    signal filled : natural range 0 to L;
    signal total : signed(W+K-1 downto 0);
begin
    process (clk)
        variable next_sum : signed(W+K-1 downto 0);
    begin
        if rising_edge(clk) then
            valid <= '0';
            if rst = '1' then
                history <= (others => (others => '0'));
                ptr <= 0; filled <= 0;
                total <= (others => '0');
                dout <= (others => '0');
            elsif ce = '1' then
                next_sum := total - resize(history(ptr), W+K)
                                  + resize(din, W+K);
                total <= next_sum;
                history(ptr) <= din;
                if ptr = L-1 then ptr <= 0;
                else ptr <= ptr + 1; end if;
                if filled < L then filled <= filled + 1; end if;
                if filled >= L-1 then valid <= '1'; end if;
                dout <= resize(shift_right(next_sum, K), W);
            end if;
        end if;
    end process;
end architecture;
