-- Self-checking tests for identikit 9.2.3: PWM generator.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_pwm_generator is end entity;
architecture test of tb_pwm_generator is
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
        constant PERIOD:positive:=1;
        signal clk:std_logic:='0';
        signal rst:std_logic:='0';
        signal duty:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal pwm:std_logic;
    begin
        clk<=not clk after 5 ns;
        u0:entity work.pwm_generator generic map(N,PERIOD) port map(clk,rst,duty,pwm);
        stimulus: process
            variable age,frame_duty,seed:natural:=0;
            variable epwm:boolean;
        begin
            seed:=751;
            for trial in 0 to 2000 loop
                seed:=(seed*17+31) mod 65521;
                rst<=sl(trial mod 101=0);
                duty<=vec(seed mod 2**N,N);
                wait until rising_edge(clk);
                if rst='1' then
                    age:=0;
                    epwm:=false;
                else
                    if age mod PERIOD=0 then
                        frame_duty:=to_integer(unsigned(duty));
                    end if;
                    epwm:=age mod PERIOD<frame_duty;
                    age:=age+1;
                end if;
                wait for 1 ns;
                assert pwm=sl(epwm) report "PWM duty/boundary" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    case_1: block
        constant N:positive:=3;
        constant PERIOD:positive:=3;
        signal clk:std_logic:='0';
        signal rst:std_logic:='0';
        signal duty:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal pwm:std_logic;
    begin
        clk<=not clk after 5 ns;
        u0:entity work.pwm_generator generic map(N,PERIOD) port map(clk,rst,duty,pwm);
        stimulus: process
            variable age,frame_duty,seed:natural:=0;
            variable epwm:boolean;
        begin
            seed:=751;
            for trial in 0 to 2000 loop
                seed:=(seed*17+31) mod 65521;
                rst<=sl(trial mod 101=0);
                duty<=vec(seed mod 2**N,N);
                wait until rising_edge(clk);
                if rst='1' then
                    age:=0;
                    epwm:=false;
                else
                    if age mod PERIOD=0 then
                        frame_duty:=to_integer(unsigned(duty));
                    end if;
                    epwm:=age mod PERIOD<frame_duty;
                    age:=age+1;
                end if;
                wait for 1 ns;
                assert pwm=sl(epwm) report "PWM duty/boundary" severity failure;
            end loop;
            finished(1) <= true;
            wait;
        end process;
    end block;
    case_2: block
        constant N:positive:=3;
        constant PERIOD:positive:=7;
        signal clk:std_logic:='0';
        signal rst:std_logic:='0';
        signal duty:std_logic_vector(N-1 downto 0):=(others=>'0');
        signal pwm:std_logic;
    begin
        clk<=not clk after 5 ns;
        u0:entity work.pwm_generator generic map(N,PERIOD) port map(clk,rst,duty,pwm);
        stimulus: process
            variable age,frame_duty,seed:natural:=0;
            variable epwm:boolean;
        begin
            seed:=751;
            for trial in 0 to 2000 loop
                seed:=(seed*17+31) mod 65521;
                rst<=sl(trial mod 101=0);
                duty<=vec(seed mod 2**N,N);
                wait until rising_edge(clk);
                if rst='1' then
                    age:=0;
                    epwm:=false;
                else
                    if age mod PERIOD=0 then
                        frame_duty:=to_integer(unsigned(duty));
                    end if;
                    epwm:=age mod PERIOD<frame_duty;
                    age:=age+1;
                end if;
                wait for 1 ns;
                assert pwm=sl(epwm) report "PWM duty/boundary" severity failure;
            end loop;
            finished(2) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_pwm_generator" severity note;
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
