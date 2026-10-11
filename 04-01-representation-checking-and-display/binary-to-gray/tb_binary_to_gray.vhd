-- Self-checking tests for identikit 4.1.2: Binary to Gray.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_binary_to_gray is end entity;
architecture test of tb_binary_to_gray is
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
        signal a,g:std_logic_vector(W-1 downto 0):=(others=>'0');
    begin
        g0:entity work.binary_to_gray generic map(W) port map(a,g);
        stimulus: process
            variable e:natural;
            variable signedv:integer;
        begin
            for x in 0 to 1 loop
                a<=vec(x,W);
                for k in 0 to 15 loop
                    for dr in 0 to 1 loop
                        wait for 1 ns;
                        assert unsigned(g)=(to_unsigned(x,W) xor to_unsigned(x/2,W)) report "gray" severity failure;
                        e:=(x/2**(k mod W))+(x mod 2**(k mod W))*2**(W-(k mod W));
                        signedv:=x;
                        if x>=2**(W-1) then
                            signedv:=x-2**W;
                        end if;
                        if dr=1 then
                            e:=(x*2**k) mod 2**W;
                        else
                            e:=x/2**k;
                        end if;
                    end loop;
                end loop;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant W:positive:=5;
        signal a,g:std_logic_vector(W-1 downto 0):=(others=>'0');
    begin
        g0:entity work.binary_to_gray generic map(W) port map(a,g);
        stimulus: process
            variable e:natural;
            variable signedv:integer;
        begin
            for x in 0 to 31 loop
                a<=vec(x,W);
                for k in 0 to 15 loop
                    for dr in 0 to 1 loop
                        wait for 1 ns;
                        assert unsigned(g)=(to_unsigned(x,W) xor to_unsigned(x/2,W)) report "gray" severity failure;
                        e:=(x/2**(k mod W))+(x mod 2**(k mod W))*2**(W-(k mod W));
                        signedv:=x;
                        if x>=2**(W-1) then
                            signedv:=x-2**W;
                        end if;
                        if dr=1 then
                            e:=(x*2**k) mod 2**W;
                        else
                            e:=x/2**k;
                        end if;
                    end loop;
                end loop;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        constant W:positive:=8;
        signal a,g:std_logic_vector(W-1 downto 0):=(others=>'0');
    begin
        g0:entity work.binary_to_gray generic map(W) port map(a,g);
        stimulus: process
            variable e:natural;
            variable signedv:integer;
        begin
            for x in 0 to 255 loop
                a<=vec(x,W);
                for k in 0 to 15 loop
                    for dr in 0 to 1 loop
                        wait for 1 ns;
                        assert unsigned(g)=(to_unsigned(x,W) xor to_unsigned(x/2,W)) report "gray" severity failure;
                        e:=(x/2**(k mod W))+(x mod 2**(k mod W))*2**(W-(k mod W));
                        signedv:=x;
                        if x>=2**(W-1) then
                            signedv:=x-2**W;
                        end if;
                        if dr=1 then
                            e:=(x*2**k) mod 2**W;
                        else
                            e:=x/2**k;
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
        report "PASS tb_binary_to_gray" severity note;
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
