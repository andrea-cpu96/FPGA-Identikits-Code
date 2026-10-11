-- Self-checking tests for identikit 19.1.3: Reset synchronizer.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_reset_synchronizer is end entity;
architecture test of tb_reset_synchronizer is
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
        signal arst_n:std_logic:='1';
        signal sr:std_logic;
    begin
        clk<=not clk after 5 ns;
        u:entity work.reset_synchronizer port map(clk,arst_n,sr);
        stimulus: process
        begin
            wait for 2 ns;
            for k in 1 to 20 loop
                arst_n<='0';
                wait for 1 ns;
                assert sr='0' report "asynchronous reset assertion" severity failure;
                wait until falling_edge(clk);
                wait for 1 ns;
                arst_n<='1';
                wait for 1 ns;
                assert sr='0' severity failure;
                wait until rising_edge(clk);
                wait for 1 ns;
                assert sr='0' report "early reset release" severity failure;
                wait until rising_edge(clk);
                wait for 1 ns;
                assert sr='1' report "reset release latency" severity failure;
                wait for 1 ns;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_reset_synchronizer" severity note;
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
