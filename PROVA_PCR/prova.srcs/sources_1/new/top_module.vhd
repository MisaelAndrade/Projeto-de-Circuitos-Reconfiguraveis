----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.05.2019 17:02:36
-- Design Name: 
-- Module Name: top_module - Behavioral
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

use work.entities.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
    Port ( clk    : in STD_LOGIC;
           reset  : in STD_LOGIC; -- reset
           addra  : in STD_LOGIC_VECTOR(6 DOWNTO 0); -- usuário insere endereço da memória
           en_mem : in STD_LOGIC; -- usuário habilita memória
           start  : in STD_LOGIC; -- start para calular xfusão
           sw_out : in STD_LOGIC; -- '0' mostra MSBs e '1' mostra LSBs
           led    : out STD_LOGIC_VECTOR (15 downto 0) -- resultado de xf
           );
end top_module;

architecture Behavioral of top_module is

COMPONENT prova
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           xir : in STD_LOGIC_VECTOR (26 downto 0);
           xul : in STD_LOGIC_VECTOR (26 downto 0);
           ready : out STD_LOGIC;
           xf : out STD_LOGIC_VECTOR (26 downto 0));
end COMPONENT;

COMPONENT blk_mem_gen_xir
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(26 DOWNTO 0)
  );
END COMPONENT;

COMPONENT blk_mem_gen_xul
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(26 DOWNTO 0)
  );
END COMPONENT;

--------------signals--------------------------------
signal xir : STD_LOGIC_VECTOR (26 downto 0);
signal xul : STD_LOGIC_VECTOR (26 downto 0);
signal xf : STD_LOGIC_VECTOR (26 downto 0);
signal ready : STD_LOGIC;

begin

FILTRO : prova 
  PORT MAP( clk  => clk,
    reset => reset,
    start => start,
    xir   => xir,
    xul   => xul,
    ready => ready,
    xf    => xf 
  );

ROM_xir : blk_mem_gen_xir
  PORT MAP (
    clka  => clk,
    ena   => en_mem,
    addra => addra,
    douta => xir
  );

ROM_xul : blk_mem_gen_xul
  PORT MAP (
    clka  => clk,
    ena   => en_mem,
    addra => addra,
    douta => xul
  );

process (clk, reset, sw_out)
begin
    if reset = '1' then
        led <= (others => '0');
    elsif rising_edge(clk) then
        if sw_out = '0' then
            led <= xf(26 downto 11);
        else 
            led <= "00000" & xf(10 downto 0);
        end if;
    end if;
end process;

end Behavioral;
