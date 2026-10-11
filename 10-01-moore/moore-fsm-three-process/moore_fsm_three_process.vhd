library ieee;
use ieee.std_logic_1164.all;

entity moore_fsm_three_process is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        x   : in  std_logic;
        y   : out std_logic
    );
end entity moore_fsm_three_process;

architecture rtl of moore_fsm_three_process is
    type state_t is (IDLE, S1, S2);
    signal state, nstate : state_t;
begin
    -- 1) State register.
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
            else
                state <= nstate;
            end if;
        end if;
    end process;

    -- 2) Next-state logic.
    process (state, x)
    begin
        nstate <= state;
        case state is
            when IDLE =>
                if x = '1' then
                    nstate <= S1;
                end if;
            when S1 =>
                if x = '1' then
                    nstate <= S2;
                end if;
            when S2 =>
                nstate <= IDLE;
        end case;
    end process;

    -- 3) Moore output decode.
    process (state)
    begin
        y <= '0';
        case state is
            when S2     => y <= '1';
            when others => null;
        end case;
    end process;
end architecture rtl;
