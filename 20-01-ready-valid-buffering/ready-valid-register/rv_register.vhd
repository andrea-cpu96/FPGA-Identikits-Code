library ieee;
use ieee.std_logic_1164.all;

entity rv_register is
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
end entity rv_register;

architecture rtl of rv_register is
    signal valid_reg : std_logic;
    signal data_reg  : std_logic_vector(WIDTH-1 downto 0);
    signal ready     : std_logic;
begin
    ready <= not valid_reg or out_ready;

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                valid_reg <= '0';
            elsif ready = '1' then
                valid_reg <= in_valid;
                if in_valid = '1' then
                    data_reg <= in_data;
                end if;
            end if;
        end if;
    end process;

    in_ready  <= ready;
    out_valid <= valid_reg;
    out_data  <= data_reg;
end architecture rtl;
