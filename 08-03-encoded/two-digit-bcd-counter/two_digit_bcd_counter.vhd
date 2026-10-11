library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_digit_bcd_counter is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        en  : in  std_logic;
        bcd : out std_logic_vector(7 downto 0)
    );
end entity two_digit_bcd_counter;

architecture rtl of two_digit_bcd_counter is
    signal ones : unsigned(3 downto 0);
    signal tens : unsigned(3 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ones <= (others => '0');
                tens <= (others => '0');
            elsif en = '1' then
                if ones > 9 or tens > 9 then
                    ones <= (others => '0');
                    tens <= (others => '0');
                elsif ones = 9 then
                    ones <= (others => '0');
                    if tens = 9 then
                        tens <= (others => '0');
                    else
                        tens <= tens + 1;
                    end if;
                else
                    ones <= ones + 1;
                end if;
            end if;
        end if;
    end process;

    bcd <= std_logic_vector(tens)
           & std_logic_vector(ones);
end architecture rtl;
