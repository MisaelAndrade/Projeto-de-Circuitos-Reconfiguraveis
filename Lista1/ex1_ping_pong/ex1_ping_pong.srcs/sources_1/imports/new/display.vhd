----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2019 09:20:03
-- Design Name: 
-- Module Name: display - Behavioral
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

entity display is
    Port ( clk_100Hz : in STD_LOGIC;
           reset    : in STD_LOGIC;
           cnt0     : in STD_LOGIC_VECTOR (3 downto 0);
           cnt1     : in STD_LOGIC_VECTOR (3 downto 0);
           an       : out STD_LOGIC_VECTOR (3 downto 0);
           seg      : out STD_LOGIC_VECTOR (7 downto 0));
end display;

architecture Behavioral of display is

signal s_an    : unsigned(3 downto 0) := "0000";
signal sel_mux : std_logic_vector(1 downto 0):="00";
signal s_bin   : std_logic_vector(3 downto 0) := "0000";
signal s_seg   : std_logic_vector(7 downto 0) := (others => '0');

begin

	-- process para multiplexar anodos
	process(clk_100Hz,reset)
	begin
		if reset='1' then
			s_an <= "1110";
			sel_mux <= "00";
		elsif rising_edge(clk_100Hz) then
			s_an <= s_an srl 1;
			sel_mux <= sel_mux + 1;
		end if;
	end process;
	
	-- mux para decodificador
	with sel_mux select
		s_bin <= cnt0 when "00",
				 "1111" when "01", 
				 "1111" when "10", 
				 cnt1 when "11",
				 "XXXX" WHEN OTHERS; 
	
	-- process combinacional para decodificar segmentos
	process(s_bin)
	begin
		case s_bin is
			when "0000" => s_seg <= "11000000";
			when "0001" => s_seg <= "11111001";
			when "0010" => s_seg <= "10100100";
			when "0011" => s_seg <= "10110000";
			when "0100" => s_seg <= "10011001";
			when "0101" => s_seg <= "10010010";
			when "0110" => s_seg <= "10000010";
			when "0111" => s_seg <= "11111000";
			when "1000" => s_seg <= "10000000";
			when "1001" => s_seg <= "10010000";
			when "1111" => s_seg <= "11111111";
			when others => s_seg <= "11111111";
		end case;
	end process;

an <= std_logic_vector(s_an);
seg <= s_seg;

end Behavioral;
