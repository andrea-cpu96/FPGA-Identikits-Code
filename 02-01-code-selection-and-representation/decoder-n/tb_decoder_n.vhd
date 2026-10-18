-- Self-checking tests for identikit 2.1.3: N-output decoder.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_decoder_n is end entity;
architecture test of tb_decoder_n is
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
        signal sel:std_logic_vector(W-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(N-1 downto 0);
    begin
        dut:entity work.decoder_n generic map(N) port map(sel,y);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(W-1 downto 0);
            variable expected:std_logic_vector(N-1 downto 0);
        begin
            for code in 0 to 2**W-1 loop
                sel<=vec(code,W);
                expected:=(others=>'0');
                if code<N then
                    expected(code):='1';
                end if;
                wait for 1 ns;
                assert y=expected report "decoder binary selection or unused code" severity failure;
            end loop;
            for position in 0 to W-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        sel<=probe;
                        wait for 1 ns;
                        assert y=vec(0,N) report "decoder nonliteral selector must reject" severity failure;
                    end loop;
                end loop;
            end loop;
            sel<=vec(0,W);
            wait for 1 ns;
            assert y=vec(1,N) report "decoder recovery after nonliteral input" severity failure;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant N:positive:=2;
        constant W:positive:=1;
        signal sel:std_logic_vector(W-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(N-1 downto 0);
    begin
        dut:entity work.decoder_n generic map(N) port map(sel,y);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(W-1 downto 0);
            variable expected:std_logic_vector(N-1 downto 0);
        begin
            for code in 0 to 2**W-1 loop
                sel<=vec(code,W);
                expected:=(others=>'0');
                if code<N then
                    expected(code):='1';
                end if;
                wait for 1 ns;
                assert y=expected report "decoder binary selection or unused code" severity failure;
            end loop;
            for position in 0 to W-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        sel<=probe;
                        wait for 1 ns;
                        assert y=vec(0,N) report "decoder nonliteral selector must reject" severity failure;
                    end loop;
                end loop;
            end loop;
            sel<=vec(0,W);
            wait for 1 ns;
            assert y=vec(1,N) report "decoder recovery after nonliteral input" severity failure;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        constant N:positive:=3;
        constant W:positive:=2;
        signal sel:std_logic_vector(W-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(N-1 downto 0);
    begin
        dut:entity work.decoder_n generic map(N) port map(sel,y);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(W-1 downto 0);
            variable expected:std_logic_vector(N-1 downto 0);
        begin
            for code in 0 to 2**W-1 loop
                sel<=vec(code,W);
                expected:=(others=>'0');
                if code<N then
                    expected(code):='1';
                end if;
                wait for 1 ns;
                assert y=expected report "decoder binary selection or unused code" severity failure;
            end loop;
            for position in 0 to W-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        sel<=probe;
                        wait for 1 ns;
                        assert y=vec(0,N) report "decoder nonliteral selector must reject" severity failure;
                    end loop;
                end loop;
            end loop;
            sel<=vec(0,W);
            wait for 1 ns;
            assert y=vec(1,N) report "decoder recovery after nonliteral input" severity failure;
            finished(2) <= true;
            wait;
        end process;
    end block;
    case_3: block
        constant N:positive:=5;
        constant W:positive:=3;
        signal sel:std_logic_vector(W-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(N-1 downto 0);
    begin
        dut:entity work.decoder_n generic map(N) port map(sel,y);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(W-1 downto 0);
            variable expected:std_logic_vector(N-1 downto 0);
        begin
            for code in 0 to 2**W-1 loop
                sel<=vec(code,W);
                expected:=(others=>'0');
                if code<N then
                    expected(code):='1';
                end if;
                wait for 1 ns;
                assert y=expected report "decoder binary selection or unused code" severity failure;
            end loop;
            for position in 0 to W-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        sel<=probe;
                        wait for 1 ns;
                        assert y=vec(0,N) report "decoder nonliteral selector must reject" severity failure;
                    end loop;
                end loop;
            end loop;
            sel<=vec(0,W);
            wait for 1 ns;
            assert y=vec(1,N) report "decoder recovery after nonliteral input" severity failure;
            finished(3) <= true;
            wait;
        end process;
    end block;
    case_4: block
        constant N:positive:=8;
        constant W:positive:=3;
        signal sel:std_logic_vector(W-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(N-1 downto 0);
    begin
        dut:entity work.decoder_n generic map(N) port map(sel,y);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(W-1 downto 0);
            variable expected:std_logic_vector(N-1 downto 0);
        begin
            for code in 0 to 2**W-1 loop
                sel<=vec(code,W);
                expected:=(others=>'0');
                if code<N then
                    expected(code):='1';
                end if;
                wait for 1 ns;
                assert y=expected report "decoder binary selection or unused code" severity failure;
            end loop;
            for position in 0 to W-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        sel<=probe;
                        wait for 1 ns;
                        assert y=vec(0,N) report "decoder nonliteral selector must reject" severity failure;
                    end loop;
                end loop;
            end loop;
            sel<=vec(0,W);
            wait for 1 ns;
            assert y=vec(1,N) report "decoder recovery after nonliteral input" severity failure;
            finished(4) <= true;
            wait;
        end process;
    end block;
    case_5: block
        constant N:positive:=16;
        constant W:positive:=4;
        signal sel:std_logic_vector(W-1 downto 0):=(others=>'0');
        signal y:std_logic_vector(N-1 downto 0);
    begin
        dut:entity work.decoder_n generic map(N) port map(sel,y);
        stimulus: process
            constant bad:std_logic_vector(0 to 6):="UXZWLH-";
            variable probe:std_logic_vector(W-1 downto 0);
            variable expected:std_logic_vector(N-1 downto 0);
        begin
            for code in 0 to 2**W-1 loop
                sel<=vec(code,W);
                expected:=(others=>'0');
                if code<N then
                    expected(code):='1';
                end if;
                wait for 1 ns;
                assert y=expected report "decoder binary selection or unused code" severity failure;
            end loop;
            for position in 0 to W-1 loop
                for value in bad'range loop
                    for background in 0 to 1 loop
                        probe:=(others=>sl(background=1));
                        probe(position):=bad(value);
                        sel<=probe;
                        wait for 1 ns;
                        assert y=vec(0,N) report "decoder nonliteral selector must reject" severity failure;
                    end loop;
                end loop;
            end loop;
            sel<=vec(0,W);
            wait for 1 ns;
            assert y=vec(1,N) report "decoder recovery after nonliteral input" severity failure;
            finished(5) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_decoder_n" severity note;
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
