-------------------------------------------------------------------------------
--
-- Title       : EXWBreg 
-- Architecture Name: EXWBreg
-- Author: Muhammad Hussain
-- Date Created: 11/26/19
-- Date Last Modified: 11/26/19
-- Description : Pipeline register that separates the Execution and Write Back stage.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_signed.all;


entity EXWBreg is
	port( 
	clk : in	std_logic;
	DO_ALU : in std_logic_vector(127 downto 0);
	rd: in unsigned(4 downto 0);
	rs: in unsigned(14 downto 0);
	rs_out: out unsigned(14 downto 0);
	rd_out: out unsigned(4 downto 0);
	DO : out std_logic_vector(127 downto 0);
	nopcheck: in std_logic_vector(9 downto 0);
	enable: out bit -- Write Enable for Reg File
	);
end EXWBreg;

--}} End of automatically maintained section

architecture EXWBreg of EXWBreg is
begin

	 process(clk, nopcheck)
	begin
			
	if rising_edge(clk) then
		if nopcheck >= "1100000000" and nopcheck<= "1111100000" then
			--"1100100000","1101000000","1101100000","1110000000","1110100000","1111000000","1111100000"
			enable <= '0';
		else
			enable <= '1';
		end if;
		DO <= DO_ALU; 
		rd_out <= rd;
		rs_out<= rs;
		
		
	end if; 
	
	end process;

end EXWBreg;
