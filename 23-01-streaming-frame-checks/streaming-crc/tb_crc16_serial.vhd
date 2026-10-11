-- Self-checking tests for identikit 23.1.1: Streaming CRC generator/checker.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_crc16_serial is end entity;
architecture test of tb_crc16_serial is
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
        signal rst:std_logic:='1';
        signal start,en,d,zero:std_logic:='0';
        signal crc:std_logic_vector(15 downto 0);
    begin
        clk<=not clk after 5 ns;
        dut:entity work.crc16_serial port map(clk,rst,start,en,d,crc,zero);
        stimulus: process
            constant msg:string:="123456789";
            variable v:natural;
            variable saved:std_logic_vector(15 downto 0);
            procedure step is begin
                wait until rising_edge(clk);
                wait for 1 ns;
            end;
        begin
            step;
            assert crc=x"FFFF" report "reset" severity failure;
            rst<='0';
            for j in msg'range loop
                v:=character'pos(msg(j));
                for k in 7 downto 0 loop
                    en<='1';
                    d<=sl((v/2**k) mod 2=1);
                    start<=sl(j=1 and k=7);
                    step;
                end loop;
            end loop;
            assert crc=x"29B1" report "123456789 check value" severity failure;
            saved:=crc;
            en<='0';
            start<='0';
            step;
            assert crc=saved report "hold" severity failure;
            for k in 15 downto 0 loop
                en<='1';
                d<=saved(k);
                step;
            end loop;
            assert crc=x"0000" and zero='1' report "appended CRC residue" severity failure;
            en<='0';
            start<='1';
            step;
            assert crc=x"FFFF" report "frame restart" severity failure;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_crc16_serial" severity note;
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
