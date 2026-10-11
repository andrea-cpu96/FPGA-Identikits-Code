-- Self-checking tests for identikit 8.1.3: Modulo-N counter.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_modulo_n_counter is end entity;
architecture test of tb_modulo_n_counter is
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
    signal finished: boolean_vector(0 to 1) := (others => false);
begin
    case_0: block
        constant N:positive:=1;
        signal clk:std_logic:='0';
        signal rst:std_logic:='0';
        signal modq:std_logic_vector(N-1 downto 0);
    begin
        clk<=not clk after 5 ns;
        u5:entity work.modulo_n_counter generic map(N,2**N) port map(clk,rst,modq);
        stimulus: process
            variable age:natural:=0;
        begin
            null;
            for trial in 0 to 2000 loop
                rst<=sl(trial mod 101=0);
                wait until rising_edge(clk);
                if rst='1' then
                    age:=0;
                else
                    null;
                    age:=age+1;
                end if;
                wait for 1 ns;
                assert modq=vec(age mod 2**N,N) report "modulo at full range" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant N:positive:=3;
        signal clk:std_logic:='0';
        signal rst:std_logic:='0';
        signal modq:std_logic_vector(N-1 downto 0);
    begin
        clk<=not clk after 5 ns;
        u5:entity work.modulo_n_counter generic map(N,2**N) port map(clk,rst,modq);
        stimulus: process
            variable age:natural:=0;
        begin
            null;
            for trial in 0 to 2000 loop
                rst<=sl(trial mod 101=0);
                wait until rising_edge(clk);
                if rst='1' then
                    age:=0;
                else
                    null;
                    age:=age+1;
                end if;
                wait for 1 ns;
                assert modq=vec(age mod 2**N,N) report "modulo at full range" severity failure;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_modulo_n_counter" severity note;
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
