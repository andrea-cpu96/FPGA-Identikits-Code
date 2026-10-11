-- Level-sensitive latch: follows d while en high, holds when closed
-- The hold path infers a latch by design; no clock.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transparent_latch is
    port (
        en : in  std_logic;
        d  : in  std_logic_vector(7 downto 0);
        q  : out std_logic_vector(7 downto 0)
    );
end entity transparent_latch;

architecture rtl of transparent_latch is
begin

    process (en, d)
    begin
        if en = '1' then
            q <= d;
        end if;
    end process;

end architecture rtl;
