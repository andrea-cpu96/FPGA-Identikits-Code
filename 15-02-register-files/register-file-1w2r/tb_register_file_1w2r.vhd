-- Self-checking tests for identikit 15.2.1: Register file: one write, two read ports.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_register_file_1w2r is end entity;
architecture test of tb_register_file_1w2r is
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
        signal we,web:std_logic:='0';
        signal a,b:std_logic_vector(2 downto 0):=(others=>'0');
        signal da,ra,rb:std_logic_vector(7 downto 0):=(others=>'0');
    begin
        clk<=not clk after 5 ns;
        u3:entity work.register_file_1w2r generic map(8,3) port map(clk,we,a,a,b,da,ra,rb);
        stimulus: process
            type memory_t is array(0 to 7) of std_logic_vector(7 downto 0);
            variable single_mem:memory_t:=(others=>(others=>'U'));
            constant romdata:memory_t:=(x"12",x"34",x"56",x"78",x"9A",x"BC",x"00",x"00");
            variable ai,bi,seed:natural:=0;
        begin
            seed:=91;
            for k in 0 to 1000 loop
                seed:=(seed*17+31) mod 65521;
                ai:=k mod 8;
                bi:=(ai+1+(seed mod 7)) mod 8;
                a<=vec(ai,3);
                b<=vec(bi,3);
                da<=vec(seed mod 256,8);
                we<=sl(k<8 or seed mod 3/=0);
                web<=sl(k>=8 and seed mod 4=0);
                wait until rising_edge(clk);
                if we='1' then
                    single_mem(ai):=da;
                end if;
                wait for 1 ns;
                assert ra=single_mem(ai) and rb=single_mem(bi) report "register file/ROM" severity failure;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_register_file_1w2r" severity note;
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
