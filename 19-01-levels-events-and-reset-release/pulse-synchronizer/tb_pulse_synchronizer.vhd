-- Self-checking tests for identikit 19.1.2: Pulse synchronizer.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_pulse_synchronizer is end entity;
architecture test of tb_pulse_synchronizer is
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
        signal sc,dc:std_logic:='0';
        signal pi,po:std_logic:='0';
        signal received:natural:=0;
    begin
        sc<=not sc after 3 ns;
        dc<=not dc after 7 ns;
        u:entity work.pulse_synchronizer port map(sc,dc,pi,po);
        monitor:process variable prev:std_logic:='0';
    begin
        wait until rising_edge(dc);
        wait for 1 ns;
        assert not(prev='1' and po='1') report "pulse width" severity failure;
        if po='1' then
            received<=received+1;
        end if;
        prev:=po;
    end process;
    stimulus: process
    begin
        for k in 1 to 100 loop
            wait until falling_edge(sc);
            pi<='1';
            wait until falling_edge(sc);
            pi<='0';
            wait for 150 ns;
            assert received=k report "pulse transfer count" severity failure;
        end loop;
        finished(0) <= true;
        wait;
    end process;
end block;
case_1: block
    signal sc,dc:std_logic:='0';
    signal pi,po:std_logic:='0';
    signal received:natural:=0;
begin
    sc<=not sc after 7 ns;
    dc<=not dc after 3 ns;
    u:entity work.pulse_synchronizer port map(sc,dc,pi,po);
    monitor:process variable prev:std_logic:='0';
begin
    wait until rising_edge(dc);
    wait for 1 ns;
    assert not(prev='1' and po='1') report "pulse width" severity failure;
    if po='1' then
        received<=received+1;
    end if;
    prev:=po;
end process;
stimulus: process
begin
    for k in 1 to 100 loop
        wait until falling_edge(sc);
        pi<='1';
        wait until falling_edge(sc);
        pi<='0';
        wait for 150 ns;
        assert received=k report "pulse transfer count" severity failure;
    end loop;
    finished(1) <= true;
    wait;
end process;
end block;
case_2: block
    signal sc,dc:std_logic:='0';
    signal pi,po:std_logic:='0';
    signal received:natural:=0;
begin
    sc<=not sc after 5 ns;
    dc<=not dc after 5 ns;
    u:entity work.pulse_synchronizer port map(sc,dc,pi,po);
    monitor:process variable prev:std_logic:='0';
begin
    wait until rising_edge(dc);
    wait for 1 ns;
    assert not(prev='1' and po='1') report "pulse width" severity failure;
    if po='1' then
        received<=received+1;
    end if;
    prev:=po;
end process;
stimulus: process
begin
    for k in 1 to 100 loop
        wait until falling_edge(sc);
        pi<='1';
        wait until falling_edge(sc);
        pi<='0';
        wait for 150 ns;
        assert received=k report "pulse transfer count" severity failure;
    end loop;
    finished(2) <= true;
    wait;
end process;
end block;
completion: process
begin
    wait until finished = (finished'range => true);
    report "PASS tb_pulse_synchronizer" severity note;
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
