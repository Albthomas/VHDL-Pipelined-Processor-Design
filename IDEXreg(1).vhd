-------------------------------------------------------------------------------
--
-- Title       : IDEXreg 
-- Architecture Name: IDEXreg
-- Author: Muhammad Hussain
-- Date Created: 11/26/19
-- Date Last Modified: 11/26/19
-- Description : Pipeline register that separates the Instruction Decode and Execution stage.
--
-------------------------------------------------------------------------------	
library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_signed.all;


entity IDEXreg is
	port( 
	clk : in std_logic;
	DS1: in std_logic_vector(127 downto 0);
	DS2:	in std_logic_vector(127 downto 0);
	DS3:	in std_logic_vector(127 downto 0);
	opcode: in unsigned(4 downto 0);
	rs1_a_decode: in unsigned(4 downto 0);
	rs2_a_decode: in unsigned(4 downto 0);
	rs3_a_decode: in unsigned(4 downto 0);
	rd_a_decode: in unsigned(4 downto 0); 
	immed_i: in std_logic_vector(15 downto 0); 
	index_i: in std_logic_vector(2 downto 0); 
	instruction : in std_logic_vector(24 downto 0);
	--outputs
	opcode_out: out unsigned(4 downto 0);
	rs1_a_out: out unsigned(4 downto 0);
	rs2_a_out: out unsigned(4 downto 0);
	rs3_a_out: out unsigned(4 downto 0);
	rd_a_out: out unsigned(4 downto 0); 
	immed_o: out std_logic_vector(15 downto 0); 
	index_o: out std_logic_vector(2 downto 0);
	DS1_out: out std_logic_vector(127 downto 0);
	DS2_out:	out std_logic_vector(127 downto 0);
	DS3_out:	out std_logic_vector(127 downto 0);
	instruction_out : out std_logic_vector(24 downto 0)
	);
end IDEXreg;

architecture IDEXreg of IDEXreg is
begin
	 process(clk)
	begin
			
	if rising_edge(clk) then
		DS1_out <= DS1;
		DS2_out <= DS2;
		DS3_out <= DS3; 
		opcode_out <= opcode;
		rs1_a_out <= rs1_a_decode;
		rs2_a_out <= rs2_a_decode;
		rs3_a_out <= rs3_a_decode;
		rd_a_out <= rd_a_decode;
		immed_o <= immed_i;
		index_o <= index_i;
		instruction_out <= instruction;
	end if; 
	
	end process;

end IDEXreg;

	
	