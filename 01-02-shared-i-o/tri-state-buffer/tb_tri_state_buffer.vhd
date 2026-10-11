-- Self-checking tests for identikit 1.2.1: Tri-state buffer.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_tri_state_buffer is end entity;
architecture test of tb_tri_state_buffer is
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
        signal pad,din,dout,external:std_logic_vector(3 downto 0):=(others=>'Z');
        signal oe:std_logic:='0';
    begin
        pad<=external;
        u:entity work.tri_state_buffer generic map(4) port map(dout,oe,pad,din);
        stimulus: process
        begin
            external<="1010";
            dout<="0101";
            wait for 1 ns;
            assert din="1010" severity failure;
            external<=(others=>'Z');
            oe<='1';
            wait for 1 ns;
            assert din="0101" severity failure;
            external<="1010";
            wait for 1 ns;
            assert din="XXXX" severity failure;
            oe<='0';
            wait for 1 ns;
            assert din="1010" severity failure;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_tri_state_buffer" severity note;
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
