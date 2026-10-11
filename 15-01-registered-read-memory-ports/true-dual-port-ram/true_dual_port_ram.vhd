library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity true_dual_port_ram is
    generic (
        WIDTH  : positive := 8;
        ADDR_W : positive := 8
    );
    port (
        clk, we_a, we_b : in std_logic;
        addr_a, addr_b : in
            std_logic_vector(ADDR_W-1 downto 0);
        din_a, din_b : in
            std_logic_vector(WIDTH-1 downto 0);
        dout_a, dout_b : out
            std_logic_vector(WIDTH-1 downto 0)
    );
end entity true_dual_port_ram;

architecture rtl of true_dual_port_ram is
    constant DEPTH : positive := 2**ADDR_W;
    type ram_t is array (0 to DEPTH-1) of
        std_logic_vector(WIDTH-1 downto 0);
    signal ram : ram_t;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            assert not (addr_a = addr_b and
                (we_a = '1' or we_b = '1'))
                report "Cross-port RAM collision"
                severity failure;
            if we_a = '1' then
                ram(to_integer(unsigned(addr_a))) <= din_a;
            end if;
            if we_b = '1' then
                ram(to_integer(unsigned(addr_b))) <= din_b;
            end if;
            dout_a <= ram(to_integer(unsigned(addr_a)));
            dout_b <= ram(to_integer(unsigned(addr_b)));
        end if;
    end process;
end architecture rtl;
