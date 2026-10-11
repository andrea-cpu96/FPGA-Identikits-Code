library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity one_shot_countdown_timer is
    generic (N : positive := 8);
    port (
        clk, rst : in  std_logic;
        start    : in  std_logic;
        d        : in  std_logic_vector(N-1 downto 0);
        busy     : out std_logic;
        done     : out std_logic
    );
end entity one_shot_countdown_timer;

architecture rtl of one_shot_countdown_timer is
    signal cnt      : unsigned(N-1 downto 0);
    signal busy_reg : std_logic;
    signal done_reg : std_logic;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            done_reg <= '0';
            if rst = '1' then
                cnt <= (others => '0');
                busy_reg <= '0';
            elsif start = '1' then
                cnt <= unsigned(d);
                if unsigned(d) = 0 then
                    busy_reg <= '0';
                    done_reg <= '1';
                else
                    busy_reg <= '1';
                end if;
            elsif busy_reg = '1' then
                if cnt = 1 then
                    cnt <= (others => '0');
                    busy_reg <= '0';
                    done_reg <= '1';
                else
                    cnt <= cnt - 1;
                end if;
            end if;
        end if;
    end process;
    busy <= busy_reg;
    done <= done_reg;
end architecture rtl;
