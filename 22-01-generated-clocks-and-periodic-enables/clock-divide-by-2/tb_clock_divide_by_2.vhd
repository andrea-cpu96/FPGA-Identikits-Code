-- Self-checking tests for identikit 22.1.1: Divide-by-2.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_clock_divide_by_2 is end entity;
architecture test of tb_clock_divide_by_2 is
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
    signal finished: boolean_vector(0 to 0) := (others => false);
begin
    case_0: block
        signal clk:std_logic:='0';
        signal rst:std_logic:='0';
        signal div2:std_logic;
    begin
        clk<=not clk after 5 ns;
        u3:entity work.clock_divide_by_2 port map(clk,rst,div2);
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
                assert div2=sl(age mod 2=1) report "clock division" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_clock_divide_by_2" severity note;
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
