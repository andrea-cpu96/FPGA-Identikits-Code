-- Self-checking tests for identikit 1.1.3: 1:2 demultiplexer.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_demux_1_to_2 is end entity;
architecture test of tb_demux_1_to_2 is
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
        signal data,a0,a1:std_logic_vector(3 downto 0):=(others=>'0');
        signal s:std_logic:='0';
    begin
        u3:entity work.demux_1_to_2 generic map(4) port map(data,s,a0,a1);
        stimulus: process
        begin
            for x in 0 to 15 loop
                data<=vec(x,4);
                for k in 0 to 7 loop
                    s<=sl(k mod 2=1);
                    wait for 1 ns;
                    if k mod 2=0 then
                        assert a0=data and a1="0000" severity failure;
                    else
                        assert a1=data and a0="0000" severity failure;
                    end if;
                end loop;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_demux_1_to_2" severity note;
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
