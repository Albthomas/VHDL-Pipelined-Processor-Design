-----------------------------------------------------------------------
-- File Name: 	InstructionBuffer.vhd
-- Entity Name: InstructionBuffer
-- Architecture Name: IB_arc
-- Author: Muhammad Hussain
-- Date Created: 11/23/19
-- Date Last Modified: 11/24/19
-- Description:	This is the design description for the Instruction Buffer.
-- The contents of the buffer should be loaded by the testbench instructions from a test file at the start of simulation.
-- On each cycle, the instruction specified by the Program Counter (PC) is fetched, and the value of PC is incremented by 1.
-----------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
					

package buff_array_pkg is
type buff_array is array(0 to 63) of std_logic_vector (24 downto 0);
end package buff_array_pkg;		

--////////////////////////////////////////////////

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.buff_array_pkg.all;	

entity InstructionBuffer is
	 port(
	 load : in std_logic; 				  
	 data_in : in buff_array; 
	 pc : in std_logic_vector(5 downto 0); 
     instr_out : out std_logic_vector(24 downto 0) 
    );
end InstructionBuffer;


architecture IB_arc of InstructionBuffer is
signal data : buff_array; 
signal read_address : std_logic_vector(5 downto 0); 


begin

    buffProc : process(load, pc, data_in) is	

    begin
		
      if load = '0' then
        data <= data_in;
      end if;
      read_address <= pc;

      instr_out <= data(to_integer(unsigned(read_address)));

    end process buffProc;  													   										 
	
end IB_arc;