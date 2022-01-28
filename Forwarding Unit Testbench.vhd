-----------------------------------------------------------------------
-- File Name: Forwarding Unit Testbench.vhd
-- Entity Name: forwarding_tb
-- Architecture Name: forwarding_tb_arc
-- Author: Albert Thomas
-- Date Created: 11/23/19
-- Date Last Modified: 11/23/19
-- Description:	This is the testbench for the Forwarding Unit.
-- This entity is used in the Four Stage Pipeline project the file is
-- located in. This testbench must be attached to the forwarding Unit.vhd
-- file in order to be able to compile and test the forwarding unit.
--
-----------------------------------------------------------------------	
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity forwarding_tb is
	
end forwarding_tb;
architecture forwarding_tb_arc of forwarding_tb is
component forwarding is
port(
	newval : in std_logic_vector(127 downto 0);
	rWriteLocation : in unsigned(4 downto 0); --00000 to 11111=31 
	rCurrentLocation: in unsigned(14 downto 0); -- rs3, rs2, rs1
	newvalout : out std_logic_vector(127 downto 0);
	selectLine: out std_logic_vector(2 downto 0); --1 bit is for rs, 0 bit for rt
	rst_n : in std_logic
	);
end component;
signal newval : std_logic_vector(127 downto 0);
signal rwriteLocation: unsigned(4 downto 0);
signal rCurrent1: unsigned(4 downto 0);
signal rCurrent2: unsigned(4 downto 0);
signal rCurrent3: unsigned(4 downto 0);
signal newvalout: std_logic_vector(127 downto 0);
signal selectLine: std_logic_vector(2 downto 0);
signal rst_n: std_logic;

begin					
U1: forwarding port map( 
rst_n => rst_n,
newval => newval,
rwriteLocation => rwriteLocation,
rCurrentLocation(4 downto 0) => rCurrent1,
rCurrentLocation(9 downto 5)=> rCurrent2,
rCurrentLocation(14 downto 10) => rCurrent3,
newvalout => newvalout,
selectLine => selectLine
);		



process	
begin
	 
	for i in 0 to 31 loop --Select = "001" = 1 , in 0 loop Select = 7
		newval <= (others => '1');		  
		rwriteLocation <= (to_unsigned(i,5));
		rCurrent1 <= (to_unsigned(i,5));
		rCurrent2 <= (to_unsigned(0,5));
		rCurrent3 <= (to_unsigned(0,5));
		wait for 100ns;	
	end loop;
	for i in 0 to 31 loop --Select = "010" = 2 , in 0 loop Select = 7
		newval <= (others => '1');		  
		rwriteLocation <= (to_unsigned(i,5));
		rCurrent1 <= (to_unsigned(0,5));
		rCurrent2 <= (to_unsigned(i,5));
		rCurrent3 <= (to_unsigned(0,5));
		wait for 100ns;	
	end loop;
	
	for i in 0 to 31 loop
		newval <= (others => '1'); --Select = "011" = 3	, in 0 loop Select = 7	  
		rwriteLocation <= (to_unsigned(i,5));
		rCurrent1 <= (to_unsigned(i,5));
		rCurrent2 <= (to_unsigned(i,5));
		rCurrent3 <= (to_unsigned(0,5));
		wait for 100ns;	
	end loop;
	for i in 0 to 31 loop
		newval <= (others => '1'); --Select = "100" = 4	, in 0 loop Select = 7	  
		rwriteLocation <= (to_unsigned(i,5));
		rCurrent1 <= (to_unsigned(0,5));
		rCurrent2 <= (to_unsigned(0,5));
		rCurrent3 <= (to_unsigned(i,5));
		wait for 100ns;	
	end loop;
	for i in 0 to 31 loop
		newval <= (others => '1'); --Select = "101" = 5	, in 0 loop Select = 7	  
		rwriteLocation <= (to_unsigned(i,5));
		rCurrent1 <= (to_unsigned(i,5));
		rCurrent2 <= (to_unsigned(0,5));
		rCurrent3 <= (to_unsigned(i,5));
		wait for 100ns;	
	end loop;
	for i in 0 to 31 loop
		newval <= (others => '1'); --Select = "110" = 6	, in 0 loop Select = 7	  
		rwriteLocation <= (to_unsigned(i,5));
		rCurrent1 <= (to_unsigned(0,5));
		rCurrent2 <= (to_unsigned(i,5));
		rCurrent3 <= (to_unsigned(i,5));
		wait for 100ns;	
	end loop; 
	for i in 0 to 31 loop -- Select = "111" = 7
		newval <= (others => '1');
		rwriteLocation <= (to_unsigned(i,5));
		rCurrent1 <= (to_unsigned(i,5));
		rCurrent2 <= (to_unsigned(i,5));
		rCurrent3 <= (to_unsigned(i,5));
		wait for 100ns;	
	end loop;
	
	wait;
end process;
end architecture;