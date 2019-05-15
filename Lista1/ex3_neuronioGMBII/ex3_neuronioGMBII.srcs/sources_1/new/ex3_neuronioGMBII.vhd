----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.05.2019 02:06:51
-- Design Name: 
-- Module Name: ex3_neuronioGMBII - Behavioral
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

use work.fpupack.all;
use work.entities.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ex3_neuronioGMBII is
    Port ( clk   : in STD_LOGIC;
           reset : in STD_LOGIC;
           sw    : in STD_LOGIC_VECTOR (15 downto 0);
           btnU  : in STD_LOGIC;
           btnD  : in STD_LOGIC;
           load  : in STD_LOGIC;     -- push button para poder carrear valor nas switches
           led   : out STD_LOGIC_VECTOR (15 downto 0));
end ex3_neuronioGMBII;

architecture Behavioral of ex3_neuronioGMBII is

component neuronio is
    Port ( clk   : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           x     : in STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
           saida : out STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0); 
           ready : out STD_LOGIC);
end component;

-------------sinais---------------------------------------------
signal s_x     : std_logic_vector (FP_WIDTH-1 downto 0) := (others => '0');
signal s_saida : std_logic_vector (FP_WIDTH-1 downto 0) := (others => '0');
signal s_ready : std_logic := '0';
signal s_start : std_logic := '0';

begin

my_neuro: neuronio
    port map(
        clk   => clk, 
        reset => reset,
        start => s_start,
        x     => s_x,
        saida => s_saida,
        ready => s_ready
    );

-- process de leitura do número
process(clk, reset, load, btnU, btnD)
begin
    if reset = '1' then
        s_x <= (others => '0');
        s_start <= '0';
    elsif rising_edge(clk) then
        if load = '1' then
            s_start <= '1';
            if btnU = '1' then
                s_x(FP_WIDTH-1 downto 11) <= sw;
            else
                s_x(10 downto 0) <= sw(15 downto 5);
            end if;
        end if; 
    end if;
end process;

-- process de resultado nos leds
process(clk, reset, s_ready)
begin
    if reset = '1' then
        led <= (others=> '0');
    elsif rising_edge(clk) then
        if s_ready = '1' then
            if btnD = '1' then
                led <= s_saida(FP_WIDTH-1 downto 11);
            else
                led <= s_saida(10 downto 0) & "00000";
            end if;
        end if; 
    end if;
end process;

end Behavioral;
