-- Self-checking tests for identikit 9.1.3: Watchdog timer.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_watchdog_timer is end entity;
architecture test of tb_watchdog_timer is
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
    signal finished: boolean_vector(0 to 1) := (others => false);
begin
    case_0: block
        signal clk:std_logic:='0';
        signal rst,arm,kick,armed,expired:std_logic:='0';
    begin
        clk<=not clk after 5 ns;
        u:entity work.watchdog_timer generic map(2) port map(clk,rst,arm,kick,armed,expired);
        stimulus: process
            variable age,seed:natural:=0;
            variable active,expired_model:boolean:=false;
        begin
            seed:=823;
            for k in 0 to 1000 loop
                seed:=(seed*17+31) mod 65521;
                rst<=sl(k mod 23=0);
                arm<=sl(seed mod 2=1);
                kick<=sl(seed mod 3=0);
                wait until rising_edge(clk);
                if rst='1' then
                    age:=0;
                    active:=false;
                    expired_model:=false;
                elsif not active then
                    if arm='1' then
                        active:=true;
                        age:=0;
                    end if;
                elsif not expired_model then
                    if age=1 then
                        expired_model:=true;
                    elsif kick='1' then
                        age:=0;
                    else
                        age:=age+1;
                    end if;
                end if;
                wait for 1 ns;
                assert armed=sl(active) and expired=sl(expired_model) report "watchdog" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        signal clk:std_logic:='0';
        signal rst,arm,kick,armed,expired:std_logic:='0';
    begin
        clk<=not clk after 5 ns;
        u:entity work.watchdog_timer generic map(5) port map(clk,rst,arm,kick,armed,expired);
        stimulus: process
            variable age,seed:natural:=0;
            variable active,expired_model:boolean:=false;
        begin
            seed:=823;
            for k in 0 to 1000 loop
                seed:=(seed*17+31) mod 65521;
                rst<=sl(k mod 23=0);
                arm<=sl(seed mod 2=1);
                kick<=sl(seed mod 3=0);
                wait until rising_edge(clk);
                if rst='1' then
                    age:=0;
                    active:=false;
                    expired_model:=false;
                elsif not active then
                    if arm='1' then
                        active:=true;
                        age:=0;
                    end if;
                elsif not expired_model then
                    if age=4 then
                        expired_model:=true;
                    elsif kick='1' then
                        age:=0;
                    else
                        age:=age+1;
                    end if;
                end if;
                wait for 1 ns;
                assert armed=sl(active) and expired=sl(expired_model) report "watchdog" severity failure;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_watchdog_timer" severity note;
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
