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
entity forward_mux is
	port(
	rst_n: in std_logic;
	selectIn : in std_logic_vector(2 downto 0);
	rs1 : in std_logic_vector(127 downto 0);
	rs2 : in std_logic_vector(127 downto 0);
	rs3 : in std_logic_vector(127 downto 0);
	rsForward : in std_logic_vector(127 downto 0);
	rsOut1 : out std_logic_vector(127 downto 0);	
	rsOut2 : out std_logic_vector(127 downto 0);
	rsOut3 : out std_logic_vector(127 downto 0)
	);
end forward_mux;
architecture forward_mux_arc of forward_mux is
begin
	process(selectIn, rs1, rs2, rs3, rsForward, rst_n)
	begin 
		if rst_n= '0' then
			rsOut1 <= (others => '0'); 
			rsOut2 <= (others => '0');
			rsOut3 <= (others => '0');
		end if;
		
		if(selectIn(0)= '1')then
			rsOut1 <= rsForward;
		else
			rsOut1 <= rs1;
		end if;
		if(selectIn(1)= '1')then
			rsOut2 <= rsForward;
		else
			rsOut2 <= rs2;
		end if;
		if(selectIn(2)= '1')then
			rsOut3 <= rsForward;
		else
			rsOut3 <= rs3;
		end if;
	end process;

end architecture;