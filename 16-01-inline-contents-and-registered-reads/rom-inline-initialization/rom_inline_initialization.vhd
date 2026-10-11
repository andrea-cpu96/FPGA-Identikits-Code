library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_inline_initialization is
    port (
        clk : in std_logic;
        addr : in std_logic_vector(2 downto 0);
        dout : out std_logic_vector(7 downto 0)
    );
end entity rom_inline_initialization;

architecture rtl of rom_inline_initialization is
    type rom_t is array (0 to 7) of
        std_logic_vector(7 downto 0);
    constant ROM : rom_t := (
        0 => x"12", 1 => x"34",
        2 => x"56", 3 => x"78",
        4 => x"9A", 5 => x"BC",
        others => x"00"
    );
begin
    process (clk)
    begin
        if rising_edge(clk) then
            dout <= ROM(to_integer(unsigned(addr)));
        end if;
    end process;
end architecture rtl;
