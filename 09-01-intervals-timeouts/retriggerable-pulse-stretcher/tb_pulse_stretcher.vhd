-- Self-checking tests for identikit 9.1.2: Retriggerable pulse stretcher.
library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity stretcher_case is
    generic (L : positive := 3);
    port (finished : out boolean := false);
end;
architecture test of stretcher_case is
    signal clk : std_logic := '0';
    signal rst, trig : std_logic := '0';
    signal q : std_logic;
begin
    clk <= not clk after 5 ns;
    dut: entity work.pulse_stretcher
        generic map(PULSE_CYCLES => L) port map(clk, rst, trig, q);
    stimulus: process
        variable edge_no, deadline, checks : natural := 0;
        variable active : boolean := false;
        variable held : std_logic;
        variable random_state : natural := 9347 + L;
        procedure step(r, t : std_logic) is
        begin
            rst <= r; trig <= t;
            wait until rising_edge(clk);
            edge_no := edge_no + 1;
            if r = '1' then active := false;
            elsif t = '1' then active := true; deadline := edge_no + L;
            elsif active and edge_no >= deadline then active := false;
            end if;
            wait for 1 ns;
            if active then
                assert q = '1' report "Expected active, L=" & integer'image(L) & " edge=" & integer'image(edge_no) severity failure;
            else
                assert q = '0' report "Expected inactive, L=" & integer'image(L) & " edge=" & integer'image(edge_no) severity failure;
            end if;
            held := q;
            -- Change controls away from the sampling edge; q must hold.
            rst <= not r; trig <= not t;
            wait for 2 ns;
            assert q = held report "Inter-edge output change" severity failure;
            rst <= r; trig <= t;
            checks := checks + 1;
        end;
    begin
        step('1','0');
        -- Isolated interval and all retrigger offsets including expiry.
        step('0','1');
        for i in 1 to L+2 loop step('0','0'); end loop;
        for offset in 1 to L+1 loop
            step('1','0'); step('0','1');
            for i in 1 to offset-1 loop step('0','0'); end loop;
            step('0','1');
            for i in 1 to L+2 loop step('0','0'); end loop;
        end loop;
        -- Held trigger, reset priority and cancellation during activity.
        for i in 1 to 2*L+3 loop step('0','1'); end loop;
        for i in 1 to L+2 loop step('0','0'); end loop;
        step('0','1'); step('1','1'); step('0','0');
        for i in 1 to L+2 loop step('0','0'); end loop;
        -- Exact printed trace at L=3 (trigger at edges 0, 5, 7).
        step('1','0');
        for i in 0 to 11 loop
            if i=0 or i=5 or i=7 then step('0','1'); else step('0','0'); end if;
        end loop;
        -- Independent absolute-deadline oracle, random gaps and resets.
        for i in 1 to 4000 loop
            random_state := (random_state * 17 + 19) mod 65521;
            if random_state mod 37 = 0 then step('1','1');
            elsif random_state mod 7 = 0 then step('0','1');
            else step('0','0'); end if;
        end loop;
        step('1','0');
        report "PASS pulse stretcher L=" & integer'image(L) & " checked edges=" & integer'image(checks);
        finished <= true;
        wait;
    end process;
end;

library ieee;
use ieee.std_logic_1164.all;
use std.env.all;
entity tb_pulse_stretcher is end;
architecture test of tb_pulse_stretcher is
    signal finished : boolean_vector(0 to 4) := (others => false);
begin
    a: entity work.stretcher_case generic map(1) port map(finished(0));
    b: entity work.stretcher_case generic map(2) port map(finished(1));
    c: entity work.stretcher_case generic map(3) port map(finished(2));
    d: entity work.stretcher_case generic map(4) port map(finished(3));
    e: entity work.stretcher_case generic map(13) port map(finished(4));
    process
    begin
        wait until finished = (finished'range => true);
        report "PASS: all pulse stretcher cases";
        finish; wait;
    end process;
end;
