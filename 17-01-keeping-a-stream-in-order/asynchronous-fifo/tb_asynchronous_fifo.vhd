-- Self-checking tests for identikit 17.1.2: Asynchronous FIFO.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_asynchronous_fifo is end entity;
architecture test of tb_asynchronous_fifo is
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
        signal wc,rc:std_logic:='0';
        signal wr,rd,full,empty:std_logic:='0';
        signal din,dout:std_logic_vector(15 downto 0):=(others=>'0');
        signal sent:natural:=0;
    begin
        wc<=not wc after 3 ns;
        rc<=not rc after 7 ns;
        u:entity work.asynchronous_fifo generic map(16,1) port map(wc,rc,wr,rd,din,dout,full,empty);
        writer:process variable seq,seed:natural:=0;
    begin
        wait until falling_edge(wc);
        seed:=(seed*17+31) mod 65521;
        wr<=sl(seq<1000 and seed mod 4/=0);
        din<=vec(seq,16);
        wait until rising_edge(wc);
        if wr='1' and full='0' then
            seq:=seq+1;
        end if;
        sent<=seq;
    end process;
    stimulus: process
        variable seq,seed:natural:=0;
        variable pop:boolean;
    begin
        while seq<1000 loop
            wait until falling_edge(rc);
            seed:=(seed*19+17) mod 65521;
            rd<=sl(seed mod 5/=0);
            wait until rising_edge(rc);
            pop:=rd='1' and empty='0';
            if pop then
                assert seq<sent report "async underflow" severity failure;
            end if;
            wait for 1 ns;
            if pop then
                assert dout=vec(seq,16) report "async ordering" severity failure;
                seq:=seq+1;
            end if;
        end loop;
        for k in 1 to 5 loop
            wait until rising_edge(rc);
            wait for 1 ns;
        end loop;
        assert empty='1' and sent=1000 report "async drain" severity failure;
        finished(0) <= true;
        wait;
    end process;
end block;
case_1: block
    signal wc,rc:std_logic:='0';
    signal wr,rd,full,empty:std_logic:='0';
    signal din,dout:std_logic_vector(15 downto 0):=(others=>'0');
    signal sent:natural:=0;
begin
    wc<=not wc after 7 ns;
    rc<=not rc after 3 ns;
    u:entity work.asynchronous_fifo generic map(16,1) port map(wc,rc,wr,rd,din,dout,full,empty);
    writer:process variable seq,seed:natural:=0;
begin
    wait until falling_edge(wc);
    seed:=(seed*17+31) mod 65521;
    wr<=sl(seq<1000 and seed mod 4/=0);
    din<=vec(seq,16);
    wait until rising_edge(wc);
    if wr='1' and full='0' then
        seq:=seq+1;
    end if;
    sent<=seq;
end process;
stimulus: process
    variable seq,seed:natural:=0;
    variable pop:boolean;
begin
    while seq<1000 loop
        wait until falling_edge(rc);
        seed:=(seed*19+17) mod 65521;
        rd<=sl(seed mod 5/=0);
        wait until rising_edge(rc);
        pop:=rd='1' and empty='0';
        if pop then
            assert seq<sent report "async underflow" severity failure;
        end if;
        wait for 1 ns;
        if pop then
            assert dout=vec(seq,16) report "async ordering" severity failure;
            seq:=seq+1;
        end if;
    end loop;
    for k in 1 to 5 loop
        wait until rising_edge(rc);
        wait for 1 ns;
    end loop;
    assert empty='1' and sent=1000 report "async drain" severity failure;
    finished(1) <= true;
    wait;
end process;
end block;
case_2: block
    signal wc,rc:std_logic:='0';
    signal wr,rd,full,empty:std_logic:='0';
    signal din,dout:std_logic_vector(15 downto 0):=(others=>'0');
    signal sent:natural:=0;
begin
    wc<=not wc after 5 ns;
    rc<=not rc after 5 ns;
    u:entity work.asynchronous_fifo generic map(16,1) port map(wc,rc,wr,rd,din,dout,full,empty);
    writer:process variable seq,seed:natural:=0;
begin
    wait until falling_edge(wc);
    seed:=(seed*17+31) mod 65521;
    wr<=sl(seq<1000 and seed mod 4/=0);
    din<=vec(seq,16);
    wait until rising_edge(wc);
    if wr='1' and full='0' then
        seq:=seq+1;
    end if;
    sent<=seq;
end process;
stimulus: process
    variable seq,seed:natural:=0;
    variable pop:boolean;
begin
    while seq<1000 loop
        wait until falling_edge(rc);
        seed:=(seed*19+17) mod 65521;
        rd<=sl(seed mod 5/=0);
        wait until rising_edge(rc);
        pop:=rd='1' and empty='0';
        if pop then
            assert seq<sent report "async underflow" severity failure;
        end if;
        wait for 1 ns;
        if pop then
            assert dout=vec(seq,16) report "async ordering" severity failure;
            seq:=seq+1;
        end if;
    end loop;
    for k in 1 to 5 loop
        wait until rising_edge(rc);
        wait for 1 ns;
    end loop;
    assert empty='1' and sent=1000 report "async drain" severity failure;
    finished(2) <= true;
    wait;
