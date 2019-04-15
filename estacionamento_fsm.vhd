----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.04.2019 12:33:33
-- Design Name: 
-- Module Name: estacionamento - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Deion: 
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

entity estacionamento_fsm is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           s1 : in STD_LOGIC;
           s2 : in STD_LOGIC;
           semaforo : out STD_LOGIC);
end estacionamento_fsm;

architecture Behavioral of estacionamento_fsm is

	type t_state is (espera,inicial,entra1,entra2,entra3,sai1,sai2,sai3);
	signal current_state, next_state : t_state := inicial;
	
	signal vagas : integer range 0 to 10 := 3;
	
begin

	-- processo para registrar estado
	process(clk,reset)
	begin
		if reset='1' then
			current_state <= inicial;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if; 
	end process;
	
	-- processo para transição de estados
	process(current_state,s1,s2)
	begin
		case current_state is
			when inicial =>
				next_state <= espera;
			when espera =>
				if s1='1' and s2='0' then
					next_state <= entra1;
				elsif s1='0' and s2='1' then
					next_state <= sai1;
				else
					next_state <= espera;
				end if;
				
			when entra1 =>
				if s1='1' and s2='1' then
					next_state <= entra2;
				elsif s1='0' and s2='0' then
					next_state <= espera;
				else
					next_state <= entra1;
				end if;
				
			when entra2 =>
				if s1='0' and s2='1' then
					next_state <= entra3;
				elsif s1='1' and s2='0' then
					next_state <= entra1;
				else
					next_state <= entra2;
				end if;
							
			when entra3 =>
				if s1='0' and s2='0' then
					next_state <= espera;
				elsif s1='1' and s2='1' then
					next_state <= entra2;
				else
					next_state <= entra3;
				end if;				
			
			when sai1 =>
				if s1='1' and s2='1' then
					next_state <= sai2;
				elsif s1='0' and s2='0' then
					next_state <= espera;
				else
					next_state <= sai1;
				end if;		
						
			when sai2 =>
				if s1='1' and s2='0' then
					next_state <= sai3;
				elsif s1='0' and s2='1' then
					next_state <= sai1;
				else
					next_state <= sai2;
				end if;	
							
			when sai3 =>
				if s1='0' and s2='0' then
					next_state <= espera;
				elsif s1='1' and s2='1' then
					next_state <= sai2;
				else
					next_state <= sai3;
				end if;	
						
			when others => 
				next_state <= espera;
	
		end case;
	end process;
	
	-- processo sequencial para saidas
	process(clk,reset)
	begin
		if reset='1' then
			vagas <= 3;
		elsif rising_edge(clk) then
			case current_state is
				when entra3 =>
					if s1='0' and s2='0' then
						vagas <= vagas + 1;
					end if;
				when sai3 =>
					if s1='0' and s2='0' then
						vagas <= vagas + 1;
					end if;
				when others => null;
			end case;
		end if;
	end process;
	
	-- processo sequencial para o semaforo
	process(clk,reset)
	begin
		if reset = '1' then
			semaforo <= '1';
		elsif rising_edge(clk) then
			if vagas = 10 then
				semaforo <= '0';
			 else
			 	semaforo <= '1';
			end if;
		end if;
	end process;	

end Behavioral;








