-------------------------------------------------------------------------------
-- File Name: 	Program Counter.vhd
-- Entity Name: pc_counter
-- Architecture Name: pc_counter
-- Author: Muhammad Hussain
-- Date Created: 11/26/19
-- Date Last Modified: 11/26/19
-- Description : This is the design description for the program counter. 
-- The program counter contains the address of the instruction in the program being executed.	
-- PC incfrements by 1 at each clock cycle.
-------------------------------------------------------------------------------


library ieee;	
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	

entity pc_counter is	
	port(
	rst_n : in std_logic; 
	output : out std_logic_vector(5 downto 0); 
	clk : in std_logic 	
	);				   
end pc_counter;		   

architecture pc_counter of pc_counter is 
begin

	PC: process(rst_n, clk)
	variable count: integer := 0;
	begin 	  
		
		if(rst_n = '0') then	
			count := -1;  
			output <= (others => '0');
		end if;
		
		if rising_edge(clk) then 
			if count <= 63 then
				count := count+1;
				output <= std_logic_vector(to_unsigned(count,6));
			end if;
		end if;
	end process PC;
end pc_counter;




