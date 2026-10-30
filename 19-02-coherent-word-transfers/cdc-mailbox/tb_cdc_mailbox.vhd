-- Self-checking tests for identikit 20.2.1: CDC request/acknowledge mailbox.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_cdc_mailbox is end entity;
architecture test of tb_cdc_mailbox is
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
        signal rst:std_logic:='1';
        signal sv,sr,dv,dr:std_logic:='0';
        signal sd,dd:std_logic_vector(15 downto 0):=(others=>'0');
        signal sent:natural:=0;
    begin
        sc<=not sc after 3 ns;
        dc<=not dc after 7 ns;
        u:entity work.cdc_mailbox generic map(16) port map(sc,rst,sv,sd,sr,dc,rst,dr,dv,dd);
        writer:process variable seq,seed:natural:=0;
        variable take:boolean:=true;
    begin
        wait until rst='0';
        while seq<1000 loop
            wait until falling_edge(sc);
            seed:=(seed*17+31) mod 65521;
            if take or sv='0' then
                sv<=sl(seed mod 3/=0);
                sd<=vec(seq,16);
            end if;
            wait until rising_edge(sc);
            take:=sv='1' and sr='1';
            if take then
                seq:=seq+1;
            end if;
            sent<=seq;
        end loop;
        wait until falling_edge(sc);
        sv<='0';
        wait;
    end process;
    stimulus: process
        variable seq,seed:natural:=0;
        variable stalled:boolean:=false;
        variable saved:std_logic_vector(15 downto 0);
    begin
        wait for 100 ns;
        rst<='0';
        while seq<1000 loop
            wait until falling_edge(dc);
            seed:=(seed*19+17) mod 65521;
            dr<=sl(seed mod 4=0);
            wait until rising_edge(dc);
            if stalled then
                assert dv='1' and dd=saved report "mailbox stall hold" severity failure;
            end if;
            if dv='1' and dr='1' then
                assert dd=vec(seq,16) and seq<sent report "mailbox ordering" severity failure;
                seq:=seq+1;
            end if;
            stalled:=dv='1' and dr='0';
            saved:=dd;
        end loop;
        wait for 100 ns;
        assert dv='0' and sr='1' and sent=1000 report "mailbox drain" severity failure;
        finished(0) <= true;
        wait;
    end process;
end block;
case_1: block
    signal sc,dc:std_logic:='0';
    signal rst:std_logic:='1';
    signal sv,sr,dv,dr:std_logic:='0';
    signal sd,dd:std_logic_vector(15 downto 0):=(others=>'0');
    signal sent:natural:=0;
begin
    sc<=not sc after 7 ns;
    dc<=not dc after 3 ns;
    u:entity work.cdc_mailbox generic map(16) port map(sc,rst,sv,sd,sr,dc,rst,dr,dv,dd);
    writer:process variable seq,seed:natural:=0;
    variable take:boolean:=true;
begin
    wait until rst='0';
    while seq<1000 loop
        wait until falling_edge(sc);
        seed:=(seed*17+31) mod 65521;
        if take or sv='0' then
            sv<=sl(seed mod 3/=0);
            sd<=vec(seq,16);
        end if;
        wait until rising_edge(sc);
        take:=sv='1' and sr='1';
        if take then
            seq:=seq+1;
        end if;
        sent<=seq;
    end loop;
    wait until falling_edge(sc);
    sv<='0';
    wait;
end process;
stimulus: process
    variable seq,seed:natural:=0;
    variable stalled:boolean:=false;
    variable saved:std_logic_vector(15 downto 0);
begin
    wait for 100 ns;
    rst<='0';
    while seq<1000 loop
        wait until falling_edge(dc);
        seed:=(seed*19+17) mod 65521;
        dr<=sl(seed mod 4=0);
        wait until rising_edge(dc);
        if stalled then
            assert dv='1' and dd=saved report "mailbox stall hold" severity failure;
        end if;
        if dv='1' and dr='1' then
            assert dd=vec(seq,16) and seq<sent report "mailbox ordering" severity failure;
            seq:=seq+1;
        end if;
        stalled:=dv='1' and dr='0';
        saved:=dd;
    end loop;
    wait for 100 ns;
    assert dv='0' and sr='1' and sent=1000 report "mailbox drain" severity failure;
    finished(1) <= true;
    wait;
end process;
end block;
case_2: block
    signal sc,dc:std_logic:='0';
    signal rst:std_logic:='1';
    signal sv,sr,dv,dr:std_logic:='0';
    signal sd,dd:std_logic_vector(15 downto 0):=(others=>'0');
    signal sent:natural:=0;
begin
    sc<=not sc after 5 ns;
    dc<=not dc after 5 ns;
    u:entity work.cdc_mailbox generic map(16) port map(sc,rst,sv,sd,sr,dc,rst,dr,dv,dd);
    writer:process variable seq,seed:natural:=0;
    variable take:boolean:=true;
begin
    wait until rst='0';
    while seq<1000 loop
        wait until falling_edge(sc);
        seed:=(seed*17+31) mod 65521;
        if take or sv='0' then
            sv<=sl(seed mod 3/=0);
            sd<=vec(seq,16);
        end if;
        wait until rising_edge(sc);
        take:=sv='1' and sr='1';
        if take then
            seq:=seq+1;
        end if;
        sent<=seq;
    end loop;
    wait until falling_edge(sc);
    sv<='0';
    wait;
end process;
stimulus: process
    variable seq,seed:natural:=0;
    variable stalled:boolean:=false;
    variable saved:std_logic_vector(15 downto 0);
begin
    wait for 100 ns;
    rst<='0';
    while seq<1000 loop
        wait until falling_edge(dc);
        seed:=(seed*19+17) mod 65521;
        dr<=sl(seed mod 4=0);
        wait until rising_edge(dc);
        if stalled then
            assert dv='1' and dd=saved report "mailbox stall hold" severity failure;
        end if;
        if dv='1' and dr='1' then
            assert dd=vec(seq,16) and seq<sent report "mailbox ordering" severity failure;
            seq:=seq+1;
        end if;
        stalled:=dv='1' and dr='0';
        saved:=dd;
    end loop;
    wait for 100 ns;
    assert dv='0' and sr='1' and sent=1000 report "mailbox drain" severity failure;
    finished(2) <= true;
    wait;
end process;
end block;
completion: process
begin
    wait until finished = (finished'range => true);
    report "PASS tb_cdc_mailbox" severity note;
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
