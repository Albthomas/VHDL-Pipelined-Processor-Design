-----------------------------------------------------------------------
-- File Name: Register File Testbench.vhd
-- Entity Name: reg_file
-- Architecture Name: reg_file_arc
-- Author: Albert Thomas
-- Date Created: 11/11/19
-- Date Last Modified: 11/12/19
-- Description:	This is the design description for the Register File.
-- This is part of a 4 stage pipelined multimedia unit. The register
-- file is used to store the contents of the 32 128 bit registers.
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity reg_file_tb is
	
end entity;

architecture tb_arc of reg_file_tb is
--Component Declaration:
component reg_file
	port(
	--INPUTS:
	regRD1_address : in unsigned(4 downto 0); 	--r1 select
	regRD2_address : in unsigned(4 downto 0);	--r2 select
	regRD3_address : in unsigned(4 downto 0); 	--r3 select
	regWrite_address : in unsigned(4 downto 0); --reg to write address
	regWrite_val : in std_logic_vector(127 downto 0);   --input value
	rst_n: in std_logic;
	--Write Enable:
	WE : in bit;
	--OUTPUTS:
	regRD1_val : out std_logic_vector(127 downto 0);  	--r1 value
	regRD2_val : out std_logic_vector(127 downto 0);  	--r2 value
	regRD3_val : out std_logic_vector(127 downto 0)	  	--r3 value
	);	
end component;
signal RD1_address: unsigned(4 downto 0) := (others => '0'); 
signal RD2_address: unsigned(4 downto 0) := (others => '0');
signal RD3_address: unsigned(4 downto 0) := (others => '0');
signal Write_address: unsigned(4 downto 0) := (others => '0');
signal Write_val: std_logic_vector(127 downto 0) := (others => '0'); 
signal RD1_val: std_logic_vector(127 downto 0) := (others => '0');
signal RD2_val: std_logic_vector(127 downto 0) := (others => '0');
signal RD3_val: std_logic_vector(127 downto 0) := (others => '0');
signal rst_n: std_logic:= '0';
signal writeEn : bit;
begin
	U1: reg_file port map(
		regRD1_address => RD1_address,
		regRD2_address => RD2_address,
		regRD3_address => RD3_address,
		regWrite_address => Write_address,
		regWrite_val => Write_val,
		regRD1_val => RD1_val,
		regRD2_val => RD2_val,
		regRD3_val => RD3_val, 
		WE => writeEn,
		rst_n => rst_n
	);
	--Test 1: Go through each register from 0 to 31 and walk a 1 through each register 
	process
	begin
		rst_n <= '0';
		wait for 10 us;
		rst_n <= '1';
		writeEn <= '1';
		for i in 0 to 31 loop
			RD1_address <= (to_unsigned(i, 5));
			RD2_address <= (to_unsigned(i, 5));
			RD3_address <= (to_unsigned(i, 5));
			
			Write_address <= (to_unsigned(i, 5));
			for j in 0 to 127 loop
				Write_val <= (others => '0');
				Write_val(j)<= '1';
				wait for 100ns;
			end loop;
		end loop;	
		writeEn <= '0';	 
		wait for 100 us;
	--Test 2: Setup each register to hold the value of its register number: r0 = (others => '0') to r31 = unsigned(std_logic_vector(31))
	-- Then output the values of each register and verify that they are the correct value
	RD1_address <= (others => '0');
	RD2_address <= (others => '0');
	RD3_address <= (others => '0');
	writeEn <= '1';
	for i in 0 to 31 loop
		Write_address <= (to_unsigned(i,5));
		Write_val <= std_logic_vector(to_unsigned(i,128));
	end loop;
	writeEn <= '0';	
	wait for 100 us;
	for i in 0 to 29 loop
		RD1_address <= (to_unsigned(i,5));
		RD2_address <= (to_unsigned(i+1,5));
		RD3_address <= (to_unsigned(i+2,5));
		wait for 100ns;
	end loop;
		RD1_address <= (to_unsigned(30,5));
		RD2_address <= (to_unsigned(31,5));
		RD3_address <= (to_unsigned(31,5));
		wait for 100ns;
		RD1_address <= (to_unsigned(31,5));
		RD2_address <= (to_unsigned(31,5));
		RD3_address <= (to_unsigned(31,5));
		wait for 100ns;
	end process;
	
end architecture;