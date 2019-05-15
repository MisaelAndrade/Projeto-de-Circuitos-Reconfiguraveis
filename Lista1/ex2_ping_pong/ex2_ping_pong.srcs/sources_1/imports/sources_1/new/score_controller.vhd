-- FSM para lógica do jogo ping-pong
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-----------------entidade---------------------------------
entity score_controller is
    Port ( clk     : in STD_LOGIC;                      -- clock da placa de 100MHz
           clk_in : in STD_LOGIC;                       -- clock dividido de 10Hz
           reset   : in STD_LOGIC;                      -- reseta jogo
           entA    : in STD_LOGIC;                      -- raquete para jogador 1
           entB    : in STD_LOGIC;                      -- raquete para jogador 2
           score1  : out STD_LOGIC_VECTOR (3 downto 0); -- pontuação do jogador 1
           score2  : out STD_LOGIC_VECTOR (3 downto 0); -- pontuação do jogador 2
           reg     : out  UNSIGNED (15 downto 0));      -- registrador de deslocamento da bolinha nos leds
end score_controller;

architecture Behavioral of score_controller is

type state_score is (win1, win2, playing1, playing2, start1, start2); -- tipo de dado para estados da FSM

---------sinais------------------------------------------
signal score_state_current : state_score := start1;                     -- signal para estado atual da FSM
signal score_state_next    : state_score := start1;                     -- signal para próximo estado da FSM
signal s_score1            : UNSIGNED (3 downto 0) := (others => '0');  -- signal para pontuação do jogador 1
signal s_score2            : UNSIGNED (3 downto 0) := (others => '0');  -- signal para pontuação do jogador 1
signal s_reg               : UNSIGNED (15 downto 0) := (others => '0'); -- signal para registrador a ser deslocado dos leds (bolinha)

begin

-----------processos----------------------------

--processo que define ações em cada FSM
FSM_score: process(clk_in, reset)

begin
    if (reset = '1')  then                        -- ações para reset do jogo
        score_state_next <= start1;               -- próximo estado start1
        s_score1 <= (others => '0');              -- zera contador de pontos do jogador 1
        s_score2 <= (others => '0');              -- zera contador de pontos do jogador 2
        s_reg <= "0000000000000001";              -- jogador 1 dá a partida de jogo
    elsif(rising_edge(clk_in))then
        case score_state_current is
            when start1 =>                        -- estado em que se espera ação do jogador 1
                s_reg <= "0000000000000001";
                if(entA = '1') then
                    score_state_next <= playing1; -- se jogador 1 der partida, próximo estado é playing1
                else
                    score_state_next <= start1;   -- se jogador 1 não der partida, permanece no mesmo estado
                end if;
            when start2 =>                        -- estado em que se espera ação do jogador 2
                s_reg <= "1000000000000000";
                if(entB = '1') then
                    score_state_next <= playing2; -- se jogador 2 der partida, próximo estado é playing2
                else
                    score_state_next <= start2;   -- se jogador 2 não der partida, permanece no mesmo estado
                end if;          
            when playing1 =>                      -- estado em que bolinha esta se deslocando para a esquerda
               if (( (s_reg(14) = '1') AND (entB = '1') ) OR ((s_reg(15) = '1') AND (entB = '0'))) then -- análise da antecipação do jogador 2
                    score_state_next <= win1;                  -- se jogador 2 se antecipar, ponto para jogador 1
                elsif((entB = '1') AND (s_reg(15) = '1')) then -- análise de rebatida do jogador 2
                    score_state_next <= playing2;              -- caso jogador 2 rebata, a bolinha começa a deslocar para direita
                else
                    s_reg <= s_reg sll 1;                      -- desloca bolinha para esquerda
                end if;           
            when playing2 =>                       -- estado em que bolinha esta se deslocando para a esquerda
               if (( (s_reg(1) = '1') AND (entA = '1') ) OR ((s_reg(0) = '1') AND (entA = '0'))) then -- análise da antecipação do jogador 1
                    score_state_next <= win2;                  -- se jogador 2 se antecipar, ponto para jogador 1
                elsif((entA = '1') AND (s_reg(0) = '1')) then  -- análise de rebatida do jogador 1
                    score_state_next <= playing1;              -- caso jogador 2 rebata, a bolinha começa a deslocar para esquerda
               else
                    s_reg <= s_reg srl 1;                      -- desloca bolinha para direita
               end if;
            when win1 =>                          -- estado em que executa ações para pontuação do jogador 1
                s_score1 <= s_score1 + 1;         -- incrementa pontuação do jogador 1
                score_state_next <= start1;       -- próximo estado é start1
                s_reg <= "1000000000000000";      
            when win2 =>                          -- estado em que executa ações para pontuação do jogador 2
                s_score2 <= s_score2 + 1;         -- incrementa pontuação do jogador 1
                score_state_next <= start2;       -- -- próximo estado é start1
                s_reg <= "0000000000000001";
            when others =>
                NULL;
        end case FSM_score;
    end if;

end process;

--processo para atualização dos estados da FSM
FSM_refersh: process(clk, reset)

begin
    if(reset = '1') then 
        score_state_current <= start1; 
    elsif(rising_edge(clk)) then
        score_state_current <= score_state_next;
    end if;
end process FSM_refersh;

reg    <= s_reg;
score1 <= std_logic_vector(s_score1);
score2 <= std_logic_vector(s_score2);

end Behavioral;