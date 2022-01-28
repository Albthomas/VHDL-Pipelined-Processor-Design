-------------------------------------------------------------------------------
--
-- Title: MMU_TB
-- Entity Name: MMU_TB
-- Architecture Name: MMU_TB
-- Author: Muhammad Hussain
-- Date Created: 11/30/19
-- Date Last Modified: 12/1/19
-- Description : Testbench for the Multimedia Logic Unit of the 4-stage Pipeline.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all; 
use work.buff_array_pkg.all;	   
use STD.textio.all;
use ieee.std_logic_textio.all; 	  


entity MMU_TB is	 
end MMU_TB;

architecture tb_architecture of MMU_TB is

signal INSTRS: buff_array;
constant time_period : time := 10 us;	

signal clk_tb : std_logic;
	signal load_tb : std_logic;
	signal data_in_tb : buff_array;
	signal rst_n_tb : std_logic;
	signal output_pc: std_logic_vector(5  downto 0);

file file_VECTORS : text;
file file_RESULTS : text;		

begin			
	
	
	UUT : entity MMU port map(
		clock =>clk_tb, 
		load =>load_tb, 				  
		data_in =>data_in_tb, 
		rst_n =>rst_n_tb,
		out_fromPC=> output_pc
		);
			
 
	initial: process is
		variable v_OLINE : line;
		variable count : integer range 0 to 63;   
	    variable in_line  : line;
	    variable instr_count : integer := 0;
		variable inst_code : std_logic_vector(24 downto 0);	 --instruction
		
	    begin
	 
	    file_open(file_VECTORS, "vectors_input.txt",  read_mode);
		file_open(file_RESULTS, "results_out.txt", write_mode);
		
		while not endfile(file_VECTORS) loop
	      readline(file_VECTORS, in_line);
	      read(in_line, inst_code);
	      INSTRS(count) <= inst_code;	  						 
	      data_in_tb(count) <= inst_code; 
		  report "inst_code: " & to_string(inst_code);
		  --wait for time_period;
		  count := count+1;	 
		  write(in_line, "instruction_code:");
		  write(in_line, inst_code);
		  writeline(file_RESULTS, in_line);	
		  write(in_line, "pc value:");
		  write(in_line, output_pc, right, 15);
		  writeline(file_RESULTS, in_line);
		
		  wait for time_period;
		end loop;
		
		
		file_close(file_VECTORS); 
		file_close(file_RESULTS);
		
		wait;
		end process;

	
	clock : process  
	
	begin
		clk_tb <= '1';
		wait for time_period;
		clk_tb <= '0';
		wait for time_period;
	end process;  
	
	load : process  
	
	begin
		load_tb <= '1';
		wait for time_period;
		load_tb <= '0';
		wait;
	end process;
	
	reset: process
	begin
		rst_n_tb <= '1';
		wait for time_period/4;
		rst_n_tb <= '0';
		wait for time_period;
		rst_n_tb <= '1';
		wait for time_period*1000;
	end process;
	
	
end tb_architecture;