-- Aluno: Misael de Souza Andrade Matrícula: 16/0015669
-- Disciplina: Projeto de Circuitos Reconfiguráveis
-- Professor: Daniel Munoz Arboleda
-- Lista 1 - Exercício 2
-- Projeto: Ping-pong leds usando FSMs

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_module is
    Port ( entA  : in STD_LOGIC;                       -- raquete jogador 1('1' rebate e '0' deixa passar)
           entB  : in STD_LOGIC;                       -- raquete joador 2('1' rebate e '0' deixa passar)
           clk   : in STD_LOGIC;                       -- clock da placa 100MHz
           reset : in STD_LOGIC;                       -- reseta jogo
           led   : out STD_LOGIC_VECTOR (15 downto 0); -- saída nos leds que representa a bolinha
           seg   : out STD_LOGIC_VECTOR (6 downto 0);  -- display para mostrar o placar do jogo
           an    : out STD_LOGIC_VECTOR (3 downto 0)); -- anodos que liga/desliga display
end top_module;

architecture Behavioral of top_module is

----------declaração das components-------------------
-- divisor de clock
component clk_div
generic (
  freq : integer
);
port (
  clk     : in  STD_LOGIC;
  reset   : in  STD_LOGIC;
  clk_out : out STD_LOGIC
);
end component clk_div;

-- decodificador para display de 7 segmentos
component display_7_segmentos
port (
  sw1   : in  STD_LOGIC_VECTOR (3 downto 0);
  sw2   : in  STD_LOGIC_VECTOR (3 downto 0);
  an    : out STD_LOGIC_VECTOR (3 downto 0);
  clk   : in  STD_LOGIC;
  reset : in  STD_LOGIC;
  seg   : out STD_LOGIC_VECTOR (6 downto 0)
);
end component display_7_segmentos;

-- FSM para a lógica do jogo
component score_controller is
    Port ( clk    : in STD_LOGIC;
           clk_in : in STD_LOGIC;
           reset  : in STD_LOGIC;
           entA   : in STD_LOGIC;
           entB   : in STD_LOGIC;
           score1 : out STD_LOGIC_VECTOR (3 downto 0);
           score2 : out STD_LOGIC_VECTOR (3 downto 0);
           reg    : out  UNSIGNED (15 downto 0));
end component score_controller;

--------sinais--------------
signal sw1        : STD_LOGIC_VECTOR (3 downto 0);
signal sw2        : STD_LOGIC_VECTOR (3 downto 0);
signal reg_out    : UNSIGNED (15 downto 0);
signal enable     : STD_LOGIC ; -- habilita jogo
signal clk_10hz   : STD_LOGIC ; -- signal para clock de 10Hz
signal clk_100hz  : STD_LOGIC ; -- signal para clock de 100Hz

--- constantes---------------------------
constant f1hz     : integer := 50000000;
constant f10hz    : integer := 5000000;
constant f100hz   : integer := 500000;
constant f1khz    : integer  := 50000;
constant f10khz   : integer  := 5000;
constant f100khz  : integer  := 500;
constant f1000khz : integer  := 50;
constant f1mhz    : integer  := 5;

begin

----------instanciação dos port maps---------------
display_7_segmentos_i : display_7_segmentos
port map (
  sw1   => sw1,
  sw2   => sw2,
  an    => an,
  clk   => clk_100hz,
  reset => reset,
  seg   => seg
);

clk_div10HZ : clk_div
generic map (
  freq => f10hz
)
port map (
  clk     => clk,
  reset   => reset,
  clk_out => clk_10hz
);

clk_div100HZ : clk_div
generic map (
  freq => f100hz
)
port map (
  clk     => clk,
  reset   => reset,
  clk_out => clk_100hz
);

score_controller_i : score_controller
port map (
  clk    => clk,
  clk_in => clk_10hz,
  reset  => reset,
  entA   => entA,
  entB   => entB,
  score1 => sw1,
  score2 => sw2,
  reg    => reg_out
);

led <= std_logic_vector(reg_out);

end Behavioral;