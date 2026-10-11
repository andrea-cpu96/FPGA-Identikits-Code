library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_dual_port_ram is
    generic (
        WIDTH  : positive := 8;
        ADDR_W : positive := 8
    );
    port (
        wr_clk, rd_clk, we : in std_logic;
        waddr, raddr : in
            std_logic_vector(ADDR_W-1 downto 0);
        din : in std_logic_vector(WIDTH-1 downto 0);
        dout : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity simple_dual_port_ram;

architecture rtl of simple_dual_port_ram is
    constant DEPTH : positive := 2**ADDR_W;
    type ram_t is array (0 to DEPTH-1) of
        std_logic_vector(WIDTH-1 downto 0);
    signal ram : ram_t;
begin
    process (wr_clk)
    begin
        if rising_edge(wr_clk) then
            if we = '1' then
                ram(to_integer(unsigned(waddr))) <= din;
            end if;
        end if;
    end process;

    process (rd_clk)
    begin
        if rising_edge(rd_clk) then
            dout <= ram(to_integer(unsigned(raddr)));
        end if;
    end process;
end architecture rtl;
