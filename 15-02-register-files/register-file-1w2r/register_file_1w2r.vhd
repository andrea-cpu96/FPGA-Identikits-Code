library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file_1w2r is
    generic (
        WIDTH  : positive := 8;
        ADDR_W : positive := 4
    );
    port (
        clk, we : in std_logic;
        waddr, raddr_a, raddr_b : in
            std_logic_vector(ADDR_W-1 downto 0);
        wdata : in std_logic_vector(WIDTH-1 downto 0);
        rdata_a, rdata_b : out
            std_logic_vector(WIDTH-1 downto 0)
    );
end entity register_file_1w2r;

architecture rtl of register_file_1w2r is
    type regs_t is array (0 to 2**ADDR_W-1) of
        std_logic_vector(WIDTH-1 downto 0);
    signal regs : regs_t;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if we = '1' then
                regs(to_integer(unsigned(waddr))) <= wdata;
            end if;
        end if;
    end process;

    rdata_a <= regs(to_integer(unsigned(raddr_a)));
    rdata_b <= regs(to_integer(unsigned(raddr_b)));
end architecture rtl;
