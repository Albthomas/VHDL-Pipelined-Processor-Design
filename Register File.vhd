-----------------------------------------------------------------------
-- File Name: Register File.vhd
-- Entity Name: reg_file
-- Architecture Name: reg_file_arc
-- Author: Muhammad Hussaiin
-- Date Created: 11/11/19
-- Date Last Modified: 11/12/19
-- Description:	This is the design description for the Register File.
-- This is part of a 4 stage pipelined multimedia unit. The register
-- file is used to store the contents of the 32 128 bit registers.
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
	port(
	--INPUTS:
	regRD1_address : in unsigned(4 downto 0); 	--r1 select
	regRD2_address : in unsigned(4 downto 0);	--r2 select
	regRD3_address : in unsigned(4 downto 0); 	--r3 select
	regWrite_address : in unsigned(4 downto 0); --reg to write address
	regWrite_val : in std_logic_vector(127 downto 0);   --input value	
	WE: in bit;  -- Write Enable Control Bit  
	rst_n : in std_logic; 
	--OUTPUTS:
	regRD1_val : out std_logic_vector(127 downto 0);  	--r1 value
	regRD2_val : out std_logic_vector(127 downto 0);  	--r2 value
	regRD3_val : out std_logic_vector(127 downto 0)	  	--r3 value
	);
	
end reg_file;	
architecture reg_file_arc of reg_file is
type regfile is array (0 to 31) of std_logic_vector(127 downto 0);
signal regarray : regfile;
begin
	process (WE, regWrite_address, regarray, regRD1_address, regRD2_address, regRD3_address, rst_n)
	begin  
		if(rst_n = '0') then
			regarray(to_integer(unsigned(regWrite_address))) <=  (others => '0');
			regRD1_val <= (others => '0');  -- output 1
			regRD2_val <= (others => '0');
			regRD3_val <= (others => '0');
		end if;
		
		if(WE = '1') then
		regarray(to_integer(unsigned(regWrite_address))) <= regWrite_val; -- change held value first  
		if regRD1_address = regWrite_address then
			regRD1_val <= regWrite_val;
		end if;
		if regRD2_address = regWrite_address then
			regRD2_val <= regWrite_val;
		end if;
		if regRD3_address = regWrite_address then
			regRD3_val <= regWrite_val;
		end if;
			
		regRD1_val <= std_logic_vector(regarray(to_integer(unsigned(regRD1_address))));	  -- output 1
		regRD2_val <= std_logic_vector(regarray(to_integer(unsigned(regRD2_address))));	  -- output 2
		regRD3_val <= std_logic_vector(regarray(to_integer(unsigned(regRD3_address))));	  -- output 3
		end if;
	end process;
	

end architecture;