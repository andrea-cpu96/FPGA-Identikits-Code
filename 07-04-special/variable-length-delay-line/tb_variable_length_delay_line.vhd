-- Self-checking tests for identikit 7.4.1: Variable-length delay line.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_variable_length_delay_line is end entity;
architecture test of tb_variable_length_delay_line is
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
        signal clk:std_logic:='0';
        signal rst,si,load,en,tap:std_logic:='0';
        signal sel:std_logic_vector(1 downto 0):=(others=>'0');
        signal tapsel:std_logic_vector(2 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u10:entity work.variable_length_delay_line generic map(N,3) port map(clk,rst,si,tapsel,tap);
        stimulus: process
            type pipe_t is array(0 to N-1) of std_logic_vector(7 downto 0);
            variable sh,jc,seed:natural:=0;
            variable eb:natural;
        begin
            seed:=83;
            for trial in 0 to 1000 loop
                rst<=sl(trial mod 103=0);
                seed:=(seed*17+31) mod 65521;
                si<=sl(seed mod 2=1);
                load<=sl(seed mod 7=0);
                en<=sl(seed mod 3/=0);
                tapsel<=vec(trial mod N,3);
                wait until rising_edge(clk);
                if rst='1' then
                    sh:=0;
                    jc:=0;
                else
                    sh:=(sh*2+boolean'pos(si='1')) mod 2**N;
                    case to_integer(unsigned(sel)) is
                    when 1=>null;
                    when 2=>null;
                    when 3=>null;
                    when others=>null;
                end case;
                jc:=(jc+1) mod (2*N);
            end if;
            wait for 1 ns;
            if jc<=N then
                eb:=2**N-2**(N-jc);
            else
                eb:=2**(2*N-jc)-1;
            end if;
            assert tap=sl((sh/2**(trial mod N)) mod 2=1) report "tap history" severity failure;
        end loop;
        finished(0) <= true;
        wait;
    end process;
end block;
case_1: block
    constant N:positive:=5;
    signal clk:std_logic:='0';
    signal rst,si,load,en,tap:std_logic:='0';
    signal sel:std_logic_vector(1 downto 0):=(others=>'0');
    signal tapsel:std_logic_vector(2 downto 0):=(others=>'0');
begin
    clk<=not clk after 5 ns;
    u10:entity work.variable_length_delay_line generic map(N,3) port map(clk,rst,si,tapsel,tap);
    stimulus: process
        type pipe_t is array(0 to N-1) of std_logic_vector(7 downto 0);
        variable sh,jc,seed:natural:=0;
        variable eb:natural;
    begin
        seed:=83;
        for trial in 0 to 1000 loop
            rst<=sl(trial mod 103=0);
            seed:=(seed*17+31) mod 65521;
            si<=sl(seed mod 2=1);
            load<=sl(seed mod 7=0);
            en<=sl(seed mod 3/=0);
            tapsel<=vec(trial mod N,3);
            wait until rising_edge(clk);
            if rst='1' then
                sh:=0;
                jc:=0;
            else
                sh:=(sh*2+boolean'pos(si='1')) mod 2**N;
                case to_integer(unsigned(sel)) is
                when 1=>null;
                when 2=>null;
                when 3=>null;
                when others=>null;
            end case;
            jc:=(jc+1) mod (2*N);
        end if;
        wait for 1 ns;
        if jc<=N then
            eb:=2**N-2**(N-jc);
        else
            eb:=2**(2*N-jc)-1;
        end if;
        assert tap=sl((sh/2**(trial mod N)) mod 2=1) report "tap history" severity failure;
    end loop;
    finished(1) <= true;
    wait;
end process;
end block;
case_2: block
    constant N:positive:=8;
    signal clk:std_logic:='0';
    signal rst,si,load,en,tap:std_logic:='0';
    signal sel:std_logic_vector(1 downto 0):=(others=>'0');
    signal tapsel:std_logic_vector(2 downto 0):=(others=>'0');
begin
    clk<=not clk after 5 ns;
    u10:entity work.variable_length_delay_line generic map(N,3) port map(clk,rst,si,tapsel,tap);
    stimulus: process
        type pipe_t is array(0 to N-1) of std_logic_vector(7 downto 0);
        variable sh,jc,seed:natural:=0;
        variable eb:natural;
    begin
        seed:=83;
        for trial in 0 to 1000 loop
            rst<=sl(trial mod 103=0);
            seed:=(seed*17+31) mod 65521;
            si<=sl(seed mod 2=1);
            load<=sl(seed mod 7=0);
            en<=sl(seed mod 3/=0);
            tapsel<=vec(trial mod N,3);
            wait until rising_edge(clk);
            if rst='1' then
                sh:=0;
                jc:=0;
            else
                sh:=(sh*2+boolean'pos(si='1')) mod 2**N;
                case to_integer(unsigned(sel)) is
                when 1=>null;
                when 2=>null;
                when 3=>null;
                when others=>null;
            end case;
            jc:=(jc+1) mod (2*N);
        end if;
        wait for 1 ns;
        if jc<=N then
            eb:=2**N-2**(N-jc);
        else
            eb:=2**(2*N-jc)-1;
        end if;
        assert tap=sl((sh/2**(trial mod N)) mod 2=1) report "tap history" severity failure;
    end loop;
    finished(2) <= true;
    wait;
end process;
end block;
completion: process
begin
    wait until finished = (finished'range => true);
    report "PASS tb_variable_length_delay_line" severity note;
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
