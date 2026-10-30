-- Self-checking tests for identikit 22.1.1: Rising-edge detector.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_rising_edge_detector is end entity;
architecture test of tb_rising_edge_detector is
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
        signal rst,x,ri:std_logic:='0';
        signal req:std_logic_vector(3 downto 0):=(others=>'0');
        signal done:std_logic:='0';
    begin
        clk<=not clk after 5 ns;
        u4:entity work.rising_edge_detector port map(clk,x,ri);
        stimulus: process
            variable ms:natural:=0;
            variable prev:std_logic:='0';
            variable emr,emf,eme:boolean;
            variable mf,mr:std_logic_vector(3 downto 0):=(others=>'0');
            variable last:natural:=3;
            variable idx,seed:natural:=0;
        begin
            seed:=13;
            for trial in 0 to 5000 loop
                seed:=(seed*17+31) mod 65521;
                rst<=sl(trial mod 101=0);
                x<=sl(seed mod 2=1);
                req<=vec((seed/7) mod 16,4);
                done<=sl(seed mod 3=0);
                wait for 1 ns;
                wait until rising_edge(clk);
                emr:=x='1' and prev='0';
                emf:=x='0' and prev='1';
                eme:=x/=prev;
                prev:=x;
                if rst='1' then
                    ms:=0;
                    mf:=(others=>'0');
                    mr:=(others=>'0');
                    last:=3;
                else
                    if ms=2 then
                        ms:=0;
                    elsif x='1' then
                        ms:=ms+1;
                    end if;
                    if mf="0000" or done='1' then
                        mf:="0000";
                        for j in 0 to 3 loop
                            if req(j)='1' then
                                mf(j):='1';
                                exit;
                            end if;
                        end loop;
                    end if;
                    if mr="0000" or done='1' then
                        mr:="0000";
                        for j in 1 to 4 loop
                            idx:=(last+j) mod 4;
                            if req(idx)='1' then
                                mr(idx):='1';
                                last:=idx;
                                exit;
                            end if;
                        end loop;
                    end if;
                end if;
                wait for 1 ns;
                assert ri=sl(emr) report "edge detect" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_rising_edge_detector" severity note;
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
