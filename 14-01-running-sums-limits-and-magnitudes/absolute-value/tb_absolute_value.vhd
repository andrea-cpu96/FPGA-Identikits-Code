-- Self-checking tests for identikit 14.1.3: Absolute value.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_absolute_value is end entity;
architecture test of tb_absolute_value is
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
        constant W:positive:=1;
        signal a,ab:std_logic_vector(W-1 downto 0):=(others=>'0');
    begin
        u5:entity work.absolute_value generic map(W) port map(a,ab);
        stimulus: process
            variable x,y,t:integer;
        begin
            for av in 0 to 1 loop
                for bv in 0 to 1 loop
                    for cv in 0 to 1 loop
                        a<=vec(av,W);
                        wait for 1 ns;
                        if cv=0 then
                            t:=av+bv;
                        else
                            t:=av-bv;
                        end if;
                        x:=av;
                        y:=bv;
                        if x>=1 then
                            x:=x-2;
                        end if;
                        if y>=1 then
                            y:=y-2;
                        end if;
                        t:=av+bv;
                        if t>1 then
                            t:=1;
                        end if;
                        assert ab=vec(abs(x),W) report "sat abs product" severity failure;
                    end loop;
                end loop;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant W:positive:=4;
        signal a,ab:std_logic_vector(W-1 downto 0):=(others=>'0');
    begin
        u5:entity work.absolute_value generic map(W) port map(a,ab);
        stimulus: process
            variable x,y,t:integer;
        begin
            for av in 0 to 15 loop
                for bv in 0 to 15 loop
                    for cv in 0 to 1 loop
                        a<=vec(av,W);
                        wait for 1 ns;
                        if cv=0 then
                            t:=av+bv;
                        else
                            t:=av-bv;
                        end if;
                        x:=av;
                        y:=bv;
                        if x>=8 then
                            x:=x-16;
                        end if;
                        if y>=8 then
                            y:=y-16;
                        end if;
                        t:=av+bv;
                        if t>15 then
                            t:=15;
                        end if;
                        assert ab=vec(abs(x),W) report "sat abs product" severity failure;
                    end loop;
                end loop;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        constant W:positive:=8;
        signal a,ab:std_logic_vector(W-1 downto 0):=(others=>'0');
    begin
        u5:entity work.absolute_value generic map(W) port map(a,ab);
        stimulus: process
            variable x,y,t:integer;
        begin
            for av in 0 to 255 loop
                for bv in 0 to 255 loop
                    for cv in 0 to 1 loop
                        a<=vec(av,W);
                        wait for 1 ns;
                        if cv=0 then
                            t:=av+bv;
                        else
                            t:=av-bv;
                        end if;
                        x:=av;
                        y:=bv;
                        if x>=128 then
                            x:=x-256;
                        end if;
                        if y>=128 then
                            y:=y-256;
                        end if;
                        t:=av+bv;
                        if t>255 then
                            t:=255;
                        end if;
                        assert ab=vec(abs(x),W) report "sat abs product" severity failure;
                    end loop;
                end loop;
            end loop;
            finished(2) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_absolute_value" severity note;
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
