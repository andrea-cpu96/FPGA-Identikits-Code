-- Self-checking tests for identikit 12.1.3: Multiply-accumulate (MAC).
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_multiply_accumulate is end entity;
architecture test of tb_multiply_accumulate is
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
    signal finished: boolean_vector(0 to 3) := (others => false);
begin
    case_0: block
        constant N:positive:=1;
        constant A:positive:=1;
        signal clk:std_logic:='0';
        signal rst,en:std_logic:='0';
        signal a1,b1:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal mac:std_logic_vector(A-1 downto 0);
    begin
        clk<=not clk after 5 ns;
        u1:entity work.multiply_accumulate generic map(N,A) port map(clk,rst,en,a1,b1,mac);
        stimulus: process
            variable oldp,p,acc,seed:natural:=0;
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
                if rst='1' then
                    acc:=0;
                elsif en='1' then
                    acc:=(acc+p) mod 2**A;
                end if;
                wait for 1 ns;
                assert mac=vec(acc,A) report "MAC wrap/resize" severity failure;
                oldp:=p;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant N:positive:=4;
        constant A:positive:=3;
        signal clk:std_logic:='0';
        signal rst,en:std_logic:='0';
        signal a1,b1:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal mac:std_logic_vector(A-1 downto 0);
    begin
        clk<=not clk after 5 ns;
        u1:entity work.multiply_accumulate generic map(N,A) port map(clk,rst,en,a1,b1,mac);
        stimulus: process
            variable oldp,p,acc,seed:natural:=0;
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
                if rst='1' then
                    acc:=0;
                elsif en='1' then
                    acc:=(acc+p) mod 2**A;
                end if;
                wait for 1 ns;
                assert mac=vec(acc,A) report "MAC wrap/resize" severity failure;
                oldp:=p;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        constant N:positive:=4;
        constant A:positive:=8;
        signal clk:std_logic:='0';
        signal rst,en:std_logic:='0';
        signal a1,b1:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal mac:std_logic_vector(A-1 downto 0);
    begin
        clk<=not clk after 5 ns;
        u1:entity work.multiply_accumulate generic map(N,A) port map(clk,rst,en,a1,b1,mac);
        stimulus: process
            variable oldp,p,acc,seed:natural:=0;
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
                if rst='1' then
                    acc:=0;
                elsif en='1' then
                    acc:=(acc+p) mod 2**A;
                end if;
                wait for 1 ns;
                assert mac=vec(acc,A) report "MAC wrap/resize" severity failure;
                oldp:=p;
            end loop;
            finished(2) <= true;
            wait;
        end process;
    end block;
    case_3: block
        constant N:positive:=4;
        constant A:positive:=12;
        signal clk:std_logic:='0';
        signal rst,en:std_logic:='0';
        signal a1,b1:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal mac:std_logic_vector(A-1 downto 0);
    begin
        clk<=not clk after 5 ns;
        u1:entity work.multiply_accumulate generic map(N,A) port map(clk,rst,en,a1,b1,mac);
        stimulus: process
            variable oldp,p,acc,seed:natural:=0;
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
                if rst='1' then
                    acc:=0;
                elsif en='1' then
                    acc:=(acc+p) mod 2**A;
                end if;
                wait for 1 ns;
                assert mac=vec(acc,A) report "MAC wrap/resize" severity failure;
                oldp:=p;
            end loop;
            finished(3) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_multiply_accumulate" severity note;
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
