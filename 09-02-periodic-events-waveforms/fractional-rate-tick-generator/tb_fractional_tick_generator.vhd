-- Self-checking tests for identikit 9.2.2: Fractional-rate tick generator.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_fractional_tick_generator is end entity;
architecture test of tb_fractional_tick_generator is
    function sl(b:boolean) return std_logic is
    begin
        if b then
            return '1';
        else
            return '0';
        end if;
    end;
    function vec(n,w:natural) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(n,w));
    end;
    function ref_count_width(n:positive) return positive is
        variable bits:positive:=1;
        variable value:natural:=n;
    begin
        while value>1 loop
            bits:=bits+1;
            value:=value/2;
        end loop;
        return bits;
    end;
    signal finished: boolean_vector(0 to 3) := (others => false);
begin
    case_0: block
        signal clk:std_logic:='0';
        signal rst,restart,tick:std_logic:='0';
    begin
        clk<=not clk after 5 ns;
        u:entity work.fractional_tick_generator generic map(1,1) port map(clk,rst,restart,tick);
        stimulus: process
            variable phase,ticks:natural:=0;
            variable expected:boolean;
        begin
            for k in 0 to 40000 loop
                rst<=sl(k=0);
                restart<=sl(k=25000);
                wait until rising_edge(clk);
                if rst='1' or restart='1' then
                    phase:=0;
                    expected:=false;
                else
                    -- Overflow-free mathematical modular accumulator.
                    expected:=phase>=0;
                    if expected then
                        phase:=phase-0;
                    else
                        phase:=phase+1;
                    end if;
                end if;
                wait for 1 ns;
                assert tick=sl(expected) report "fractional tick" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        signal clk:std_logic:='0';
        signal rst,restart,tick:std_logic:='0';
    begin
        clk<=not clk after 5 ns;
        u:entity work.fractional_tick_generator generic map(2,5) port map(clk,rst,restart,tick);
        stimulus: process
            variable phase,ticks:natural:=0;
            variable expected:boolean;
        begin
            for k in 0 to 40000 loop
                rst<=sl(k=0);
                restart<=sl(k=25000);
                wait until rising_edge(clk);
                if rst='1' or restart='1' then
                    phase:=0;
                    expected:=false;
                else
                    -- Overflow-free mathematical modular accumulator.
                    expected:=phase>=3;
                    if expected then
                        phase:=phase-3;
                    else
                        phase:=phase+2;
                    end if;
                end if;
                wait for 1 ns;
                assert tick=sl(expected) report "fractional tick" severity failure;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        signal clk:std_logic:='0';
        signal rst,restart,tick:std_logic:='0';
    begin
        clk<=not clk after 5 ns;
        u:entity work.fractional_tick_generator generic map(18,15625) port map(clk,rst,restart,tick);
        stimulus: process
            variable phase,ticks:natural:=0;
            variable expected:boolean;
        begin
            for k in 0 to 40000 loop
                rst<=sl(k=0);
                restart<=sl(k=25000);
                wait until rising_edge(clk);
                if rst='1' or restart='1' then
                    phase:=0;
                    expected:=false;
                else
                    -- Overflow-free mathematical modular accumulator.
                    expected:=phase>=15607;
                    if expected then
                        phase:=phase-15607;
                    else
                        phase:=phase+18;
                    end if;
                end if;
                wait for 1 ns;
                assert tick=sl(expected) report "fractional tick" severity failure;
            end loop;
            finished(2) <= true;
            wait;
        end process;
    end block;
    case_3: block
        signal clk:std_logic:='0';
        signal rst,restart,tick:std_logic:='0';
    begin
        clk<=not clk after 5 ns;
        u:entity work.fractional_tick_generator generic map(1073741823,1073741824) port map(clk,rst,restart,tick);
        stimulus: process
            variable phase,ticks:natural:=0;
            variable expected:boolean;
        begin
            for k in 0 to 40000 loop
                rst<=sl(k=0);
                restart<=sl(k=25000);
                wait until rising_edge(clk);
                if rst='1' or restart='1' then
                    phase:=0;
                    expected:=false;
                else
                    -- Overflow-free mathematical modular accumulator.
                    expected:=phase>=1;
                    if expected then
                        phase:=phase-1;
                    else
                        phase:=phase+1073741823;
                    end if;
                end if;
                wait for 1 ns;
                assert tick=sl(expected) report "fractional tick" severity failure;
            end loop;
            finished(3) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_fractional_tick_generator" severity note;
        std.env.finish;
        wait;
    end process;
    timeout: process
    begin
        wait for 20 ms;
        assert false report "Testbench timed out" severity failure;
        wait;
    end process;
end architecture;
