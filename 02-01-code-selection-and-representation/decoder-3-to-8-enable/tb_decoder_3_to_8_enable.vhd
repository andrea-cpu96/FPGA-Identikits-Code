-- Self-checking tests for identikit 2.1.2: 3:8 decoder with enable.
-- Each case instantiates only this identikit. Models use sampled inputs.
-- Family stimulus/reference variables may be shared; only this DUT is checked.
-- Functional RTL verification does not model analog metastability or routing.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tb_decoder_3_to_8_enable is end entity;
architecture test of tb_decoder_3_to_8_enable is
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
        signal sel:std_logic_vector(2 downto 0):=(others=>'0');
        signal dece:std_logic_vector(7 downto 0);
        signal en:std_logic:='0';
    begin
        d1:entity work.decoder_3_to_8_enable port map(sel,en,dece);
        stimulus: process
            type table_t is array(0 to 15) of std_logic_vector(6 downto 0);
            constant expected:table_t:=("1111110","0110000","1101101","1111001","0110011","1011011","1011111","1110000","1111111","1111011","1110111","0011111","1001110","0111101","1001111","1000111");
        begin
            for x in 0 to 255 loop
                sel<=vec(x mod 8,3);
                en<=sl(x mod 2=1);
                wait for 1 ns;
                if x mod 2=1 then
                    assert dece=vec(2**(x mod 8),8) severity failure;
                else
                    assert dece=x"00" severity failure;
                end if;
            end loop;
            finished(0) <= true;
            wait;
        end process;
    end block;
    completion: process
    begin
        wait until finished = (finished'range => true);
        report "PASS tb_decoder_3_to_8_enable" severity note;
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
