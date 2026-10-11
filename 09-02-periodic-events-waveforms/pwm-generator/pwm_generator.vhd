library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm_generator is
    generic (
        N      : positive range 1 to 30 := 8;
        PERIOD : positive := 255
    );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        duty : in  std_logic_vector(N-1 downto 0);
        pwm  : out std_logic
    );
end entity pwm_generator;

architecture rtl of pwm_generator is
    signal cnt      : unsigned(N-1 downto 0);
    signal duty_reg : unsigned(N-1 downto 0);
    signal pwm_reg  : std_logic;
begin
    assert PERIOD < 2 ** N
        report "pwm_generator: PERIOD must be below 2**N"
        severity failure;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt      <= to_unsigned(PERIOD - 1, N);
                duty_reg <= (others => '0');
                pwm_reg  <= '0';
            elsif cnt >= PERIOD - 1 then
                cnt      <= (others => '0');
                duty_reg <= unsigned(duty);
                if unsigned(duty) /= 0 then
                    pwm_reg <= '1';
                else
                    pwm_reg <= '0';
                end if;
            else
                cnt <= cnt + 1;
                if cnt + 1 < duty_reg then
                    pwm_reg <= '1';
                else
                    pwm_reg <= '0';
                end if;
            end if;
        end if;
    end process;
    pwm <= pwm_reg;
end architecture rtl;
