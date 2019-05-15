----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.04.2019 09:02:18
-- Design Name: 
-- Module Name: neuronio - Behavioral
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

entity neuronio is
    Port ( clk   : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           x     : in STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
           saida : out STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0); 
           ready : out STD_LOGIC);
end neuronio;

architecture Behavioral of neuronio is

---------------signals----------------------------------------------------
signal outmul_0 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outmul_1 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outmul_2 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');

signal rdymul_0 : std_logic := '0';
signal rdymul_1 : std_logic := '0';
signal rdymul_2 : std_logic := '0';

signal outadd_0 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_1 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');

signal rdyadd_0 : std_logic := '0';
signal rdyadd_1 : std_logic := '0';

-----------------contantes--------------------------------------------------
constant a : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
constant b : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
constant c : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');

begin
    -- x^2
	mul_0: multiplierfsm_v2 port map(
		reset 	  => reset,
		clk	 	  => clk,   
        op_a	  => x,
        op_b 	  => x,
        start_i	  => start,
        mul_out   => outmul_0,
		ready_mul => rdymul_0);
		
	-- b*x	
    mul_1: multiplierfsm_v2 port map(
		reset 	  => reset,
		clk	 	  => clk,   
        op_a	  => x,
        op_b      => b,
        start_i	  => start,
        mul_out   => outmul_1,
		ready_mul => rdymul_1);
	
	-- a * x^2
    mul_2: multiplierfsm_v2 port map(
		reset 	  => reset,
		clk	 	  => clk,   
        op_a	  => outmul_0,
        op_b	  => a,
        start_i	  => rdymul_0,
        mul_out   => outmul_2,
		ready_mul => rdymul_2);
		
    -- b*x + c
	add0: addsubfsm_v6 port map(
		reset 	     => reset,
		clk	 	     => clk,   
		op	 	     => '0',   
		op_a	 	 => outmul_1,
		op_b	 	 => c,
		start_i	     => rdymul_1,
		addsub_out   => outadd_0,
		ready_as	 => rdyadd_0);
		
    -- a*x^2 + b*x + c
	add1: addsubfsm_v6 port map(
		reset 	     => reset,
		clk	 	     => clk,   
		op	 	     => '0',   
		op_a	 	 => outmul_2,
		op_b	 	 => outadd_0,
		start_i	     => rdymul_2,
		addsub_out   => outadd_1,
		ready_as	 => rdyadd_1);

-- processo para realizar a saida
	process(clk, reset, rdyadd_1)
	begin
		if reset='1' then
			saida <= (others=>'0');
			ready <= '0';
		elsif rising_edge(clk) then
			if rdyadd_1 = '1' then
			     ready <= '1';
			     saida <= outadd_1;
			else
			     ready <= '0';
			     saida <= (others => '0');
			end if;
		end if;
	end process;

end Behavioral;