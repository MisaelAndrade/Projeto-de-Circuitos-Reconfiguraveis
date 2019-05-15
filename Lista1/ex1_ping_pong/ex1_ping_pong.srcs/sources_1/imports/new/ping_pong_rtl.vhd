----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2019 08:33:56
-- Design Name: 
-- Module Name: ping_pong_rtl - Behavioral
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

entity ping_pong_rtl is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sw0 : in STD_LOGIC;
           sw15 : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0));
end ping_pong_rtl;

architecture Behavioral of ping_pong_rtl is

component divisor_clock is
    generic (N : integer);
    Port ( clk     : in STD_LOGIC;
           reset   : in STD_LOGIC;
           clk_div : out STD_LOGIC );
end component divisor_clock;

component registrador is
    Port ( clk_10Hz : in STD_LOGIC;
           reset    : in STD_LOGIC;
           lr       : in STD_LOGIC;
           enable   : in STD_LOGIC;
           player   : in std_logic;
           reg : out STD_LOGIC_VECTOR (15 downto 0));
end component registrador;

component logica is
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
end component logica;

component display is
    Port ( clk_100Hz : in STD_LOGIC;
           reset    : in STD_LOGIC;
           cnt0     : in STD_LOGIC_VECTOR (3 downto 0);
           cnt1     : in STD_LOGIC_VECTOR (3 downto 0);
           an       : out STD_LOGIC_VECTOR (3 downto 0);
           seg      : out STD_LOGIC_VECTOR (7 downto 0));
end component display;

signal s_clk_10Hz  : std_logic := '0';
signal s_clk_100Hz : std_logic := '0';
signal s_lr        : std_logic := '0';
signal s_enable    : std_logic := '0';
signal s_player    : std_logic := '0';
signal s_reg       : STD_LOGIC_VECTOR (15 downto 0);
signal s_cnt0      : STD_LOGIC_VECTOR (3 downto 0);
signal s_cnt1      : STD_LOGIC_VECTOR (3 downto 0);
signal s_an      : STD_LOGIC_VECTOR (3 downto 0);
signal s_seg      : STD_LOGIC_VECTOR (7 downto 0);



begin

clk_10Hz: divisor_clock 
    generic map (N => 5000000)
    Port map( clk     => clk,
              reset   => reset,
              clk_div => s_clk_10Hz );

clk_100Hz: divisor_clock 
    generic map (N => 50000)
    Port map( clk     => clk,
              reset   => reset,
              clk_div => s_clk_100Hz );
           
reg_ping: registrador 
    Port map( clk_10Hz => s_clk_10Hz,
              reset    => reset,
              lr       => s_lr,
              enable   => s_enable,
              player   => s_player,
              reg      => s_reg );

logica_ping: logica 
    Port map ( clk    => clk,
               reset  => reset,
               reg    => s_reg,
               sw0    => sw0,
               sw15   => sw15,
               cnt0   => s_cnt0,
               cnt1   => s_cnt1,
               enable => s_enable,
               lr     => s_lr,
               player => s_player );

display_ping: display
    Port map ( clk_100Hz => s_clk_100Hz,
               reset     => reset,
               cnt0      => s_cnt0,
               cnt1      => s_cnt1,
               an        => s_an,
               seg       => s_seg);
               
seg <= s_seg;
an <= s_an;
led <= s_reg;
	
end Behavioral;