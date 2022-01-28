-------------------------------------------------------------------------------
--
-- Title: Decoder
-- Entity Name: Decoder
-- Architecture Name: Decoder
-- Author: Muhammad Hussaiin
-- Date Created: 11/28/19
-- Date Last Modified: 11/30/19
-- Description : Testbench for Decoder to Decode the Instruction into separate parts.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_signed.all;


entity DecoderT is
end DecoderT;

--}} End of automatically maintained section

architecture DecoderT of DecoderT is 
signal clk_in : std_logic := '0';
signal instruction_tb: std_logic_vector(24 downto 0);
signal immed_tb : std_logic_vector(15 downto 0);
signal index_tb : std_logic_vector(2 downto 0);
signal opcode_tb : unsigned(4 downto 0); 
signal WE_tb :bit;
signal rs1_a_tb:unsigned(4 downto 0);	
signal rs2_a_tb:unsigned(4 downto 0);
signal rs3_a_tb:unsigned(4 downto 0);
signal rd_a_tb:unsigned(4 downto 0);
constant clk_period : time := 10 ns;

begin
	uut: entity work.decoder PORT MAP (
		instruction => instruction_tb,
		rs1 => rs1_a_tb,
		rs2 => rs2_a_tb,
		rs3 => rs3_a_tb,
		rd => rd_a_tb,
		immed => immed_tb,
		index => index_tb,
		opcode => opcode_tb
		);
clk_process : process
begin
	clk_in <= '0';
	wait for clk_period/2;
	clk_in <= '1';
	wait for clk_period/2;
end process;  
-- stimulus process
stim_proc : process
begin
	
	wait for clk_period;
	--test for r3 instruction
	instruction_tb <= "1100000001011100110101100";
	wait for clk_period;
	--test for r4 instruction
	instruction_tb <= "1000000101000100000100100";
	wait for clk_period;
	--test for li instruction
	instruction_tb <= "0111111111111111000000100";
	wait for clk_period;
wait;
end process;
end DecoderT;
