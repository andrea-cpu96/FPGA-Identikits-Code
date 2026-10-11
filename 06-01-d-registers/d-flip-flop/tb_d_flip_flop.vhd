-- Self-checking tests for identikit 6.1.1: D flip-flop.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_d_flip_flop is end entity;
architecture test of tb_d_flip_flop is
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
        signal d,rst:std_logic:='0';
        signal q:std_logic;
    begin
        clk<=not clk after 5 ns;
        dut:entity work.d_flip_flop port map(clk,d,rst,q);
        stimulus: process
        begin
            for k in 0 to 15 loop
                wait until falling_edge(clk);
                d<=sl(k mod 2=1);
                rst<=sl(k mod 3=0);
                wait until rising_edge(clk);
                wait for 1 ns;
                if rst='1' then
                    assert q='0' report "reset priority" severity failure;
                else
                    assert q=d report "capture" severity failure;
                end if;
            end loop;
            wait until falling_edge(clk);
            d<='1';
            rst<='0';
            wait until rising_edge(clk);
            wait for 1 ns;
            rst<='1';
            d<='0';
            wait for 1 ns;
            assert q='1' report "reset and data must not act between edges" severity failure;
            rst<='0';
            wait for 1 ns;
            assert q='1' report "hold" severity failure;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_d_flip_flop" severity note;
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
