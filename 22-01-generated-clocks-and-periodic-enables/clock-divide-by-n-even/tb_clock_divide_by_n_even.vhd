-- Self-checking tests for identikit 23.1.2: Divide-by-N (even).
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_clock_divide_by_n_even is end entity;
architecture test of tb_clock_divide_by_n_even is
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
    signal finished: boolean_vector(0 to 2) := (others => false);
begin
    case_0: block
        constant PERIOD:positive:=1;
        signal clk:std_logic:='0';
        signal rst:std_logic:='0';
        signal divn:std_logic;
    begin
        clk<=not clk after 5 ns;
        u4:entity work.clock_divide_by_n_even generic map(2*PERIOD) port map(clk,rst,divn);
        stimulus: process
            variable age:natural:=0;
        begin
            null;
            for trial in 0 to 2000 loop
                rst<=sl(trial mod 101=0);
                wait until rising_edge(clk);
                if rst='1' then
                    age:=0;
                else
                    null;
                    age:=age+1;
                end if;
                wait for 1 ns;
                assert divn=sl((age/PERIOD) mod 2=1) report "clock division" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant PERIOD:positive:=3;
        signal clk:std_logic:='0';
        signal rst:std_logic:='0';
        signal divn:std_logic;
    begin
        clk<=not clk after 5 ns;
        u4:entity work.clock_divide_by_n_even generic map(2*PERIOD) port map(clk,rst,divn);
        stimulus: process
            variable age:natural:=0;
        begin
            null;
            for trial in 0 to 2000 loop
                rst<=sl(trial mod 101=0);
                wait until rising_edge(clk);
                if rst='1' then
                    age:=0;
                else
                    null;
                    age:=age+1;
                end if;
                wait for 1 ns;
                assert divn=sl((age/PERIOD) mod 2=1) report "clock division" severity failure;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        constant PERIOD:positive:=7;
        signal clk:std_logic:='0';
        signal rst:std_logic:='0';
        signal divn:std_logic;
    begin
        clk<=not clk after 5 ns;
        u4:entity work.clock_divide_by_n_even generic map(2*PERIOD) port map(clk,rst,divn);
        stimulus: process
            variable age:natural:=0;
        begin
            null;
            for trial in 0 to 2000 loop
                rst<=sl(trial mod 101=0);
                wait until rising_edge(clk);
                if rst='1' then
                    age:=0;
                else
                    null;
                    age:=age+1;
                end if;
                wait for 1 ns;
                assert divn=sl((age/PERIOD) mod 2=1) report "clock division" severity failure;
            end loop;
            finished(2) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_clock_divide_by_n_even" severity note;
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
