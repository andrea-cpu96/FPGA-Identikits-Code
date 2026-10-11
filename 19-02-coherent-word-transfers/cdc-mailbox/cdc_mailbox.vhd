library ieee;
use ieee.std_logic_1164.all;
entity cdc_mailbox is
    generic (WIDTH : positive := 8);
    port (
        clk_src, rst_src, src_valid : in  std_logic;
        src_data  : in  std_logic_vector(WIDTH-1 downto 0);
        src_ready : out std_logic;
        clk_dst, rst_dst, dst_ready : in  std_logic;
        dst_valid : out std_logic;
        dst_data  : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity cdc_mailbox;

architecture rtl of cdc_mailbox is
    signal req, ack, req_seen, valid_reg : std_logic;
    signal ack_sync, req_sync : std_logic_vector(1 downto 0);
    signal data_reg : std_logic_vector(WIDTH-1 downto 0);
begin
    process (clk_src)
    begin
        if rising_edge(clk_src) then
            if rst_src = '1' then
                req <= '0'; ack_sync <= "00";
            else
                ack_sync <= ack_sync(0) & ack;
                if src_valid = '1' and req = ack_sync(1) then
                    data_reg <= src_data;
                    req      <= not req;
                end if;
            end if;
        end if;
    end process;
    src_ready <= req xnor ack_sync(1);

    process (clk_dst)
    begin
        if rising_edge(clk_dst) then
            if rst_dst = '1' then
                req_sync <= "00"; req_seen  <= '0';
                ack      <= '0';  valid_reg <= '0';
            else
                req_sync <= req_sync(0) & req;
                if valid_reg = '1' then
                    if dst_ready = '1' then
                        valid_reg <= '0';
                        ack       <= req_seen;
                    end if;
                elsif req_sync(1) /= req_seen then
                    dst_data  <= data_reg;
                    req_seen  <= req_sync(1);
                    valid_reg <= '1';
                end if;
            end if;
        end if;
    end process;
    dst_valid <= valid_reg;
end architecture rtl;
