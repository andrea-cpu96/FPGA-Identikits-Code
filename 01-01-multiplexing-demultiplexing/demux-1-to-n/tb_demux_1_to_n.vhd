-- Self-checking tests for identikit 1.1.4: 1:N demultiplexer.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_demux_1_to_n is end entity;
architecture test of tb_demux_1_to_n is
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
        signal data:std_logic_vector(3 downto 0):=(others=>'0');
        signal outputs:std_logic_vector(N*4-1 downto 0);
        signal sel:std_logic_vector(2 downto 0):=(others=>'0');
    begin
        u1:entity work.demux_1_to_n generic map(N,4,3) port map(data,sel,outputs);
        stimulus: process
        begin
            for x in 0 to 15 loop
                data<=vec(x,4);
                for k in 0 to 7 loop
                    sel<=vec(k,3);
                    wait for 1 ns;
                    for j in 0 to N-1 loop
                        if j=k then
                            assert outputs((j+1)*4-1 downto j*4)=data severity failure;
                        else
                            assert outputs((j+1)*4-1 downto j*4)="0000" severity failure;
                        end if;
                    end loop;
                end loop;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant N:positive:=4;
        signal data:std_logic_vector(3 downto 0):=(others=>'0');
        signal outputs:std_logic_vector(N*4-1 downto 0);
        signal sel:std_logic_vector(2 downto 0):=(others=>'0');
    begin
        u1:entity work.demux_1_to_n generic map(N,4,3) port map(data,sel,outputs);
        stimulus: process
        begin
            for x in 0 to 15 loop
                data<=vec(x,4);
                for k in 0 to 7 loop
                    sel<=vec(k,3);
                    wait for 1 ns;
                    for j in 0 to N-1 loop
                        if j=k then
                            assert outputs((j+1)*4-1 downto j*4)=data severity failure;
                        else
                            assert outputs((j+1)*4-1 downto j*4)="0000" severity failure;
                        end if;
                    end loop;
                end loop;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        constant N:positive:=5;
        signal data:std_logic_vector(3 downto 0):=(others=>'0');
        signal outputs:std_logic_vector(N*4-1 downto 0);
        signal sel:std_logic_vector(2 downto 0):=(others=>'0');
    begin
        u1:entity work.demux_1_to_n generic map(N,4,3) port map(data,sel,outputs);
        stimulus: process
        begin
            for x in 0 to 15 loop
                data<=vec(x,4);
                for k in 0 to 7 loop
                    sel<=vec(k,3);
                    wait for 1 ns;
                    for j in 0 to N-1 loop
                        if j=k then
                            assert outputs((j+1)*4-1 downto j*4)=data severity failure;
                        else
                            assert outputs((j+1)*4-1 downto j*4)="0000" severity failure;
                        end if;
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
        report "PASS tb_demux_1_to_n" severity note;
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
