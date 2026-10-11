-- Self-checking tests for identikit 12.1.2: Pipelined multiplier.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_pipelined_multiplier is end entity;
architecture test of tb_pipelined_multiplier is
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
        constant N:positive:=1;
        signal clk:std_logic:='0';
        signal rst,en:std_logic:='0';
        signal a1,b1:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal prod:std_logic_vector(2*N-1 downto 0);
    begin
        clk<=not clk after 5 ns;
        u0:entity work.pipelined_multiplier generic map(N) port map(clk,a1,b1,prod);
        stimulus: process
            variable oldp,p,seed:natural:=0;
        begin
            seed:=317;
            for k in 0 to 1000 loop
                seed:=(seed*17+31) mod 65521;
                a1<=vec(seed mod 2**N,N);
                b1<=vec((seed/13) mod 2**N,N);
                rst<=sl(k mod 97=0);
                en<=sl(seed mod 3/=0);
                wait until rising_edge(clk);
                p:=to_integer(unsigned(a1))*to_integer(unsigned(b1));
                wait for 1 ns;
                if k>0 then
                    assert prod=vec(oldp,2*N) report "product pipeline" severity failure;
                end if;
                oldp:=p;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant N:positive:=4;
        signal clk:std_logic:='0';
        signal rst,en:std_logic:='0';
        signal a1,b1:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal prod:std_logic_vector(2*N-1 downto 0);
    begin
        clk<=not clk after 5 ns;
        u0:entity work.pipelined_multiplier generic map(N) port map(clk,a1,b1,prod);
        stimulus: process
            variable oldp,p,seed:natural:=0;
        begin
            seed:=317;
            for k in 0 to 1000 loop
                seed:=(seed*17+31) mod 65521;
                a1<=vec(seed mod 2**N,N);
                b1<=vec((seed/13) mod 2**N,N);
                rst<=sl(k mod 97=0);
                en<=sl(seed mod 3/=0);
                wait until rising_edge(clk);
                p:=to_integer(unsigned(a1))*to_integer(unsigned(b1));
                wait for 1 ns;
                if k>0 then
                    assert prod=vec(oldp,2*N) report "product pipeline" severity failure;
                end if;
                oldp:=p;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_pipelined_multiplier" severity note;
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
