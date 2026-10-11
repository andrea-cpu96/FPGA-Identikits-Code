-- Self-checking tests for identikit 8.1.1: Free-running up counter.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_free_running_up_counter is end entity;
architecture test of tb_free_running_up_counter is
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
        signal rst,en,dir,load,start:std_logic:='0';
        signal d,up:std_logic_vector(N-1 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u0:entity work.free_running_up_counter generic map(N) port map(clk,rst,up);
        stimulus: process
            variable cu,cs,ct,seed:natural:=0;
            variable delta:integer;
        begin
            seed:=937;
            for trial in 0 to 2000 loop
                seed:=(seed*17+31) mod 65521;
                rst<=sl(trial mod 503=0);
                en<=sl(seed mod 4/=0);
                dir<=sl((seed/7) mod 2=1);
                load<=sl(seed mod 11=0);
                start<=sl(seed mod 31=0);
                d<=vec(seed mod 2**N,N);
                wait until rising_edge(clk);
                if dir='1' then
                    delta:=1;
                else
                    delta:=-1;
                end if;
                if rst='1' then
                    cu:=0;
                    cs:=0;
                    ct:=0;
                else
                    cu:=(cu+1) mod 2**N;
                    if en='1' then
                        if (delta=1 and cs<2**N-1) or (delta=-1 and cs>0) then
                            cs:=cs+delta;
                        end if;
                    end if;
                    if start='1' then
                        ct:=to_integer(unsigned(d));
                    elsif ct>0 then
                        ct:=ct-1;
                    end if;
                end if;
                wait for 1 ns;
                assert up=vec(cu,N) report "counter" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant N:positive:=4;
        signal clk:std_logic:='0';
        signal rst,en,dir,load,start:std_logic:='0';
        signal d,up:std_logic_vector(N-1 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u0:entity work.free_running_up_counter generic map(N) port map(clk,rst,up);
        stimulus: process
            variable cu,cs,ct,seed:natural:=0;
            variable delta:integer;
        begin
            seed:=937;
            for trial in 0 to 2000 loop
                seed:=(seed*17+31) mod 65521;
                rst<=sl(trial mod 503=0);
                en<=sl(seed mod 4/=0);
                dir<=sl((seed/7) mod 2=1);
                load<=sl(seed mod 11=0);
                start<=sl(seed mod 31=0);
                d<=vec(seed mod 2**N,N);
                wait until rising_edge(clk);
                if dir='1' then
                    delta:=1;
                else
                    delta:=-1;
                end if;
                if rst='1' then
                    cu:=0;
                    cs:=0;
                    ct:=0;
                else
                    cu:=(cu+1) mod 2**N;
                    if en='1' then
                        if (delta=1 and cs<2**N-1) or (delta=-1 and cs>0) then
                            cs:=cs+delta;
                        end if;
                    end if;
                    if start='1' then
                        ct:=to_integer(unsigned(d));
                    elsif ct>0 then
                        ct:=ct-1;
                    end if;
                end if;
                wait for 1 ns;
                assert up=vec(cu,N) report "counter" severity failure;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        constant N:positive:=8;
        signal clk:std_logic:='0';
        signal rst,en,dir,load,start:std_logic:='0';
        signal d,up:std_logic_vector(N-1 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u0:entity work.free_running_up_counter generic map(N) port map(clk,rst,up);
        stimulus: process
            variable cu,cs,ct,seed:natural:=0;
            variable delta:integer;
        begin
            seed:=937;
            for trial in 0 to 2000 loop
                seed:=(seed*17+31) mod 65521;
                rst<=sl(trial mod 503=0);
                en<=sl(seed mod 4/=0);
                dir<=sl((seed/7) mod 2=1);
                load<=sl(seed mod 11=0);
                start<=sl(seed mod 31=0);
                d<=vec(seed mod 2**N,N);
                wait until rising_edge(clk);
                if dir='1' then
                    delta:=1;
                else
                    delta:=-1;
                end if;
                if rst='1' then
                    cu:=0;
                    cs:=0;
                    ct:=0;
                else
                    cu:=(cu+1) mod 2**N;
                    if en='1' then
                        if (delta=1 and cs<2**N-1) or (delta=-1 and cs>0) then
                            cs:=cs+delta;
                        end if;
                    end if;
                    if start='1' then
                        ct:=to_integer(unsigned(d));
                    elsif ct>0 then
                        ct:=ct-1;
                    end if;
                end if;
                wait for 1 ns;
                assert up=vec(cu,N) report "counter" severity failure;
            end loop;
            finished(2) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_free_running_up_counter" severity note;
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