end process;
end block;
case_3: block
    signal wc,rc:std_logic:='0';
    signal wr,rd,full,empty:std_logic:='0';
    signal din,dout:std_logic_vector(15 downto 0):=(others=>'0');
    signal sent:natural:=0;
begin
    wc<=not wc after 3 ns;
    rc<=not rc after 7 ns;
    u:entity work.asynchronous_fifo generic map(16,3) port map(wc,rc,wr,rd,din,dout,full,empty);
    writer:process variable seq,seed:natural:=0;
begin
    wait until falling_edge(wc);
    seed:=(seed*17+31) mod 65521;
    wr<=sl(seq<1000 and seed mod 4/=0);
    din<=vec(seq,16);
    wait until rising_edge(wc);
    if wr='1' and full='0' then
        seq:=seq+1;
    end if;
    sent<=seq;
end process;
stimulus: process
    variable seq,seed:natural:=0;
    variable pop:boolean;
begin
    while seq<1000 loop
        wait until falling_edge(rc);
        seed:=(seed*19+17) mod 65521;
        rd<=sl(seed mod 5/=0);
        wait until rising_edge(rc);
        pop:=rd='1' and empty='0';
        if pop then
            assert seq<sent report "async underflow" severity failure;
        end if;
        wait for 1 ns;
        if pop then
            assert dout=vec(seq,16) report "async ordering" severity failure;
            seq:=seq+1;
        end if;
    end loop;
    for k in 1 to 5 loop
        wait until rising_edge(rc);
        wait for 1 ns;
    end loop;
    assert empty='1' and sent=1000 report "async drain" severity failure;
    finished(3) <= true;
    wait;
end process;
end block;
case_4: block
    signal wc,rc:std_logic:='0';
    signal wr,rd,full,empty:std_logic:='0';
    signal din,dout:std_logic_vector(15 downto 0):=(others=>'0');
    signal sent:natural:=0;
begin
    wc<=not wc after 7 ns;
    rc<=not rc after 3 ns;
    u:entity work.asynchronous_fifo generic map(16,3) port map(wc,rc,wr,rd,din,dout,full,empty);
    writer:process variable seq,seed:natural:=0;
begin
    wait until falling_edge(wc);
    seed:=(seed*17+31) mod 65521;
    wr<=sl(seq<1000 and seed mod 4/=0);
    din<=vec(seq,16);
    wait until rising_edge(wc);
    if wr='1' and full='0' then
        seq:=seq+1;
    end if;
    sent<=seq;
end process;
stimulus: process
    variable seq,seed:natural:=0;
    variable pop:boolean;
begin
    while seq<1000 loop
        wait until falling_edge(rc);
        seed:=(seed*19+17) mod 65521;
        rd<=sl(seed mod 5/=0);
        wait until rising_edge(rc);
        pop:=rd='1' and empty='0';
        if pop then
            assert seq<sent report "async underflow" severity failure;
        end if;
        wait for 1 ns;
        if pop then
            assert dout=vec(seq,16) report "async ordering" severity failure;
            seq:=seq+1;
        end if;
    end loop;
    for k in 1 to 5 loop
        wait until rising_edge(rc);
        wait for 1 ns;
    end loop;
    assert empty='1' and sent=1000 report "async drain" severity failure;
    finished(4) <= true;
    wait;
end process;
end block;
case_5: block
    signal wc,rc:std_logic:='0';
    signal wr,rd,full,empty:std_logic:='0';
    signal din,dout:std_logic_vector(15 downto 0):=(others=>'0');
    signal sent:natural:=0;
begin
    wc<=not wc after 5 ns;
    rc<=not rc after 5 ns;
    u:entity work.asynchronous_fifo generic map(16,3) port map(wc,rc,wr,rd,din,dout,full,empty);
    writer:process variable seq,seed:natural:=0;
begin
    wait until falling_edge(wc);
    seed:=(seed*17+31) mod 65521;
    wr<=sl(seq<1000 and seed mod 4/=0);
    din<=vec(seq,16);
    wait until rising_edge(wc);
    if wr='1' and full='0' then
        seq:=seq+1;
    end if;
    sent<=seq;
end process;
stimulus: process
    variable seq,seed:natural:=0;
    variable pop:boolean;
begin
    while seq<1000 loop
        wait until falling_edge(rc);
        seed:=(seed*19+17) mod 65521;
        rd<=sl(seed mod 5/=0);
        wait until rising_edge(rc);
        pop:=rd='1' and empty='0';
        if pop then
            assert seq<sent report "async underflow" severity failure;
        end if;
        wait for 1 ns;
        if pop then
            assert dout=vec(seq,16) report "async ordering" severity failure;
            seq:=seq+1;
        end if;
    end loop;
    for k in 1 to 5 loop
        wait until rising_edge(rc);
        wait for 1 ns;
    end loop;
    assert empty='1' and sent=1000 report "async drain" severity failure;
    finished(5) <= true;
    wait;
end process;
end block;
completion: process
begin
    wait until finished = (finished'range => true);
    report "PASS tb_asynchronous_fifo" severity note;
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
