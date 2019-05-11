----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.std_logic_textio.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;
use work.fpupack.all;

entity prova_tb is
--  Port ( );
end prova_tb;

architecture Behavioral of prova_tb is

--FILE input_file  : text OPEN read_mode IS sim_file;
signal reset : std_logic := '0';
signal clk : std_logic := '0';
signal start : std_logic := '0';

signal xul : std_logic_vector(FP_WIDTH-1 downto 0) := (others=>'0');
signal xir : std_logic_vector(FP_WIDTH-1 downto 0) := (others=>'0');

signal xf : std_logic_vector(FP_WIDTH-1 downto 0) := (others=>'0');
signal ready : std_logic := '0';

-- conter for WOMenable
 signal WOMenable : std_logic := '0';
-- signal cnt_ena : integer range 1 to 205 := 1;

--constant num_mult_neuronio : integer := 4;
--subtype saida_mult is std_logic_vector( FP_WIDTH-1 downto 0 );
--type t_mult  is array( 0 to num_mult_neuronio-1 ) of saida_mult;

component prova is 
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           xir : in STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
           xul : in STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
           ready : out STD_LOGIC;
           xf : out STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0));
end component;

signal first_start : std_logic := '0';
signal next_start : std_logic := '0';

-- enderecamento das memorias ROM e WOM
signal ROMaddress : std_logic_vector(7 downto 0) := (others=>'0');

begin
   
    -- reset generator
    reset <= '0', '1' after 15 ns, '0' after 25 ns;
    
    -- clock generator
    clk <= not clk after 5 ns; 
    
    -- cria o start 
    first_start <= '0', '1' after 45 ns, '0' after 65 ns; 

    -- sobel architecture intanciation                    
    uut: prova Port map( 
               clk   => clk,
               reset => reset,
               start => start,
               xir   => xir,
               xul   => xul,
               ready => ready,
               xf    => xf);
	
    rom_xul: process
    file infile	: text is in "xul.txt"; -- input file declaration
    variable inline : line; -- line number declaration
    variable dataf  : std_logic_vector(FP_WIDTH-1 downto 0); 
    begin
        while (not endfile(infile)) loop
            wait until rising_edge(clk);
                if first_start='1' or ready='1' then
                    readline(infile, inline);
                    read(inline,dataf);
                    xul <= dataf;
                    start <= '1';
                else
                    start <= '0';
                end if;
                
        end loop;
        assert not endfile(infile) report "FIM DA LEITURA" severity warning;
        wait;        
    end process;

    rom_xir: process
    file infile	: text is in "xir.txt"; -- input file declaration
    variable inline : line; -- line number declaration
    variable dataf  : std_logic_vector(FP_WIDTH-1 downto 0); 
    begin
        while (not endfile(infile)) loop
            wait until rising_edge(clk);
                if first_start='1' or ready='1' then
                    readline(infile, inline);
                    read(inline,dataf);
                    xir <= dataf;
                end if;
        end loop;
        assert not endfile(infile) report "FIM DA LEITURA" severity warning;
        wait;        
    end process;
    
	 
    WOMenable <= ready;
    
    wom_n1 : process(clk) 
    variable out_line : line;
    file out_file     : text is out "res_filter.txt";
    begin
        -- write line to file every clock
        if (rising_edge(clk)) then
            if WOMenable = '1' then
                write (out_line, xf);
                writeline (out_file, out_line);
            end if; 
        end if;  
    end process ;

end Behavioral;
