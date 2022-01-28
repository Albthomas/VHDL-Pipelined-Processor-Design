-----------------------------------------------------------------------
-- File Name: Multimedia ALU.vhd
-- Entity Name: ALU
-- Architecture Name: ALU_arc
-- Author: Muhammad M. Hussain
-- Date Created: 11/30/19
-- Date Last Modified: 11/031/19
-- Description: This is the ALU Testbench.
-----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_signed.all;

entity ALU_T is
end ALU_T;

--}} End of automatically maintained section

architecture ALU_T of ALU_T is  
signal clk_in : std_logic := '0'; 
signal rst_n : std_logic := '0';
signal reg_in1_tb, reg_in2_tb, reg_in3_tb, reg_d_tb: std_logic_vector(127 downto 0);
signal input_code_tb : std_logic_vector(24 downto 0);
constant clk_period : time := 10 ns;

begin
	uut: entity work.alu PORT MAP (
		reg_in1 => reg_in1_tb,
		reg_in2 => reg_in2_tb,
		reg_in3 => reg_in3_tb,
		reg_d => reg_d_tb,
		input_code => input_code_tb,
		rst_n => rst_n
		);
clk : process
begin
	clk_in <= '0';
	wait for clk_period/2;
	clk_in <= '1';
	wait for clk_period/2;
end process;

