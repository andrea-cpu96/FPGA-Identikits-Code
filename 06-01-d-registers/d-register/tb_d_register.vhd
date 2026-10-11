-- Self-checking tests for identikit 6.1.2: D register.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_d_register is end entity;
architecture test of tb_d_register is
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
        signal rst,en,t,j,k,s,r:std_logic:='0';
        signal data,q0:std_logic_vector(7 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u0:entity work.d_register port map(clk,data,q0);
        stimulus: process
            variable seed:natural:=11;
        begin
            wait for 1 ns;
            rst<='1';
            en<='1';
            wait until rising_edge(clk);
            wait for 1 ns;
            rst<='0';
            for trial in 1 to 1000 loop
                seed:=(seed*17+31) mod 65521;
                data<=vec(seed mod 256,8);
                en<=sl(seed mod 3/=0);
                t<=sl(seed mod 2=1);
                j<=sl((seed/2) mod 2=1);
                k<=sl((seed/4) mod 2=1);
                s<=sl((seed/8) mod 3=1);
                r<=sl((seed/8) mod 3=2);
                rst<=sl(trial mod 37=0);
                wait for 1 ns;
                wait until rising_edge(clk);
                wait for 1 ns;
                assert q0=data report "register capture" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_d_register" severity note;
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
