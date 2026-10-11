library ieee;
use ieee.std_logic_1164.all;

entity round_robin_arbiter is
    generic (N : positive := 4);
    port (
        clk, rst : in  std_logic;
        req      : in  std_logic_vector(N-1 downto 0);
        done     : in  std_logic;
        grant    : out std_logic_vector(N-1 downto 0)
    );
end entity round_robin_arbiter;

architecture rtl of round_robin_arbiter is
    constant IDLE : std_logic_vector(N-1 downto 0)
        := (others => '0');
    signal grant_reg : std_logic_vector(N-1 downto 0);
    signal last      : natural range 0 to N-1;
begin
    process (clk)
        variable j : natural range 0 to 2*N;
        variable g : std_logic_vector(N-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '1' then
                grant_reg <= IDLE;
                last      <= N-1;
            elsif grant_reg = IDLE or done = '1' then
                g := IDLE;
                for k in 1 to N loop
                    j := last + k;
                    if j >= N then
                        j := j - N;
                    end if;
                    if req(j) = '1' then
                        g(j) := '1';
                        last <= j;
                        exit;
                    end if;
                end loop;
                grant_reg <= g;
            end if;
        end if;
    end process;
    grant <= grant_reg;
end architecture rtl;
