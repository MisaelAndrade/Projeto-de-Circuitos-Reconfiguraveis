----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2019 08:43:38
-- Design Name: 
-- Module Name: divisor_clock - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divisor_clock is
    generic (N : integer);
    Port ( clk     : in STD_LOGIC;
           reset   : in STD_LOGIC;
           clk_div : out STD_LOGIC );
end divisor_clock;

architecture Behavioral of divisor_clock is

signal cnt       : integer range 0 to N := 0;
signal s_clk_div : std_logic := '0';

begin

process(clk,reset)
	begin
		if reset='1' then
			cnt <= 0;
			s_clk_div <= '0';
		elsif rising_edge(clk) then
			if cnt = N then
				cnt <= 0;
				s_clk_div <= not s_clk_div;
			else
				cnt <= cnt + 1;
			end if;
		end if;
	end process;

clk_div <= s_clk_div;

end Behavioral;
