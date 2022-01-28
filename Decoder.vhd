-------------------------------------------------------------------------------
--
-- Title: Decoder
-- Entity Name: Decoder
-- Architecture Name: Decoder
-- Author: Muhammad Hussaiin
-- Date Created: 11/28/19
-- Date Last Modified: 11/30/19
-- Description : Decoder to Decode the Instruction.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_signed.all;


entity Decoder is
	 port(
		 instruction : in std_logic_vector(24 downto 0);
		 opcode : out unsigned(4 downto 0);
		 rs1 : out unsigned(4 downto 0); 
		 rs2 : out unsigned(4 downto 0);
		 rs3 : out unsigned(4 downto 0);
		 rd  : out unsigned(4 downto 0);
		 --for li
		 immed: out std_logic_vector(15 downto 0); 
		 index: out std_logic_vector(2 downto 0);
		 WE:out bit --Write Enable
	     );
end Decoder;

architecture Decoder of Decoder is 

begin

process(instruction)	
begin
	rs1<=unsigned(instruction (9 downto 5));
	rs2<=unsigned(instruction(14 downto 10));
	rs3<=unsigned(instruction(19 downto 15));
	rd<=unsigned(instruction(4 downto 0));
	immed<=instruction(20 downto 5);
	index<=instruction(23 downto 21);
	WE<= '0';--unused  
	
end process;

end Decoder;
