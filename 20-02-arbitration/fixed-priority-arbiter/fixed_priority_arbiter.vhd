library ieee;
use ieee.std_logic_1164.all;

entity fixed_priority_arbiter is
    generic (N : positive := 4);
    port (
        clk, rst : in  std_logic;
        req      : in  std_logic_vector(N-1 downto 0);
        done     : in  std_logic;
        grant    : out std_logic_vector(N-1 downto 0)
    );
end entity fixed_priority_arbiter;

architecture rtl of fixed_priority_arbiter is
    constant IDLE : std_logic_vector(N-1 downto 0)
        := (others => '0');
    signal grant_reg : std_logic_vector(N-1 downto 0);

    function pick(r : std_logic_vector(N-1 downto 0))
        return std_logic_vector is
        variable g : std_logic_vector(N-1 downto 0) := IDLE;
    begin
        for i in 0 to N-1 loop
            if r(i) = '1' then
                g(i) := '1';
                return g;
            end if;
        end loop;
        return g;
    end function;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                grant_reg <= IDLE;
            elsif grant_reg = IDLE or done = '1' then
                grant_reg <= pick(req);
            end if;
        end if;
    end process;
    grant <= grant_reg;
end architecture rtl;
