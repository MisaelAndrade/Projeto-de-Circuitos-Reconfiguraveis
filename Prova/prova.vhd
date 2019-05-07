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

entity prova is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           xir : in STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
           xul : in STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
           ready : out STD_LOGIC;
           xf : out STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0));
end prova;

architecture Behavioral of prova is

----------------sinais-------------------------------------------------------
signal outmul_0 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) :=(others=>'0');
signal outmul_1 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) :=(others=>'0');

signal rdymul_0 : std_logic := '0';
signal rdymul_1 : std_logic := '0';

signal outadd_0 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_1 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_2 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_3 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');

signal rdyadd_0 : std_logic := '0';
signal rdyadd_1 : std_logic := '0';
signal rdyadd_2 : std_logic := '0';
signal rdyadd_3 : std_logic := '0';

signal outdiv : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal rdydiv : std_logic := '0';

signal sk       : std_logic_vector(FP_WIDTH-1 downto 0) := (others => '0');

-------------------------constantes-------------------------------------------
constant sz  : std_logic_vector(FP_WIDTH-1 downto 0) := "001111110000000000000000000";  -- sz = 0.5
constant sk0 : std_logic_vector(FP_WIDTH-1 downto 0) := "001111011100110011001100110"; -- sk0 = 0.1

begin

	add0: addsubfsm_v6 port map(
		reset 	     => reset,
		clk	 	     => clk,   
		op	 	     => '0',   
		op_a	 	 => sk,
		op_b	 	 => sz,
		start_i	     => start,
		addsub_out   => outadd_0,
		ready_as	 => rdyadd_0);

	add1: addsubfsm_v6 port map(
		reset 	     => reset,
		clk	 	     => clk,   
		op	 	     => '1',   
		op_a	 	 => xir,
		op_b	 	 => xul,
		start_i	     => start,
		addsub_out   => outadd_1,
		ready_as	 => rdyadd_1);

    div: divNR port map(
        reset     => reset,
        clk       => clk,
        op_a      => sk,
        op_b      => outadd_0,
        start_i   => rdyadd_0,
        div_out   => outdiv,
        ready_div => rdydiv );

	mul0: multiplierfsm_v2 port map(
		reset 	     => reset,
		clk	 	     => clk,   
		op_a	 	 => outadd_1,
		op_b	 	 => outdiv,
		start_i	     => rdydiv,
		mul_out      => outmul_0,
		ready_mul    => rdymul_0);
		
	mul1: multiplierfsm_v2 port map(
		reset 	     => reset,
		clk	 	     => clk,   
		op_a	 	 => sk,
		op_b	 	 => outdiv,
		start_i	     => rdydiv,
		mul_out      => outmul_1,
		ready_mul    => rdymul_1);

	add2: addsubfsm_v6 port map(
		reset 	     => reset,
		clk	 	     => clk,   
		op	 	     => '0',   
		op_a	 	 => xul,
		op_b	 	 => outmul_0,
		start_i	     => rdymul_0,
		addsub_out   => outadd_2,
		ready_as	 => rdyadd_2);

	add3: addsubfsm_v6 port map(
		reset 	   => reset,
		clk	 	   => clk,   
		op	 	   => '1',   
		op_a	   => sk,
		op_b	   => outmul_1,
		start_i	   => rdymul_1,
		addsub_out => outadd_3,
		ready_as   => rdyadd_3);
		
	
	-- processo para atualização de sk
	process(clk, reset, start, rdyadd_3)
	begin
		if reset='1' then
		    sk <= sk0;
		elsif rising_edge(clk) then
		    if (start = '1') and (rdyadd_3 = '1') then 
		      sk <= outadd_3;
		    elsif (start = '1')and (rdyadd_3 = '0') then
		      sk <= sk0;
		    end if;
		end if;
	end process;
	
	-- processo para atualização da saida
	process(clk, reset, start, rdyadd_3)
	begin
		if reset='1' then
			xf <= (others=>'0');
			ready <= '0';
		elsif rising_edge(clk) then
		    if rdyadd_2 = '1' then 
		      xf <= outadd_2;
              ready <= '1';
		    else
		      xf <= (others=>'0');
		      ready <= '0';
		    end if;
		end if;
	end process;

end Behavioral;