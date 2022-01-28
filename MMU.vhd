-------------------------------------------------------------------------------
--
-- Title: MMU
-- Entity Name: MMU
-- Architecture Name: MMU
-- Author: Muhammad Hussain
-- Date Created: 11/28/19
-- Date Last Modified: 11/31/19
-- Description : Multimedia Logic Unit of the 4-stage Pipeline. Structural Design
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.buff_array_pkg.all;	
entity MMU is 
	port(
	clock: in std_logic; 
	load : in std_logic; 				  
	data_in : in buff_array; 
	rst_n: in std_logic;
	out_fromPC: out std_logic_vector(5 downto 0)
	);
	
end MMU;

--}} End of automatically maintained section

architecture MMU of MMU is
--signal for instruction buffer
signal instruction_frombuffer : std_logic_vector(24 downto 0);
--signal for PC counter
signal output_frompc :std_logic_vector(5 downto 0);	  
--signal for IF/ID register
signal instruction_fromIFID : std_logic_vector(24 downto 0);
--signal for Instruction Decoder Stage
signal opcode_fromdecoder:unsigned(4 downto 0);
signal rs1_a_fromdecoder:unsigned(4 downto 0);
signal rs2_a_fromdecoder:unsigned(4 downto 0);
signal rs3_a_fromdecoder:unsigned(4 downto 0);
signal rd_a_fromdecoder:unsigned(4 downto 0);
signal immed_fromdecoder:std_logic_vector(15 downto 0); -- imediate value
signal index_fromdecoder:std_logic_vector(2 downto 0);	 -- index value
signal WE_fromdecoder:bit;		-- Write enable control signal
--signal outputs from RegisterFile
signal D1_fromRF:std_logic_vector(127 downto 0);
signal D2_fromRF:std_logic_vector(127 downto 0);
signal D3_fromRF:std_logic_vector(127 downto 0);
--signals for ID/EX register
signal D1_fromIDEX:std_logic_vector(127 downto 0);	-- R1 value
signal D2_fromIDEX:std_logic_vector(127 downto 0);	-- R2 value
signal D3_fromIDEX:std_logic_vector(127 downto 0);	-- R3 value
signal opcode_fromIDEX:unsigned(4 downto 0);
signal rs_a_fromIDEX:unsigned(14 downto 0);
signal rd_a_fromIDEX:unsigned(4 downto 0); 
signal immed_fromIDEX:std_logic_vector(15 downto 0); 
signal index_fromIDEX:std_logic_vector(2 downto 0);	
signal instruction_fromIDEX :std_logic_vector(24 downto 0);
-- signal from Forwarding MUX
signal rsOut1_fromFMUX :std_logic_vector(127 downto 0);	
signal rsOut2_fromFMUX :std_logic_vector(127 downto 0);
signal rsOut3_fromFMUX :std_logic_vector(127 downto 0);
--signal for DataForward  
signal newvalout : std_logic_vector(127 downto 0);
signal selectLine: std_logic_vector(2 downto 0); --rs3, rs2, rs1
--signal for ALU
signal DO_fromALU:std_logic_vector(127 downto 0); 
--signal opcode_output:unsigned(4 downto 0);
--signal for EXWBreg 
signal enable_fromEXWB:bit;
signal rd_a_WB_fromEXWB:unsigned(4 downto 0); 
signal rs_a_fromEXWB:unsigned(14 downto 0);
signal DO_fromEXWB:std_logic_vector(127 downto 0);
begin
	--stage 1
	u0: entity pc_counter port map( output=>output_frompc, rst_n => rst_n, clk =>clock);	
	u1: entity InstructionBuffer port map( instr_out=>instruction_frombuffer, load => load, data_in =>data_in, pc => output_frompc);
    u2: entity IFIDreg port map( instruction=>instruction_frombuffer,inst_out=>instruction_fromIFID, clk =>clock); 
	--stage 2
	u3: entity Decoder port map( instruction => instruction_fromIFID,opcode => opcode_fromdecoder,rs1=>rs1_a_fromdecoder,
		rs2=>rs2_a_fromdecoder,rs3=>rs3_a_fromdecoder,rd=>rd_a_fromdecoder,immed =>immed_fromdecoder,index =>index_fromdecoder,
		WE => WE_fromdecoder);
	u4: entity reg_file port map(rst_n=>rst_n, regRD1_address=>rs1_a_fromdecoder,regRD2_address=>rs2_a_fromdecoder,regRD3_address => rs3_a_fromdecoder,
		regWrite_address => rd_a_fromdecoder,WE =>enable_fromEXWB,regWrite_val => DO_fromEXWB,regRD1_val=>D1_fromRF,regRD2_val=>D2_fromRF,
		regRD3_val=>D3_fromRF);
	u5: entity IDEXreg port map(clk =>clock, DS1 =>D1_fromRF, DS2=>D2_fromRF, DS3=>D3_fromRF, DS1_out =>D1_fromIDEX, DS2_out =>D2_fromIDEX,
		DS3_out =>D3_fromIDEX, opcode => opcode_fromdecoder,opcode_out=>opcode_fromIDEX, rs1_a_decode=>rs1_a_fromdecoder,
		rs2_a_decode=>rs2_a_fromdecoder,rs3_a_decode=>rs3_a_fromdecoder,rd_a_decode=>rd_a_fromdecoder,rs1_a_out=>rs_a_fromIDEX(4 downto 0),rs2_a_out=>rs_a_fromIDEX(9 downto 5),
		rs3_a_out=>rs_a_fromIDEX(14 downto 10), rd_a_out=>rd_a_fromIDEX,immed_i =>immed_fromdecoder,index_i =>index_fromdecoder,immed_o =>immed_fromIDEX,
		index_o =>index_fromIDEX, instruction=> instruction_fromIFID, instruction_out=> instruction_fromIDEX);	
	--stage 3
	u6: entity forward_mux port map(rst_n => rst_n,  selectIn=>selectLine, rs1=>D1_fromIDEX, rs2=>D2_fromIDEX, rs3=>D3_fromIDEX, rsForward=>newvalout,
		rsOut1=>rsOut1_fromFMUX, rsOut2=>rsOut2_fromFMUX, rsOut3=>rsOut3_fromFMUX );
	u7: entity ALU port map (rst_n => rst_n, input_code=> instruction_fromIDEX, reg_in1 =>rsOut1_fromFMUX,reg_in2 =>rsOut2_fromFMUX,
		reg_in3 =>rsOut3_fromFMUX, reg_d=>DO_fromALU);
	--stage 4
	u8: entity EXWBreg port map( clk =>clock,nopcheck=> instruction_fromIDEX(24 downto 15),DO_ALU => DO_fromALU,rd =>rd_a_fromIDEX, enable=> enable_fromEXWB ,DO => DO_fromEXWB,rd_out=>rd_a_WB_fromEXWB, rs=> rs_a_fromIDEX, rs_out=> rs_a_fromEXWB);
	u9: entity forwarding port map(rst_n=> rst_n, newval=>DO_fromEXWB ,rWriteLocation=>rd_a_WB_fromEXWB , rCurrentLocation=>rs_a_fromEXWB, newvalout=> newvalout , selectLine=> selectLine); 	
out_fromPC <= output_frompc;	

end MMU;
