library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registrador is
    Port ( reset     : in STD_LOGIC ;
           clk       : in STD_LOGIC;
           dir       : in STD_LOGIC;
           enable    : in STD_LOGIC;
           preset    : in UNSIGNED (15 downto 0);
           reg       : out UNSIGNED (15 downto 0));
end registrador;

architecture Behavioral of registrador is

----------sinais-------------------------------------------
signal s_reg : UNSIGNED(15 downto 0) := "0000000000000001";

begin

shift_reg: process(clk, reset)
begin
    if(reset = '1') then
        s_reg <= "0000000000000001";
    elsif(rising_edge(clk))then
        if (enable = '1') then
            if (dir = '0') then
                s_reg <= s_reg sll 1;
            else
                s_reg <= s_reg srl 1;
            end if;
        else 
            s_reg <= preset;
        end if;
    end if;

end process shift_reg;

reg <= s_reg;

end Behavioral;