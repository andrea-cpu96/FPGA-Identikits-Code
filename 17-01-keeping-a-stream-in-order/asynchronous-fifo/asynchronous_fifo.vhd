library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity asynchronous_fifo is
    generic (WIDTH : positive := 8; ADDR_W : positive := 4);
    port (
        wr_clk, rd_clk, wr, rd : in std_logic;
        din : in std_logic_vector(WIDTH-1 downto 0);
        dout : out std_logic_vector(WIDTH-1 downto 0);
        full, empty : out std_logic
    );
end entity;
architecture rtl of asynchronous_fifo is
    constant DEPTH : positive := 2**ADDR_W;
    constant FULL_MASK : unsigned(ADDR_W downto 0) :=
        shift_left(to_unsigned(3, ADDR_W+1), ADDR_W-1);
    type mem_t is array (0 to DEPTH-1) of
        std_logic_vector(WIDTH-1 downto 0);
    signal mem : mem_t;
    signal wbin, wgray, rbin, rgray : unsigned(ADDR_W downto 0)
        := (others => '0');
    signal rgray_w1, rgray_w2, wgray_r1, wgray_r2 :
        unsigned(ADDR_W downto 0) := (others => '0');
    signal full_local, empty_local : std_logic;
begin
    full_local <= '1' when wgray = (rgray_w2 xor FULL_MASK)
                  else '0';
    empty_local <= '1' when rgray = wgray_r2 else '0';
    full <= full_local;
    empty <= empty_local;
    process (wr_clk)
        variable next_bin : unsigned(ADDR_W downto 0);
    begin
        if rising_edge(wr_clk) then
            rgray_w1 <= rgray;
            rgray_w2 <= rgray_w1;
            if wr = '1' and full_local = '0' then
                mem(to_integer(wbin(ADDR_W-1 downto 0))) <= din;
                next_bin := wbin + 1;
                wbin <= next_bin;
                wgray <= next_bin xor shift_right(next_bin, 1);
            end if;
        end if;
    end process;
    process (rd_clk)
        variable next_bin : unsigned(ADDR_W downto 0);
    begin
        if rising_edge(rd_clk) then
            wgray_r1 <= wgray;
            wgray_r2 <= wgray_r1;
            if rd = '1' and empty_local = '0' then
                dout <= mem(to_integer(rbin(ADDR_W-1 downto 0)));
                next_bin := rbin + 1;
                rbin <= next_bin;
                rgray <= next_bin xor shift_right(next_bin, 1);
            end if;
        end if;
    end process;
end architecture;
