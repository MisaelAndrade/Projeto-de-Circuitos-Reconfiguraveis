library ieee;
use ieee.std_logic_1164.all;

entity tb_top_module is
end tb_top_module;

architecture tb of tb_top_module is

-----------------declaração de component----------------------------------
    component top_module
        port (entA  : in std_logic;                        -- raquete jogador 1('1' rebate e '0' deixa passar)      
              entB  : in std_logic;                        -- raquete joador 2('1' rebate e '0' deixa passar)       
              clk   : in std_logic;                        -- clock da placa 100MHz                                 
              reset : in std_logic;                        -- reseta jogo                                           
              led   : out std_logic_vector (15 downto 0);  -- saída nos leds que representa a bolinha               
              seg   : out std_logic_vector (6 downto 0);   -- display para mostrar o placar do jogo                 
              an    : out std_logic_vector (3 downto 0));  -- anodos que liga/desliga display                       
    end component;

----------------------sinais----------------------------------------------
    signal entA  : std_logic;
    signal entB  : std_logic;
    signal clk   : std_logic;
    signal reset : std_logic;
    signal led   : std_logic_vector (15 downto 0);
    signal seg   : std_logic_vector (6 downto 0);
    signal an    : std_logic_vector (3 downto 0);

    constant TbPeriod : time := 10 ns; -- clock de 100MHz
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

----------------instanciação de port map-----------------------------------
    dut : top_module
    port map (entA  => entA,
              entB  => entB,
              clk   => clk,
              reset => reset,
              led   => led,
              seg   => seg,
              an    => an);

    -- geração do clock de 100MHz
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    clk <= TbClock;

---------processo para estimulo das entradas----------------------------
    stimuli : process
    begin
        -- inicialização das entradas
        entA <= '0';
        entB <= '0';

        -- geração do reset
        reset <= '1';
        wait for TbPeriod;
        reset <= '0';
        wait for TbPeriod;
        -- jogador 1 inicia partida
        entA <= '1';
        wait for 17 * 150ms;
        -- joador 2 rebate e bolinha volta
        entB <= '1';
        wait for 17 * 150ms;
        -- jogador 1 antecipou e jogador 2 marcou ponto
        entA <= '0';
        entB <= '0';

        -- para clock uma vez que iniciada a simulação
        TbSimEnded <= '1';
        wait;
    end process;

end tb;