-- N-stage pipeline: data and valid move together, one stage per clock
-- Stage-0 capture reaches dout after N-1 elapsed clock periods; positive excludes N=0.

library ieee;
use ieee.std_logic_1164.all;

entity pipeline_register is
    generic (
        W : positive := 8;
        N : positive := 4
    );
    port (
        clk      : in  std_logic;
        din      : in  std_logic_vector(W-1 downto 0);
        din_vld  : in  std_logic;
        rst      : in  std_logic;
        dout     : out std_logic_vector(W-1 downto 0);
        dout_vld : out std_logic
    );
end entity pipeline_register;

architecture rtl of pipeline_register is

    type stage_t is array (0 to N-1) of std_logic_vector(W-1 downto 0);

    signal data_p  : stage_t;
    signal valid_p : std_logic_vector(0 to N-1);

begin

    process (clk)
    begin
        if rising_edge(clk) then
            data_p(0)  <= din;
            valid_p(0) <= din_vld;
            for i in 1 to N-1 loop
                data_p(i)  <= data_p(i-1);
                valid_p(i) <= valid_p(i-1);
            end loop;
            if rst = '1' then
                valid_p <= (others => '0');
            end if;
        end if;
    end process;

    dout     <= data_p(N-1);
    dout_vld <= valid_p(N-1);

end architecture rtl;
