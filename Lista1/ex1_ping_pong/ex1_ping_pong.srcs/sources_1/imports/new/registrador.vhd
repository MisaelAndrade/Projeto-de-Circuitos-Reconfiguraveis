----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2019 08:55:50
-- Design Name: 
-- Module Name: registrador - Behavioral
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

entity registrador is
    Port ( clk_10Hz : in STD_LOGIC;
           reset    : in STD_LOGIC;
           lr       : in STD_LOGIC;
           enable   : in STD_LOGIC;
           player   : in std_logic;
           reg : out STD_LOGIC_VECTOR (15 downto 0));
end registrador;

architecture Behavioral of registrador is

signal s_reg : std_logic_vector(15 downto 0) := (others=>'0');

begin

	process(clk_10Hz,reset)
	begin
		if reset='1' then
			s_reg <= "0000000000000001";
		elsif rising_edge(clk_10Hz) then
			if enable = '1' then
				if lr = '0' then
					s_reg <= '0' & s_reg(14 downto 0); -- desloca a direita
				else
					s_reg <= s_reg(15 downto 1) & '0'; -- desloca a esquerda
				end if;
			elsif player = '0' then
				s_reg <= "0000000000000001"; -- jogador 1 joga
			else
				s_reg <= "1000000000000000"; -- jogador 2 joga
			end if;
		end if;
	end process;

reg <= s_reg;

end Behavioral;
