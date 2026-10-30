-- Self-checking tests for identikit 19.1.2: Sampling debouncer.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_sampling_debouncer is end entity;
architecture test of tb_sampling_debouncer is
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
        signal clk:std_logic:='0';
        signal btn,ds:std_logic:='0';
    begin
        clk<=not clk after 5 ns;
        u1:entity work.sampling_debouncer generic map(1) port map(clk,btn,ds);
        stimulus: process
            type samples_t is array(0 to 2002) of std_logic;
            variable samples:samples_t:=(others=>'0');
            variable count1,count0,seed:natural:=0;
            variable sample_expected:std_logic:='0';
            variable all1,all0:boolean;
        begin
            seed:=493;
            for k in 2 to 2000 loop
                -- Alternating bounce bursts plus long stable intervals.
                seed:=(seed*17+31) mod 65521;
                if k mod 100<30 then
                    btn<=sl(seed mod 2=1);
                else
                    btn<=sl((k/100) mod 2=1);
                end if;
                wait until rising_edge(clk);
                samples(k):=btn;
                if samples(k-2)='1' then
                    count1:=count1+1;
                    count0:=0;
                else
                    count0:=count0+1;
                    count1:=0;
                end if;
                all1:=true;
                all0:=true;
                for j in 0 to 0 loop
                    if k>=3+j then
                        all1:=all1 and samples(k-3-j)='1';
                        all0:=all0 and samples(k-3-j)='0';
                    else
                        all1:=false;
                    end if;
                end loop;
                if all1 then
                    sample_expected:='1';
                elsif all0 then
                    sample_expected:='0';
                end if;
                wait for 1 ns;
                assert ds=sample_expected report "debounce threshold" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        signal clk:std_logic:='0';
        signal btn,ds:std_logic:='0';
    begin
        clk<=not clk after 5 ns;
        u1:entity work.sampling_debouncer generic map(4) port map(clk,btn,ds);
        stimulus: process
            type samples_t is array(0 to 2002) of std_logic;
            variable samples:samples_t:=(others=>'0');
            variable count1,count0,seed:natural:=0;
            variable sample_expected:std_logic:='0';
            variable all1,all0:boolean;
        begin
            seed:=493;
            for k in 2 to 2000 loop
                -- Alternating bounce bursts plus long stable intervals.
                seed:=(seed*17+31) mod 65521;
                if k mod 100<30 then
                    btn<=sl(seed mod 2=1);
                else
                    btn<=sl((k/100) mod 2=1);
                end if;
                wait until rising_edge(clk);
                samples(k):=btn;
                if samples(k-2)='1' then
                    count1:=count1+1;
                    count0:=0;
                else
                    count0:=count0+1;
                    count1:=0;
                end if;
                all1:=true;
                all0:=true;
                for j in 0 to 3 loop
                    if k>=3+j then
                        all1:=all1 and samples(k-3-j)='1';
                        all0:=all0 and samples(k-3-j)='0';
                    else
                        all1:=false;
                    end if;
                end loop;
                if all1 then
                    sample_expected:='1';
                elsif all0 then
                    sample_expected:='0';
                end if;
                wait for 1 ns;
                assert ds=sample_expected report "debounce threshold" severity failure;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        signal clk:std_logic:='0';
        signal btn,ds:std_logic:='0';
    begin
        clk<=not clk after 5 ns;
        u1:entity work.sampling_debouncer generic map(8) port map(clk,btn,ds);
        stimulus: process
            type samples_t is array(0 to 2002) of std_logic;
            variable samples:samples_t:=(others=>'0');
            variable count1,count0,seed:natural:=0;
            variable sample_expected:std_logic:='0';
            variable all1,all0:boolean;
        begin
            seed:=493;
            for k in 2 to 2000 loop
                -- Alternating bounce bursts plus long stable intervals.
                seed:=(seed*17+31) mod 65521;
                if k mod 100<30 then
                    btn<=sl(seed mod 2=1);
                else
                    btn<=sl((k/100) mod 2=1);
                end if;
                wait until rising_edge(clk);
                samples(k):=btn;
                if samples(k-2)='1' then
                    count1:=count1+1;
                    count0:=0;
                else
                    count0:=count0+1;
                    count1:=0;
                end if;
                all1:=true;
                all0:=true;
                for j in 0 to 7 loop
                    if k>=3+j then
                        all1:=all1 and samples(k-3-j)='1';
                        all0:=all0 and samples(k-3-j)='0';
                    else
                        all1:=false;
                    end if;
                end loop;
                if all1 then
                    sample_expected:='1';
                elsif all0 then
                    sample_expected:='0';
                end if;
                wait for 1 ns;
                assert ds=sample_expected report "debounce threshold" severity failure;
            end loop;
            finished(2) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_sampling_debouncer" severity note;
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
