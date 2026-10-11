library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synchronous_fifo is
    generic (WIDTH : positive := 8;
             ADDR_W : positive := 4);
    port (
        clk, rst, wr, rd : in std_logic;
        din : in std_logic_vector(WIDTH-1 downto 0);
        dout : out std_logic_vector(WIDTH-1 downto 0);
        full, empty : out std_logic
    );
end entity;

architecture rtl of synchronous_fifo is
    constant DEPTH : positive := 2**ADDR_W;
    type mem_t is array (0 to DEPTH-1) of
        std_logic_vector(WIDTH-1 downto 0);
    signal mem : mem_t;
    signal wptr, rptr : unsigned(ADDR_W-1 downto 0)
        := (others => '0');
    signal count : unsigned(ADDR_W downto 0)
        := (others => '0');
begin
    full <= '1' when count = DEPTH else '0';
    empty <= '1' when count = 0 else '0';
    process (clk)
        variable push, pop : boolean;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                wptr <= (others => '0');
                rptr <= (others => '0');
                count <= (others => '0');
            else
                push := wr = '1' and count /= DEPTH;
                pop := rd = '1' and count /= 0;
                if push then
                    mem(to_integer(wptr)) <= din;
                    wptr <= wptr + 1;
                end if;
                if pop then
                    dout <= mem(to_integer(rptr));
                    rptr <= rptr + 1;
                end if;
                if push and not pop then
                    count <= count + 1;
                elsif pop and not push then
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;
end architecture;
