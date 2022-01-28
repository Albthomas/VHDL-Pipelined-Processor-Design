-----------------------------------------------------------------------
-- File Name: Forwarding Mux.vhd
-- Entity Name: forward_mux
-- Architecture Name: forward_mux_arc
-- Author: Albert Thomas
-- Date Created: 11/26/19
-- Date Last Modified: 11/26/19
-- Description:	This is the design description for the Forwarding Mux.
-- This entity takes a 3 bit select input to decide which 3 128 bit
-- inputs to forward.
--
-----------------------------------------------------------------------		
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity forward_mux_tb is
end entity;	  

architecture forward_mux_tb_arc	of forward_mux_tb is
component forward_mux is
	port( 
	rst_n : in std_logic;
	selectIn : in std_logic_vector(2 downto 0);
	rs1 : in std_logic_vector(127 downto 0);
	rs2 : in std_logic_vector(127 downto 0);
	rs3 : in std_logic_vector(127 downto 0);
	rsForward : in std_logic_vector(127 downto 0);
	rsOut1 : out std_logic_vector(127 downto 0);	
	rsOut2 : out std_logic_vector(127 downto 0);
	rsOut3 : out std_logic_vector(127 downto 0)
	);
end component;
	signal rst_n:std_logic;
	signal selectIn : std_logic_vector(2 downto 0);
	signal rs1 : std_logic_vector(127 downto 0);
	signal rs2 : std_logic_vector(127 downto 0);
	signal rs3 : std_logic_vector(127 downto 0);
	signal rsForward : std_logic_vector(127 downto 0);
	signal rsOut1 : std_logic_vector(127 downto 0);	
	signal rsOut2 : std_logic_vector(127 downto 0);
	signal rsOut3 : std_logic_vector(127 downto 0);
begin
U1: forward_mux port map(
rst_n => rst_n,
selectIn => selectIn,
rs1 => rs1,
rs2=> rs2,
rs3 => rs3,
rsForward => rsForward,
rsOut1 => rsOut1,
rsOut2 => rsOut2,
rsOut3 => rsOut3
);

process
begin	
	rs1 <= (others => '0');
		rs1(0) <= '1';
		rs2<= (others => '0');
		rs2(1) <= '1';
		rs3<= (others => '0');
		rs3(1 downto 0) <= (others => '1');
		rsForward <= (others => '0');
	for i in 0 to 7 loop
		
		selectIn <= std_logic_vector(to_unsigned(i,3));
		wait for 100ns;
	end loop;
	wait;
end process;
	
end architecture;