-- Self-checking tests for identikit 2.1.5: N-input priority encoder.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_priority_encoder_n is end entity;
architecture test of tb_priority_encoder_n is
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
    signal finished: boolean_vector(0 to 5) := (others => false);
begin
    case_0: block
        constant N:positive:=1;
        constant W:positive:=1;
        signal d:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(W-1 downto 0);
        signal valid:std_logic;
    begin
        dut:entity work.priority_encoder_n generic map(N) port map(d,y,valid);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(N-1 downto 0);
            variable highest:natural;
        begin
            for pattern in 0 to 2**N-1 loop
                d<=vec(pattern,N);
                highest:=0;
                for position in 0 to N-1 loop
                    if (pattern/2**position) mod 2=1 then
                        highest:=position;
                    end if;
                end loop;
                wait for 1 ns;
                assert valid=sl(pattern/=0) and y=vec(highest,W)
                report "priority encoder binary pattern, highest priority or no request" severity failure;
            end loop;
            for position in 0 to N-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        d<=probe;
                        wait for 1 ns;
                        assert valid='0' and y=vec(0,W)
                        report "priority encoder must reject entire nonliteral request word" severity failure;
                    end loop;
                end loop;
            end loop;
            d<=vec(1,N);
            wait for 1 ns;
            assert valid='1' and y=vec(0,W) report "encoder recovery after nonliteral input" severity failure;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant N:positive:=2;
        constant W:positive:=1;
        signal d:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(W-1 downto 0);
        signal valid:std_logic;
    begin
        dut:entity work.priority_encoder_n generic map(N) port map(d,y,valid);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(N-1 downto 0);
            variable highest:natural;
        begin
            for pattern in 0 to 2**N-1 loop
                d<=vec(pattern,N);
                highest:=0;
                for position in 0 to N-1 loop
                    if (pattern/2**position) mod 2=1 then
                        highest:=position;
                    end if;
                end loop;
                wait for 1 ns;
                assert valid=sl(pattern/=0) and y=vec(highest,W)
                report "priority encoder binary pattern, highest priority or no request" severity failure;
            end loop;
            for position in 0 to N-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        d<=probe;
                        wait for 1 ns;
                        assert valid='0' and y=vec(0,W)
                        report "priority encoder must reject entire nonliteral request word" severity failure;
                    end loop;
                end loop;
            end loop;
            d<=vec(1,N);
            wait for 1 ns;
            assert valid='1' and y=vec(0,W) report "encoder recovery after nonliteral input" severity failure;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        constant N:positive:=3;
        constant W:positive:=2;
        signal d:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(W-1 downto 0);
        signal valid:std_logic;
    begin
        dut:entity work.priority_encoder_n generic map(N) port map(d,y,valid);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(N-1 downto 0);
            variable highest:natural;
        begin
            for pattern in 0 to 2**N-1 loop
                d<=vec(pattern,N);
                highest:=0;
                for position in 0 to N-1 loop
                    if (pattern/2**position) mod 2=1 then
                        highest:=position;
                    end if;
                end loop;
                wait for 1 ns;
                assert valid=sl(pattern/=0) and y=vec(highest,W)
                report "priority encoder binary pattern, highest priority or no request" severity failure;
            end loop;
            for position in 0 to N-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        d<=probe;
                        wait for 1 ns;
                        assert valid='0' and y=vec(0,W)
                        report "priority encoder must reject entire nonliteral request word" severity failure;
                    end loop;
                end loop;
            end loop;
            d<=vec(1,N);
            wait for 1 ns;
            assert valid='1' and y=vec(0,W) report "encoder recovery after nonliteral input" severity failure;
            finished(2) <= true;
            wait;
        end process;
    end block;
    case_3: block
        constant N:positive:=5;
        constant W:positive:=3;
        signal d:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(W-1 downto 0);
        signal valid:std_logic;
    begin
        dut:entity work.priority_encoder_n generic map(N) port map(d,y,valid);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(N-1 downto 0);
            variable highest:natural;
        begin
            for pattern in 0 to 2**N-1 loop
                d<=vec(pattern,N);
                highest:=0;
                for position in 0 to N-1 loop
                    if (pattern/2**position) mod 2=1 then
                        highest:=position;
                    end if;
                end loop;
                wait for 1 ns;
                assert valid=sl(pattern/=0) and y=vec(highest,W)
                report "priority encoder binary pattern, highest priority or no request" severity failure;
            end loop;
            for position in 0 to N-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        d<=probe;
                        wait for 1 ns;
                        assert valid='0' and y=vec(0,W)
                        report "priority encoder must reject entire nonliteral request word" severity failure;
                    end loop;
                end loop;
            end loop;
            d<=vec(1,N);
            wait for 1 ns;
            assert valid='1' and y=vec(0,W) report "encoder recovery after nonliteral input" severity failure;
            finished(3) <= true;
            wait;
        end process;
    end block;
    case_4: block
        constant N:positive:=8;
        constant W:positive:=3;
        signal d:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(W-1 downto 0);
        signal valid:std_logic;
    begin
        dut:entity work.priority_encoder_n generic map(N) port map(d,y,valid);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(N-1 downto 0);
            variable highest:natural;
        begin
            for pattern in 0 to 2**N-1 loop
                d<=vec(pattern,N);
                highest:=0;
                for position in 0 to N-1 loop
                    if (pattern/2**position) mod 2=1 then
                        highest:=position;
                    end if;
                end loop;
                wait for 1 ns;
                assert valid=sl(pattern/=0) and y=vec(highest,W)
                report "priority encoder binary pattern, highest priority or no request" severity failure;
            end loop;
            for position in 0 to N-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        d<=probe;
                        wait for 1 ns;
                        assert valid='0' and y=vec(0,W)
                        report "priority encoder must reject entire nonliteral request word" severity failure;
                    end loop;
                end loop;
            end loop;
            d<=vec(1,N);
            wait for 1 ns;
            assert valid='1' and y=vec(0,W) report "encoder recovery after nonliteral input" severity failure;
            finished(4) <= true;
            wait;
        end process;
    end block;
    case_5: block
        constant N:positive:=16;
        constant W:positive:=4;
        signal d:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(W-1 downto 0);
        signal valid:std_logic;
    begin
        dut:entity work.priority_encoder_n generic map(N) port map(d,y,valid);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(N-1 downto 0);
            variable highest:natural;
        begin
            for pattern in 0 to 2**N-1 loop
                d<=vec(pattern,N);
                highest:=0;
                for position in 0 to N-1 loop
                    if (pattern/2**position) mod 2=1 then
                        highest:=position;
                    end if;
                end loop;
                wait for 1 ns;
                assert valid=sl(pattern/=0) and y=vec(highest,W)
                report "priority encoder binary pattern, highest priority or no request" severity failure;
            end loop;
            for position in 0 to N-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        d<=probe;
                        wait for 1 ns;
                        assert valid='0' and y=vec(0,W)
                        report "priority encoder must reject entire nonliteral request word" severity failure;
                    end loop;
                end loop;
            end loop;
            d<=vec(1,N);
            wait for 1 ns;
            assert valid='1' and y=vec(0,W) report "encoder recovery after nonliteral input" severity failure;
            finished(5) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_priority_encoder_n" severity note;
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
