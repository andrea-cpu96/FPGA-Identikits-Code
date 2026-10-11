-- Self-checking tests for identikit 13.1.2: Sequential restoring divider.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_sequential_restoring_divider is end entity;
architecture test of tb_sequential_restoring_divider is
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
        constant N:positive:=1;
        signal clk:std_logic:='0';
        signal rst,start,busy,done:std_logic:='0';
        signal a,b,q,r:std_logic_vector(N-1 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u:entity work.sequential_restoring_divider generic map(N) port map(clk,rst,start,a,b,q,r,busy,done);
        stimulus: process
            procedure step is begin
                wait until rising_edge(clk);
                wait for 1 ns;
            end;
        begin
            rst<='1';
            step;
            rst<='0';
            for av in 0 to 1 loop
                for bv in 0 to 1 loop
                    a<=vec(av,N);
                    b<=vec(bv,N);
                    start<='1';
                    step;
                    assert busy='1' and done='0' report "accept" severity failure;
                    for k in 1 to N loop
                        -- Keep start high and change operands: busy requests must be ignored.
                        a<=(others=>'0');
                        b<=(others=>'1');
                        step;
                        if k<N then
                            assert busy='1' and done='0' report "early completion" severity failure;
                        end if;
                    end loop;
                    assert busy='0' and done='1' report "latency" severity failure;
                    if bv=0 then
                        assert q=vec(1,N) and r=vec(av,N) report "zero divisor" severity failure;
                    else
                        assert q=vec(av/bv,N) and r=vec(av mod bv,N) report "division result" severity failure;
                    end if;
                    start<='0';
                    step;
                    assert done='0' and busy='0' report "done width" severity failure;
                end loop;
            end loop;
            for abort_at in 0 to N-1 loop
                a<=(others=>'1');
                b<=vec(1,N);
                start<='1';
                step;
                start<='0';
                for k in 1 to abort_at loop
                    step;
                end loop;
                rst<='1';
                step;
                assert busy='0' and done='0' and q=vec(0,N) and r=vec(0,N) report "abort" severity failure;
                rst<='0';
                step;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant N:positive:=4;
        signal clk:std_logic:='0';
        signal rst,start,busy,done:std_logic:='0';
        signal a,b,q,r:std_logic_vector(N-1 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u:entity work.sequential_restoring_divider generic map(N) port map(clk,rst,start,a,b,q,r,busy,done);
        stimulus: process
            procedure step is begin
                wait until rising_edge(clk);
                wait for 1 ns;
            end;
        begin
            rst<='1';
            step;
            rst<='0';
            for av in 0 to 15 loop
                for bv in 0 to 15 loop
                    a<=vec(av,N);
                    b<=vec(bv,N);
                    start<='1';
                    step;
                    assert busy='1' and done='0' report "accept" severity failure;
                    for k in 1 to N loop
                        -- Keep start high and change operands: busy requests must be ignored.
                        a<=(others=>'0');
                        b<=(others=>'1');
                        step;
                        if k<N then
                            assert busy='1' and done='0' report "early completion" severity failure;
                        end if;
                    end loop;
                    assert busy='0' and done='1' report "latency" severity failure;
                    if bv=0 then
                        assert q=vec(15,N) and r=vec(av,N) report "zero divisor" severity failure;
                    else
                        assert q=vec(av/bv,N) and r=vec(av mod bv,N) report "division result" severity failure;
                    end if;
                    start<='0';
                    step;
                    assert done='0' and busy='0' report "done width" severity failure;
                end loop;
            end loop;
            for abort_at in 0 to N-1 loop
                a<=(others=>'1');
                b<=vec(1,N);
                start<='1';
                step;
                start<='0';
                for k in 1 to abort_at loop
                    step;
                end loop;
                rst<='1';
                step;
                assert busy='0' and done='0' and q=vec(0,N) and r=vec(0,N) report "abort" severity failure;
                rst<='0';
                step;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        constant N:positive:=8;
        signal clk:std_logic:='0';
        signal rst,start,busy,done:std_logic:='0';
        signal a,b,q,r:std_logic_vector(N-1 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u:entity work.sequential_restoring_divider generic map(N) port map(clk,rst,start,a,b,q,r,busy,done);
        stimulus: process
            procedure step is begin
                wait until rising_edge(clk);
                wait for 1 ns;
            end;
        begin
            rst<='1';
            step;
            rst<='0';
            for av in 0 to 255 loop
                for bv in 0 to 255 loop
                    a<=vec(av,N);
                    b<=vec(bv,N);
                    start<='1';
                    step;
                    assert busy='1' and done='0' report "accept" severity failure;
                    for k in 1 to N loop
                        -- Keep start high and change operands: busy requests must be ignored.
                        a<=(others=>'0');
                        b<=(others=>'1');
                        step;
                        if k<N then
                            assert busy='1' and done='0' report "early completion" severity failure;
                        end if;
                    end loop;
                    assert busy='0' and done='1' report "latency" severity failure;
                    if bv=0 then
                        assert q=vec(255,N) and r=vec(av,N) report "zero divisor" severity failure;
                    else
                        assert q=vec(av/bv,N) and r=vec(av mod bv,N) report "division result" severity failure;
                    end if;
                    start<='0';
                    step;
                    assert done='0' and busy='0' report "done width" severity failure;
                end loop;
            end loop;
            for abort_at in 0 to N-1 loop
                a<=(others=>'1');
                b<=vec(1,N);
                start<='1';
                step;
                start<='0';
                for k in 1 to abort_at loop
                    step;
                end loop;
                rst<='1';
                step;
                assert busy='0' and done='0' and q=vec(0,N) and r=vec(0,N) report "abort" severity failure;
                rst<='0';
                step;
            end loop;
            finished(2) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_sequential_restoring_divider" severity note;
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
