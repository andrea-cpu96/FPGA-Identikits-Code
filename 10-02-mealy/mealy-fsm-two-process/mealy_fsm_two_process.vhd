library ieee;
use ieee.std_logic_1164.all;

entity mealy_fsm_two_process is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        x   : in  std_logic;
        y   : out std_logic
    );
end entity mealy_fsm_two_process;

architecture rtl of mealy_fsm_two_process is
    type state_t is (IDLE, S1);
    signal state, nstate : state_t;
begin

    -- State register.
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

    -- Next-state logic and Mealy output decode.
    process (state, x)
    begin
        nstate <= state;
        y <= '0';

        case state is
            when IDLE =>
                if x = '1' then
                    nstate <= S1;
                end if;

            when S1 =>
                if x = '1' then
                    y <= '1';
                else
                    nstate <= IDLE;
                end if;
        end case;
    end process;

end architecture rtl;
