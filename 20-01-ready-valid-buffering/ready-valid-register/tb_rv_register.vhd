-- Self-checking tests for identikit 20.1.1: Ready/valid register.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_rv_register is end entity;
architecture test of tb_rv_register is
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
        signal rst,iv,ir,ov,orr:std_logic:='0';
        signal idata,odata:std_logic_vector(15 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u:entity work.rv_register generic map(16) port map(clk,rst,iv,idata,ir,ov,odata,orr);
        stimulus: process
            type queue_t is array(0 to 5000) of std_logic_vector(15 downto 0);
            variable queue:queue_t;
            variable head,tail,seq,n,seed:natural:=0;
            variable ti,takeout:boolean;
        begin
            rst<='1';
            wait until rising_edge(clk);
            wait for 1 ns;
            rst<='0';
            seed:=137;
            for k in 1 to 5000 loop
                -- Retain input data/valid until accepted.
                seed:=(seed*17+31) mod 65521;
                if iv='0' or ti then
                    iv<=sl(seed mod 3/=0);
                    idata<=vec(seq,16);
                end if;
                orr<=sl((seed/7) mod 4/=0);
                if k mod 211=0 then
                    rst<='1';
                else
                    rst<='0';
                end if;
                wait until rising_edge(clk);
                ti:=false;
                if rst='1' then
                    head:=tail;
                else
                    assert ov=sl(tail>head) report "queue validity pre-edge" severity failure;
                    if ov='1' then
                        assert odata=queue(head) report "queue head/stalled data" severity failure;
                    end if;
                    ti:=iv='1' and ir='1';
                    takeout:=ov='1' and orr='1';
                    if takeout then
                        head:=head+1;
                    end if;
                    if ti then
                        queue(tail):=idata;
                        tail:=tail+1;
                        seq:=seq+1;
                    end if;
                end if;
                wait for 1 ns;
                assert ov=sl(tail>head) report "queue validity after edge" severity failure;
                if ov='1' then
                    assert odata=queue(head) report "stored head" severity failure;
                end if;
            end loop;
            rst<='0';
            iv<='0';
            orr<='1';
            for k in 1 to 3 loop
                wait until rising_edge(clk);
                if ov='1' then
                    assert odata=queue(head) severity failure;
                    head:=head+1;
                end if;
                wait for 1 ns;
            end loop;
            assert head=tail and ov='0' and tail>1000 report "queue drain" severity failure;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_rv_register" severity note;
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
