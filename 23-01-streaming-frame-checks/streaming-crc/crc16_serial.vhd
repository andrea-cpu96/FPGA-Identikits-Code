library ieee;
use ieee.std_logic_1164.all;

entity crc16_serial is
    generic (
        POLY : std_logic_vector(15 downto 0) := x"1021";
        INIT : std_logic_vector(15 downto 0) := x"FFFF"
    );
    port (
        clk, rst : in  std_logic;
        start    : in  std_logic;
        en, din  : in  std_logic;
        crc      : out std_logic_vector(15 downto 0);
        zero     : out std_logic
    );
end entity crc16_serial;

architecture rtl of crc16_serial is
    signal crc_reg : std_logic_vector(15 downto 0);
begin
    process (clk)
        variable c  : std_logic_vector(15 downto 0);
        variable fb : std_logic;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                crc_reg <= INIT;
            else
                c := crc_reg;
                if start = '1' then
                    c := INIT;
                end if;
                if en = '1' then
                    fb := c(15) xor din;
                    c  := c(14 downto 0) & '0';
                    if fb = '1' then
                        c := c xor POLY;
                    end if;
                end if;
                crc_reg <= c;
            end if;
        end if;
    end process;
    crc  <= crc_reg;
    zero <= '1' when crc_reg = x"0000" else '0';
end architecture rtl;
