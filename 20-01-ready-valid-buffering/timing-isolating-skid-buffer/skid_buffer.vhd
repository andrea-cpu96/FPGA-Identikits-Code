library ieee;
use ieee.std_logic_1164.all;

entity skid_buffer is
    generic (WIDTH : positive := 8);
    port (
        clk, rst  : in  std_logic;
        in_valid  : in  std_logic;
        in_data   : in  std_logic_vector(WIDTH-1 downto 0);
        in_ready  : out std_logic;
        out_valid : out std_logic;
        out_data  : out std_logic_vector(WIDTH-1 downto 0);
        out_ready : in  std_logic
    );
end entity skid_buffer;

architecture rtl of skid_buffer is
    signal output_valid, spare_valid : std_logic;
    signal output_data, spare_data :
        std_logic_vector(WIDTH-1 downto 0);
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                output_valid <= '0';
                spare_valid  <= '0';
            elsif output_valid = '0' or out_ready = '1' then
                if spare_valid = '1' then
                    output_data  <= spare_data;
                    output_valid <= '1';
                    spare_valid  <= '0';
                else
                    output_valid <= in_valid;
                    if in_valid = '1' then
                        output_data <= in_data;
                    end if;
                end if;
            elsif in_valid = '1' and spare_valid = '0' then
                spare_data  <= in_data;
                spare_valid <= '1';
            end if;
        end if;
    end process;

    in_ready  <= not spare_valid;
    out_valid <= output_valid;
    out_data  <= output_data;
end architecture rtl;
