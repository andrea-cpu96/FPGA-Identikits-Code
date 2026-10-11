-- Self-checking tests for identikit 17.1.1: Synchronous FIFO.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_synchronous_fifo is end entity;
architecture test of tb_synchronous_fifo is
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
        constant DEPTH:positive:=2;
        signal clk:std_logic:='0';
        signal rst,wr,rd,full,empty:std_logic:='0';
        signal din,dout:std_logic_vector(15 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u:entity work.synchronous_fifo generic map(16,1) port map(clk,rst,wr,rd,din,dout,full,empty);
        stimulus: process
            type queue_t is array(0 to 5000) of std_logic_vector(15 downto 0);
            variable queue:queue_t;
            variable head,tail,seed:natural:=0;
            variable pop,push:boolean;
            variable expected:std_logic_vector(15 downto 0);
        begin
            rst<='1';
            wait until rising_edge(clk);
            wait for 1 ns;
            rst<='0';
            seed:=79;
            for k in 1 to 5000 loop
                seed:=(seed*17+31) mod 65521;
                wr<=sl(seed mod 3/=0);
                rd<=sl((seed/11) mod 3/=0);
                din<=vec(k,16);
                if k mod 257=0 then
                    rst<='1';
                else
                    rst<='0';
                end if;
                wait until rising_edge(clk);
                pop:=false;
                assert full=sl(tail-head=DEPTH) and empty=sl(tail=head) report "FIFO flags" severity failure;
                if rst='1' then
                    head:=tail;
                else
                    pop:=rd='1' and tail>head;
                    push:=wr='1' and tail-head<DEPTH;
                    if pop then
                        expected:=queue(head);
                        head:=head+1;
                    end if;
                    if push then
                        queue(tail):=din;
                        tail:=tail+1;
                    end if;
                end if;
                wait for 1 ns;
                if pop then
                    assert dout=expected report "sync FIFO ordering" severity failure;
                end if;
                assert full=sl(tail-head=DEPTH) and empty=sl(tail=head) report "FIFO updated flags" severity failure;
            end loop;
            rst<='0';
            wr<='0';
            rd<='1';
            for k in 1 to DEPTH loop
                wait until rising_edge(clk);
                pop:=tail>head;
                if pop then
                    expected:=queue(head);
                    head:=head+1;
                end if;
                wait for 1 ns;
                if pop then
                    assert dout=expected severity failure;
                end if;
            end loop;
            assert empty='1' and tail=head report "FIFO drain" severity failure;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant DEPTH:positive:=8;
        signal clk:std_logic:='0';
        signal rst,wr,rd,full,empty:std_logic:='0';
        signal din,dout:std_logic_vector(15 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u:entity work.synchronous_fifo generic map(16,3) port map(clk,rst,wr,rd,din,dout,full,empty);
        stimulus: process
            type queue_t is array(0 to 5000) of std_logic_vector(15 downto 0);
            variable queue:queue_t;
            variable head,tail,seed:natural:=0;
            variable pop,push:boolean;
            variable expected:std_logic_vector(15 downto 0);
        begin
            rst<='1';
            wait until rising_edge(clk);
            wait for 1 ns;
            rst<='0';
            seed:=79;
            for k in 1 to 5000 loop
                seed:=(seed*17+31) mod 65521;
                wr<=sl(seed mod 3/=0);
                rd<=sl((seed/11) mod 3/=0);
                din<=vec(k,16);
                if k mod 257=0 then
                    rst<='1';
                else
                    rst<='0';
                end if;
                wait until rising_edge(clk);
                pop:=false;
                assert full=sl(tail-head=DEPTH) and empty=sl(tail=head) report "FIFO flags" severity failure;
                if rst='1' then
                    head:=tail;
                else
                    pop:=rd='1' and tail>head;
                    push:=wr='1' and tail-head<DEPTH;
                    if pop then
                        expected:=queue(head);
                        head:=head+1;
                    end if;
                    if push then
                        queue(tail):=din;
                        tail:=tail+1;
                    end if;
                end if;
                wait for 1 ns;
                if pop then
                    assert dout=expected report "sync FIFO ordering" severity failure;
                end if;
                assert full=sl(tail-head=DEPTH) and empty=sl(tail=head) report "FIFO updated flags" severity failure;
            end loop;
            rst<='0';
            wr<='0';
            rd<='1';
            for k in 1 to DEPTH loop
                wait until rising_edge(clk);
                pop:=tail>head;
                if pop then
                    expected:=queue(head);
                    head:=head+1;
                end if;
                wait for 1 ns;
                if pop then
                    assert dout=expected severity failure;
                end if;
            end loop;
            assert empty='1' and tail=head report "FIFO drain" severity failure;
            finished(1) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_synchronous_fifo" severity note;
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
