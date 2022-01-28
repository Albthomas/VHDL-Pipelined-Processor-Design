-------------------------------------------------------------------------------
--
-- Title       : IFIDreg 
-- Architecture Name: IFIDreg
-- Author: Muhammad Hussain
-- Date Created: 11/26/19
-- Date Last Modified: 11/26/19
-- Description : Pipeline register that separates the Instruction Fetch and Instruction Decode stage.
--
-------------------------------------------------------------------------------		
library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_signed.all;


entity IFIDreg is
	port(
	clk: in std_logic;
	instruction: in std_logic_vector(24 downto 0);
	inst_out: out std_logic_vector(24 downto 0)
	
	);
end IFIDreg;

architecture IFIDreg of IFIDreg is
begin
	process(clk)
	begin
			
	if rising_edge(clk) then
		inst_out <= instruction;
	end if; 
	
	end process;

end IFIDreg;
