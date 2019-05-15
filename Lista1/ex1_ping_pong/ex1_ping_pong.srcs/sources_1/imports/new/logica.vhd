----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2019 09:05:53
-- Design Name: 
-- Module Name: logica - Behavioral
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

entity logica is
    Port ( clk    : in STD_LOGIC;
           reset  : in STD_LOGIC;
           reg    : in STD_LOGIC_VECTOR (15 downto 0);
           sw0    : in STD_LOGIC;
           sw15   : in STD_LOGIC;
           cnt0   : out STD_LOGIC_VECTOR (3 downto 0);
           cnt1   : out STD_LOGIC_VECTOR (3 downto 0);
           enable : out STD_LOGIC;
           lr     : out STD_LOGIC;
           player : out STD_LOGIC);
end logica;

architecture Behavioral of logica is

signal s_cnt0 	: std_logic_vector(3 downto 0) := "0000";
signal s_cnt1   : std_logic_vector(3 downto 0) := "0000";
signal s_player : std_logic := '0';
signal s_lr     : std_logic := '1';
signal s_enable : std_logic := '0';

begin
	process(clk,reset)
	begin
		if reset = '1' then
			s_cnt0 <= "0000";
			s_cnt1 <= "0000";
			s_lr <= '1';
			s_enable <= '0'; -- habilita jogo
			s_player <= '0';
		elsif rising_edge(clk) then
			if s_cnt0 = "1001" or s_cnt1 = "1001" then
				s_lr <= '1'; -- desloca à esquerda
				s_enable <= '1'; -- habilita o deslocamento
				s_player <= '0'; -- player 0 começa
				s_cnt0 <= "0000";
				s_cnt1 <= "0000";
			elsif reg="0000000000000001" and sw0 = '1' then
				s_lr <= '1'; -- desloca à esquerda
				s_enable <= '1'; -- habilita o deslocamento
			elsif reg="0000000000000001" and sw0 = '0' then
				s_lr <= '1'; -- desloca à esquerda
				s_enable <= '0'; -- deshabilita o deslocamento
				s_player <= '1'; -- player 1 joga
				s_cnt1 <= s_cnt1 + 1; -- incrementa placar player 1
			elsif reg="1000000000000000" and sw15 = '1' then
				s_lr <= '0'; -- desloca à direita
				s_enable <= '1'; -- habilita o deslocamento
			elsif reg="1000000000000000" and sw15 = '0' then
				s_lr <= '0'; -- desloca à direita
				s_enable <= '0'; -- deshabilita o deslocamento	
				s_player <= '0'; -- player 0 joga
				s_cnt0 <= s_cnt0 + 1;	-- incrementa placar player 0	
			end if;		
		end if;
	end process;

cnt0 <= s_cnt0;
cnt1 <= s_cnt1;
player <= s_player;
lr <= s_lr;
enable <= s_enable;

end Behavioral;
