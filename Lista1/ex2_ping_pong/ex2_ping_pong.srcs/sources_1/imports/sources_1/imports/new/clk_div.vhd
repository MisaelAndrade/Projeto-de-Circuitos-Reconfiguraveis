


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity clk_div is
    generic (freq : integer);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_out : out STD_LOGIC);
end clk_div;


architecture Behavioral of clk_div is


--signals---------
signal count : integer := 0;
signal s_clk_out : std_logic := '0';


begin

clk_div: process(clk, reset)

begin

    if(reset = '1') then
        s_clk_out <= '0';

    elsif(rising_edge(clk))then

        if(count = freq) then
            s_clk_out <= not(s_clk_out);
            count <= 0;
        else
            count <= count +1;

        end if;
    end if;


end process clk_div;

clk_out <= s_clk_out;




end Behavioral;