-- stimulus process
stim : process
begin
	rst_n <='0';
	wait for clk_period;
	rst_n<= '1';
	
	--test for nop	 
	reg_in1_tb <= std_logic_vector(to_unsigned(6,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_unsigned(8,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(0, input_code_tb'length)); 
	wait for clk_period;
	
	
	--test for A-Add word
	reg_in1_tb <= std_logic_vector(to_unsigned(6,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_unsigned(8,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(1, input_code_tb'length)); 
	wait for clk_period;
	
	
	--test for AH-Add half word
	reg_in1_tb <= std_logic_vector(to_unsigned(22,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_unsigned(33,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(2, input_code_tb'length)); 
	wait for clk_period;	  
	
	
	--test for AHS-add halfword saturated 
	reg_in1_tb <= std_logic_vector(X"1111_1110_1100_1000_0001_0011_0111_7FFF");
	reg_in2_tb <= std_logic_vector(X"0001_0010_0001_0011_0001_0010_0001_0011");
	input_code_tb <= std_logic_vector(to_unsigned(3, input_code_tb'length)); 
	wait for clk_period;
	
	
	--test for AND
	reg_in1_tb <= std_logic_vector(to_unsigned(7,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_unsigned(7,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(4, input_code_tb'length)); 
	wait for clk_period;
	
	
	--test for BCW 
	reg_in1_tb <= std_logic_vector(to_unsigned(7,reg_in1_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(5, input_code_tb'length));
	
	wait for clk_period;
	

	--test for CLZ 
	reg_in1_tb <= std_logic_vector(X"0000_0000_0000_0000_0000_0000_0101_0011");
	input_code_tb <= std_logic_vector(to_unsigned(6, input_code_tb'length)); 
	
	wait for clk_period;
	
	--test for MAX
	reg_in1_tb <= std_logic_vector(to_signed(7,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_signed(-7,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(7, input_code_tb'length)); 
	
	wait for clk_period; 
	
	--test for MIN
	reg_in1_tb <= std_logic_vector(to_signed(7,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_signed(-7,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(8, input_code_tb'length)); 
	
	wait for clk_period;   
	--test for MSGN: multiply sign:
	reg_in1_tb <= std_logic_vector(to_signed(-327699,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_signed(-4,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(9, input_code_tb'length)); 
	wait for clk_period;   
	--test for MSGN: multiply unsign:
	reg_in1_tb <= std_logic_vector(to_unsigned(5,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_unsigned(4,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(10, input_code_tb'length)); 
	wait for clk_period;   
	reg_in1_tb <= std_logic_vector(to_unsigned(7,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_unsigned(7,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(11, input_code_tb'length)); 
	wait for clk_period; 
	--test for POPCNTH
	reg_in1_tb <= std_logic_vector(X"0001_0002_0003_0004_0005_0006_0007_0000");
	input_code_tb <= std_logic_vector(to_unsigned(12, input_code_tb'length)); 
	
	wait for clk_period;
	--test for ROT
	reg_in1_tb <= std_logic_vector(X"0000_0000_0000_0000_0000_0000_0000_0007");
	reg_in2_tb <= std_logic_vector(to_unsigned(3,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(13, input_code_tb'length)); 
	
	wait for clk_period;  
	--test for ROTW
	reg_in1_tb <= std_logic_vector(X"0000_0000_0000_0000_0000_0000_0000_0007");
	reg_in2_tb <= std_logic_vector(X"0000_0000_0000_0000_0000_0000_0000_0003");
	input_code_tb <= std_logic_vector(to_unsigned(14, input_code_tb'length)); 
	
	wait for clk_period; 
	--test for SHLHI
	reg_in1_tb <= std_logic_vector(X"0000_0000_0000_0000_0000_0000_0000_0007");
	reg_in2_tb <= std_logic_vector(X"0000_0000_0000_0000_0000_0000_0000_0003");
	input_code_tb <= std_logic_vector(to_unsigned(15, input_code_tb'length)); 
	
	wait for clk_period;
	--test for SFH
	reg_in1_tb <= std_logic_vector(to_unsigned(4,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_unsigned(7,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(16, input_code_tb'length)); 
	
	wait for clk_period;
		--test for SFW
	reg_in1_tb <= std_logic_vector(X"0000_0000_0000_0000_0000_0000_0002_0007");
	reg_in2_tb <= std_logic_vector(X"0000_0000_0000_0000_0000_0000_0003_0000");
	input_code_tb <= std_logic_vector(to_unsigned(17, input_code_tb'length)); 
	
	
	wait for clk_period;
 		--test for SFHS: subtract from halfword saturated
	reg_in1_tb <= std_logic_vector(to_signed(50,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_signed(-32756,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(18, input_code_tb'length)); 
	wait for clk_period; 
	 		--test for XOR: bitwise logical exclusive-or
	reg_in1_tb <= std_logic_vector(to_unsigned(7,reg_in1_tb'length));
	reg_in2_tb <= std_logic_vector(to_unsigned(5,reg_in2_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(19, input_code_tb'length)); 
	wait for clk_period;  
	

	--Li
	input_code_tb <= std_logic_vector(to_unsigned(20, input_code_tb'length)); 
	wait for clk_period;  
	--R4 instruction 
	--test for Signed Integer Multiply-Add Low with Saturation
	reg_in1_tb <= std_logic_vector(X"1111_1110_1100_1000_7FFF_0000_7FFF_FFFE");
	reg_in2_tb <= std_logic_vector(to_signed(1,reg_in2_tb'length));
	reg_in3_tb <= std_logic_vector(to_signed(4,reg_in3_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(24, input_code_tb'length)); 
	wait for clk_period;   
	--test for Signed Integer Multiply-Add HIGH with Saturation
	reg_in1_tb <= std_logic_vector(X"1111_1110_1100_1000_7FFF_0000_7FFF_FFFE");
	reg_in2_tb <= std_logic_vector(to_signed(1,reg_in2_tb'length));
	reg_in3_tb <= std_logic_vector(to_signed(4,reg_in3_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(25, input_code_tb'length)); 
	wait for clk_period;   
		--test for Signed Integer Multiply-sub LOW with Saturation
	reg_in1_tb <= std_logic_vector(X"1111_1110_1100_1000_7FFF_0000_7FFF_FFFE");
	reg_in2_tb <= std_logic_vector(to_signed(1,reg_in2_tb'length));
	reg_in3_tb <= std_logic_vector(to_signed(4,reg_in3_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(26, input_code_tb'length)); 
	wait for clk_period;  
		--test for Signed Integer Multiply-sub HIGH with Saturation
	reg_in1_tb <= std_logic_vector(X"1111_1110_1100_1000_7FFF_0000_7FFF_FFFE");
	reg_in2_tb <= std_logic_vector(to_signed(1,reg_in2_tb'length));
	reg_in3_tb <= std_logic_vector(to_signed(4,reg_in3_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(27, input_code_tb'length)); 
	wait for clk_period;  
		--test for Signed long Multiply-Add LOW with Saturation
	reg_in1_tb <= std_logic_vector(X"1111_1110_1100_1000_7FFF_FFFF_FFFF_FFFF");
	reg_in2_tb <= std_logic_vector(to_signed(1,reg_in2_tb'length));
	reg_in3_tb <= std_logic_vector(to_signed(4,reg_in3_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(28, input_code_tb'length)); 
	wait for clk_period;  	
	--test for Signed long Multiply-Add HIGH with Saturation
	reg_in1_tb <= std_logic_vector(X"1111_1110_1100_1000_7FFF_FFFF_FFFF_FFFF");
	reg_in2_tb <= std_logic_vector(to_signed(1,reg_in2_tb'length));
	reg_in3_tb <= std_logic_vector(to_signed(4,reg_in3_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(29, input_code_tb'length)); 
	wait for clk_period; 
	--test for Signed long Multiply-sub LOW with Saturation
	reg_in1_tb <= std_logic_vector(X"1111_1110_1100_1000_7FFF_FFFF_FFFF_FFFF");
	reg_in2_tb <= std_logic_vector(to_signed(1,reg_in2_tb'length));
	reg_in3_tb <= std_logic_vector(to_signed(4,reg_in3_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(30, input_code_tb'length)); 
	wait for clk_period; 
	--test for Signed long Multiply-sub HIGH with Saturation
	reg_in1_tb <= std_logic_vector(X"1111_1110_1100_1000_7FFF_FFFF_FFFF_FFFF");
	reg_in2_tb <= std_logic_vector(to_signed(1,reg_in2_tb'length));
	reg_in3_tb <= std_logic_vector(to_signed(4,reg_in3_tb'length));
	input_code_tb <= std_logic_vector(to_unsigned(31, input_code_tb'length)); 
	wait for clk_period;  


	
	
wait;
end process;

end ALU_T;
