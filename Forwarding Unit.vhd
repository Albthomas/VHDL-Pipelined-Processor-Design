-----------------------------------------------------------------------
-- File Name: Forwarding Unit.vhd
-- Entity Name: forwarding
-- Architecture Name: forwarding_arc
-- Author: Albert Thomas
-- Date Created: 11/23/19
-- Date Last Modified: 11/23/19
-- Description:	This is the design description for the Forwarding Unit.
-- This engity is used in the Four Stage Pipeline project the file is
-- located in. This fixes hazards where instructions have register 
-- values that are not up to date because the previous instruction had
-- yet to write to new value to the register.
--
--
-----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
entity forwarding is
	port(  
	rst_n : in std_logic;
	newval : in std_logic_vector(127 downto 0);
	rWriteLocation : in unsigned(4 downto 0); --00000 to 11111=31 
	rCurrentLocation: in unsigned(14 downto 0); -- rs3, rs2, rs1
	newvalout : out std_logic_vector(127 downto 0);
	selectLine: out std_logic_vector(2 downto 0) --rs3, rs2, rs1
	);
	
end forwarding;
architecture forwarding_arc of forwarding is
begin
	newvalout<= newval;
	process(rCurrentLocation,rWriteLocation, newval, rst_n)
	begin 
		if rst_n = '0' then
			newvalout <= (others => '0'); 
			selectLine <= (others => '0');
		end if;
	
		if (rCurrentLocation(4 downto 0) = rWriteLocation) then --rs1
			SelectLine(0) <= '1';
		else
			SelectLine(0) <= '0';
		end if;
			
		if (rCurrentLocation(9 downto 5) = rWriteLocation) then	--rs2
			SelectLine(1)<= '1';
		else
			SelectLine(1)<='0';
			
		end if;
		if (rCurrentLocation(14 downto 10) = rWriteLocation) then--rs3
			SelectLine(2)<= '1';
		else
			SelectLine(2)<='0';
			
		end if;
	end process;
	
end architecture;