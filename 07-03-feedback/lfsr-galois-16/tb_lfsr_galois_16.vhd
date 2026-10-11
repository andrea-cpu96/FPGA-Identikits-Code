-- Self-checking tests for identikit 7.3.4: 16-bit Galois LFSR.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_lfsr_galois_16 is end entity;
architecture test of tb_lfsr_galois_16 is
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
        signal rst:std_logic:='1';
        signal q:std_logic_vector(15 downto 0);
    begin
        clk<=not clk after 5 ns;
        dut:entity work.lfsr_galois_16 port map(clk,rst,q);
        stimulus: process
            function bitval(v,k:natural) return natural is begin
                return (v/2**k) mod 2;
            end;
            type seen_t is array(0 to 65535) of boolean;
            variable seen:seen_t:=(others=>false);
            variable expected,old:natural:=1;
        begin
            wait until rising_edge(clk);
            wait for 1 ns;
            assert q=x"0001" report "reset seed" severity failure;
            rst<='0';
            for k in 1 to 65535 loop
                assert not seen(expected) and expected/=0 report "maximal nonzero cycle" severity failure;
                seen(expected):=true;
                old:=expected;
                expected := expected/2;
                if old mod 2=1 then
                    expected := to_integer(to_unsigned(expected,16) xor to_unsigned(16#B400#,16));
                end if;
                wait until rising_edge(clk);
                wait for 1 ns;
                assert q=vec(expected,16) report "recurrence" severity failure;
            end loop;
            assert q=x"0001" report "period 65535" severity failure;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_lfsr_galois_16" severity note;
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
