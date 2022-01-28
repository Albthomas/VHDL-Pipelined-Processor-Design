-----------------------------------------------------------------------
-- File Name: Multimedia ALU.vhd
-- Entity Name: ALU
-- Architecture Name: ALU_arc
-- Author: Albert Thomas
-- Date Created: 11/03/19
-- Date Last Modified: 11/08/19
-- Description: This design description is for a component in the 3rd
-- stage (execute) of the four stage pipleine that it is a part of. The
-- purpose of the ALU is to conduct all the operations done in this
-- processor that are logical, arithmetic, or shifting.
--
--
-----------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all; 
use ieee.numeric_std.all;

entity ALU is
	port(
	rst_n : in std_logic;
	 input_code : in std_logic_vector(24 downto 0);
	 reg_in1 : in std_logic_vector(127 downto 0);
	 reg_in2 : in std_logic_vector(127 downto 0);
	 reg_in3 : in std_logic_vector(127 downto 0);
	 reg_d : out std_logic_vector(127 downto 0)
	     );
end ALU;

--}} End of automatically maintained section

architecture ALU_arc of ALU is
begin
	process(rst_n, input_code, reg_in1, reg_in2, reg_in3)
	variable temp1 : std_logic_vector(127 downto 0) := (others => '0');
	variable temp2 : std_logic_vector(63 downto 0) := (others => '0');
	variable temp3 : std_logic_vector(63 downto 0) := (others => '0');
	variable temp4 : std_logic_vector(63 downto 0) := (others => '0');
	variable int : integer := 0; --used to test saturation	
	variable testvectorpos : std_logic_vector(127 downto 0):= (others => '1');
	
	variable testvectorneg : std_logic_vector(127 downto 0):=(others => '0');

	begin
		if rst_n=  '0' then
			reg_d <= (others => '0');
		end if;
		
	testvectorpos(127) := '0';
	testvectorneg(127):= '1';
	testvectorpos(0):= '1';
	case input_code(24 downto 23) is
		when "00" | "01" =>	
			--load immediate instruction 
			--input code bits 23:21 are load index
			--input code bits 20:5 are the 16 bit immediate value
			--immediate value is only loaded into 
			reg_d(127 downto 16) <= (others => '0'); -- initialize reg_d to all 0's
			reg_d((15 + ((16*to_integer(unsigned(input_code(23 downto 21)))))) downto ((16*to_integer(unsigned(input_code(23 downto 21)))))) <= input_code(20 downto 5);
			--
		when "10" =>
			--multiply-add and multiply-subtract r4-instruction format
			
			case input_code(22 downto 20) is
				when "000" =>
				--multiply low 16 bit fields of each 32 bit field - there are 4 32 bit fields for 128 bit registers
					for i in 0 to 3 loop
						int := to_integer(signed(reg_in3((16*(i+1) - 1) downto (16*(i+1) - 16))) * signed(reg_in2((16*(i+1) - 1) downto (16*(i+1) - 16))));		  
						if (int> 2147483647) then --greater than 2^31 -1 which is max value supported
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(to_signed(+2147483647,32));	
						elsif	(int< -2147483648) then
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(to_signed(-2147483648, 32));
						else
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(signed(reg_in3((16*(i+1) - 1) downto (16*(i+1) - 16))) * signed(reg_in2((16*(i+1) - 1) downto (16*(i+1) - 16))));
					end if;
					end loop;
					
					--add 32 bit field products to reg_d
					for i in 0 to 3 loop
						if (to_integer(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) + signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))))> 2147483647) then
							reg_d((32*(i+1) - 1) downto (32*(i+1) - 32))<= std_logic_vector(to_signed(+2147483647,32));
						elsif (to_integer(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) + signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))))< -2147483648) then 
							 reg_d((32*(i+1) - 1) downto (32*(i+1) - 32))<= std_logic_vector(to_signed(-2147483648, 32));	
						else
							reg_d((32*(i+1) - 1) downto (32*(i+1) - 32)) <= std_logic_vector(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) + signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))));
						end if;
					end loop;
					
					  
				when "001" => 
					--multiply high 16 bit fields of each 32 bit field - there are 4 32 bit fields for 128 bit registers
					for i in 0 to 3 loop
						int := to_integer(signed(reg_in3((32*(i+1) - 1) downto (32*(i+1) - 16))) * signed(reg_in2((32*(i+1) - 1) downto (32*(i+1) - 16))));		  
						if (int> 2147483647) then --greater than 2^31 -1 which is max value supported
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(to_signed(+2147483647,32));	
						elsif	(int< -2147483648) then
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(to_signed(-2147483648, 32));
						else
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(signed(reg_in3((32*(i+1) - 1) downto (32*(i+1) - 16))) * signed(reg_in2((32*(i+1) - 1) downto (32*(i+1) - 16))));
					end if;
					end loop;
					--add 32 bit field products to reg_d													  
					for i in 0 to 3 loop
						if (to_integer(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) + signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))))> 2147483647) then
							reg_d((32*(i+1) - 1) downto (32*(i+1) - 32))<= std_logic_vector(to_signed(+2147483647,32));
						elsif (to_integer(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) + signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))))< -2147483648) then 
							 reg_d((32*(i+1) - 1) downto (32*(i+1) - 32))<= std_logic_vector(to_signed(-2147483648, 32));	
						else
							reg_d((32*(i+1) - 1) downto (32*(i+1) - 32)) <= std_logic_vector(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) + signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))));
						end if;
					end loop;
					
					
				when "010" =>
					--multiply low 16 bit fields of each 32 bit field - there are 4 32 bit fields for 128 bit registers
					for i in 0 to 3 loop
						int := to_integer(signed(reg_in3((16*(i+1) - 1) downto (16*(i+1) - 16))) * signed(reg_in2((16*(i+1) - 1) downto (16*(i+1) - 16))));		  
						if (int> 2147483647) then --greater than 2^31 -1 which is max value supported
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(to_signed(+2147483647,32));	
						elsif	(int< -2147483648) then
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(to_signed(-2147483648, 32));
						else
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(signed(reg_in3((16*(i+1) - 1) downto (16*(i+1) - 16))) * signed(reg_in2((16*(i+1) - 1) downto (16*(i+1) - 16))));
					end if;
					end loop;	
					--subtract 32 bit field products to reg_d														  
					for i in 0 to 3 loop
						if (to_integer(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) - signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))))> 2147483647) then
							reg_d((32*(i+1) - 1) downto (32*(i+1) - 32))<= std_logic_vector(to_signed(+2147483647,32));
						elsif (to_integer(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) - signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))))< -2147483648) then 
							 reg_d((32*(i+1) - 1) downto (32*(i+1) - 32))<= std_logic_vector(to_signed(-2147483648, 32));	
						else
							reg_d((32*(i+1) - 1) downto (32*(i+1) - 32)) <= std_logic_vector(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) - signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))));
						end if;
					end loop;
				when "011" =>
					--multiply high 16 bit fields of each 32 bit field - there are 4 32 bit fields for 128 bit registers
					for i in 0 to 3 loop
						int := to_integer(signed(reg_in3((32*(i+1) - 1) downto (32*(i+1) - 16))) * signed(reg_in2((32*(i+1) - 1) downto (32*(i+1) - 16))));		  
						if (int> 2147483647) then --greater than 2^31 -1 which is max value supported
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(to_signed(+2147483647,32));	
						elsif	(int< -2147483648) then
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(to_signed(-2147483648, 32));
						else
							temp1((32*(i+1) - 1) downto (32*(i+1) - 32)) := std_logic_vector(signed(reg_in3((32*(i+1) - 1) downto (32*(i+1) - 16))) * signed(reg_in2((32*(i+1) - 1) downto (32*(i+1) - 16))));
					end if;
					end loop;
					--subtract 32 bit field products to reg_d													  
					for i in 0 to 3 loop
						if (to_integer(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) - signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))))> 2147483647) then
							reg_d((32*(i+1) - 1) downto (32*(i+1) - 32))<= std_logic_vector(to_signed(+2147483647,32));
						elsif (to_integer(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) - signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))))< -2147483648) then 
							 reg_d((32*(i+1) - 1) downto (32*(i+1) - 32))<= std_logic_vector(to_signed(-2147483648, 32));	
						else
							reg_d((32*(i+1) - 1) downto (32*(i+1) - 32)) <= std_logic_vector(signed(reg_in1((32*(i+1) - 1) downto (32*(i+1) - 32))) - signed(temp1((32*(i+1) - 1) downto (32*(i+1) - 32))));
						end if;
					end loop;
				when "100" =>
					-- multiply low 32 bit fields of each 64 bit field of r3 and r2
					for i in 0 to 1 loop
						int := to_integer(signed(reg_in3((64*(i+1) - 33) downto (64*(i+1) - 64))) * signed(reg_in2((64*(i+1) - 33) downto (64*(i+1) - 64))));		  
						if (int> to_integer(signed(testvectorpos))) then --greater than 2^31 -1 which is max value supported
							temp1((64*(i+1) - 1) downto (64*(i+1) - 64)) := testvectorpos;	
						elsif	(int< to_integer(signed(testvectorneg))) then
							temp1((64*(i+1) - 1) downto (64*(i+1) - 64)) := testvectorneg;
						else
							temp1((64*(i+1) - 1) downto (64*(i+1) - 64)) := std_logic_vector(signed(reg_in3((64*(i+1) - 33) downto (64*(i+1) - 64))) * signed(reg_in2((64*(i+1) - 33) downto (64*(i+1) - 64))));
					end if;
					end loop;
					-- add temp1 to low 64 bits and temp2 to high 64 bits
					for i in 0 to 1 loop
						if (to_integer(signed(reg_in1((61*(i+1) - 1) downto (61*(i+1) - 64))) + signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))))> to_integer(signed(testvectorpos))) then
							reg_d((64*(i+1) - 1) downto (64*(i+1) - 64))<= std_logic_vector(to_signed(+2147483647,32));
						elsif (to_integer(signed(reg_in1((64*(i+1) - 1) downto (64*(i+1) - 64))) + signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))))< to_integer(signed(testvectorneg))) then 
							 reg_d((64*(i+1) - 1) downto (64*(i+1) - 64))<= std_logic_vector(to_signed(-2147483648, 32));	
						else
							reg_d((64*(i+1) - 1) downto (64*(i+1) - 64)) <= std_logic_vector(signed(reg_in1((64*(i+1) - 1) downto (64*(i+1) - 64))) + signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))));
						end if;
					end loop;
				when "101" =>
					--multiply high 32 bit fields of each 64 bit field of r3 and r2
					for i in 0 to 1 loop
						int := to_integer(signed(reg_in3((64*(i+1) - 1) downto (64*(i+1) - 32))) * signed(reg_in2((64*(i+1) - 1) downto (64*(i+1) - 32))));		  
						if (int> to_integer(signed(testvectorpos))) then --greater than 2^31 -1 which is max value supported
							temp1((64*(i+1) - 1) downto (64*(i+1) - 64)) := testvectorpos;	
						elsif	(int< to_integer(signed(testvectorneg))) then
							temp1((64*(i+1) - 1) downto (64*(i+1) - 64)) := testvectorneg;
						else
							temp1((64*(i+1) - 1) downto (64*(i+1) - 64)) := std_logic_vector(signed(reg_in3((64*(i+1) - 1) downto (64*(i+1) - 32))) * signed(reg_in2((64*(i+1) - 1) downto (64*(i+1) - 32))));
					end if;
					end loop;
					-- add temp1 to low 64 bits and temp2 to high 64 bits
					for i in 0 to 1 loop
						if (to_integer(signed(reg_in1((61*(i+1) - 1) downto (61*(i+1) - 64))) + signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))))> to_integer(signed(testvectorpos))) then
							reg_d((64*(i+1) - 1) downto (64*(i+1) - 64))<= std_logic_vector(to_signed(+2147483647,32));
						elsif (to_integer(signed(reg_in1((64*(i+1) - 1) downto (64*(i+1) - 64))) + signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))))< to_integer(signed(testvectorneg))) then 
							 reg_d((64*(i+1) - 1) downto (64*(i+1) - 64))<= std_logic_vector(to_signed(-2147483648, 32));	
						else
							reg_d((64*(i+1) - 1) downto (64*(i+1) - 64)) <= std_logic_vector(signed(reg_in1((64*(i+1) - 1) downto (64*(i+1) - 64))) + signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))));
						end if;
					end loop;
				when "110" =>
					--multiply low 32 bit fields of each 64 bit field of r3 and r2
					for i in 0 to 1 loop
						int := to_integer(signed(reg_in3((64*(i+1) - 33) downto (64*(i+1) - 64))) * signed(reg_in2((64*(i+1) - 33) downto (64*(i+1) - 64))));		  
						if (int> to_integer(signed(testvectorpos))) then --greater than 2^31 -1 which is max value supported
							temp1((64*(i+1) - 1) downto (64*(i+1) - 64)) := testvectorpos;	
						elsif	(int< to_integer(signed(testvectorneg))) then
							temp1((64*(i+1) - 1) downto (64*(i+1) - 64)) := testvectorneg;
						else
							temp1((64*(i+1) - 1) downto (64*(i+1) - 64)) := std_logic_vector(signed(reg_in3((64*(i+1) - 1) downto (64*(i+1) - 32))) * signed(reg_in2((64*(i+1) - 32) downto (64*(i+1) - 64))));
					end if;
					end loop;
					-- subtract temp1 to low 64 bits and temp2 to high 64 bits
					for i in 0 to 1 loop
						if (to_integer(signed(reg_in1((61*(i+1) - 1) downto (61*(i+1) - 64))) - signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))))> to_integer(signed(testvectorpos))) then
							reg_d((64*(i+1) - 1) downto (64*(i+1) - 64))<= std_logic_vector(to_signed(+2147483647,32));
						elsif (to_integer(signed(reg_in1((64*(i+1) - 1) downto (64*(i+1) - 64))) + signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))))< to_integer(signed(testvectorneg))) then 
							 reg_d((64*(i+1) - 1) downto (64*(i+1) - 64))<= std_logic_vector(to_signed(-2147483648, 32));	
						else
							reg_d((64*(i+1) - 1) downto (64*(i+1) - 64)) <= std_logic_vector(signed(reg_in1((64*(i+1) - 1) downto (64*(i+1) - 64))) - signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))));
						end if;
					end loop;
				when others =>
					--multiply high 32 bit fields of each 64 bit field of r3 and r2
					temp1(63 downto 0):= std_logic_vector(signed(reg_in3(63 downto 32)) * signed(reg_in2(63 downto 32)));
					temp2(63 downto 0):= std_logic_vector(signed(reg_in3(127 downto 96)) * signed(reg_in2(127 downto 96)));
					-- subtract temp1 to low 64 bits and temp2 to high 64 bits
					for i in 0 to 1 loop
						if (to_integer(signed(reg_in1((61*(i+1) - 1) downto (61*(i+1) - 64))) - signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))))> to_integer(signed(testvectorpos))) then
							reg_d((64*(i+1) - 1) downto (64*(i+1) - 64))<= std_logic_vector(to_signed(+2147483647,32));
						elsif (to_integer(signed(reg_in1((64*(i+1) - 1) downto (64*(i+1) - 64))) + signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))))< to_integer(signed(testvectorneg))) then 
							 reg_d((64*(i+1) - 1) downto (64*(i+1) - 64))<= std_logic_vector(to_signed(-2147483648, 32));	
						else
							reg_d((64*(i+1) - 1) downto (64*(i+1) - 64)) <= std_logic_vector(signed(reg_in1((64*(i+1) - 1) downto (64*(i+1) - 64))) - signed(temp1((64*(i+1) - 1) downto (64*(i+1) - 64))));
						end if;
					end loop;
			end case;
		when others =>
		-- R3 instruction format
		--check bits (4:0)
			case input_code(19 downto 15) is
				when "00000" =>
					--nop
					reg_d <= (others => '0');
				
				when "00001" =>
					reg_d(15 downto 0) <= std_logic_vector(unsigned(reg_in1(15 downto 0)) + unsigned(reg_in2(15 downto 0))); 
					reg_d(31 downto 16) <= std_logic_vector(unsigned(reg_in1(31 downto 16)) + unsigned(reg_in2(31 downto 16)));
					reg_d(47 downto 32) <= std_logic_vector(unsigned(reg_in1(47 downto 32)) + unsigned(reg_in2(47 downto 32)));
					reg_d(63 downto 48) <= std_logic_vector(unsigned(reg_in1(63 downto 48)) + unsigned(reg_in2(63 downto 48)));
					reg_d(79 downto 64) <= std_logic_vector(unsigned(reg_in1(79 downto 64)) + unsigned(reg_in2(79 downto 64)));
					reg_d(95 downto 80) <= std_logic_vector(unsigned(reg_in1(95 downto 80)) + unsigned(reg_in2(95 downto 80)));
					reg_d(111 downto 96) <= std_logic_vector(unsigned(reg_in1(111 downto 96)) + unsigned(reg_in2(111 downto 96)));
					reg_d(127 downto 112) <= std_logic_vector(unsigned(reg_in1(127 downto 112)) + unsigned(reg_in2(127 downto 112)));
				when "00010" =>
					reg_d(7 downto 0) <= std_logic_vector(unsigned(reg_in1(7 downto 0)) + unsigned(reg_in2(7 downto 0))); 
					reg_d(15 downto 8) <= std_logic_vector(unsigned(reg_in1(15 downto 8)) + unsigned(reg_in2(15 downto 8))); 
					reg_d(23 downto 16) <= std_logic_vector(unsigned(reg_in1(23 downto 16)) + unsigned(reg_in2(23 downto 16)));
					reg_d(31 downto 24) <= std_logic_vector(unsigned(reg_in1(31 downto 24)) + unsigned(reg_in2(31 downto 24)));
					reg_d(37 downto 32) <= std_logic_vector(unsigned(reg_in1(37 downto 32)) + unsigned(reg_in2(37 downto 32)));
					reg_d(47 downto 38) <= std_logic_vector(unsigned(reg_in1(47 downto 38)) + unsigned(reg_in2(47 downto 38)));
					reg_d(55 downto 48) <= std_logic_vector(unsigned(reg_in1(55 downto 48)) + unsigned(reg_in2(55 downto 48)));
					reg_d(63 downto 56) <= std_logic_vector(unsigned(reg_in1(63 downto 56)) + unsigned(reg_in2(63 downto 56)));
					reg_d(71 downto 64) <= std_logic_vector(unsigned(reg_in1(71 downto 64)) + unsigned(reg_in2(71 downto 64)));
					reg_d(79 downto 72) <= std_logic_vector(unsigned(reg_in1(79 downto 72)) + unsigned(reg_in2(79 downto 72)));
					reg_d(87 downto 80) <= std_logic_vector(unsigned(reg_in1(87 downto 80)) + unsigned(reg_in2(87 downto 80)));
					reg_d(95 downto 87) <= std_logic_vector(unsigned(reg_in1(95 downto 87)) + unsigned(reg_in2(95 downto 87)));
					reg_d(103 downto 96) <= std_logic_vector(unsigned(reg_in1(103 downto 96)) + unsigned(reg_in2(103 downto 96)));
					reg_d(111 downto 104) <= std_logic_vector(unsigned(reg_in1(111 downto 104)) + unsigned(reg_in2(111 downto 104)));
					reg_d(119 downto 112) <= std_logic_vector(unsigned(reg_in1(119 downto 112)) + unsigned(reg_in2(119 downto 112)));
					reg_d(127 downto 119) <= std_logic_vector(unsigned(reg_in1(127 downto 119)) + unsigned(reg_in2(127 downto 119)));
				-- AHS: add halfword saturated : packed 16-bit halfword signed addition with saturation
				-- of the contents of registers rs1 and rs2	
				when "00011" =>
					for i in 0 to 7 loop
					int := to_integer(signed(reg_in1((8*(i+1) - 1) downto (i*8))) + signed(reg_in2((8*(i+1) - 1) downto (i*8))));
						if (int > 255) then --greater than 2^8 -1 which is max value supported
								temp1((8*(i+1) - 1) downto (i*8)) := std_logic_vector(to_signed(+255,8));	
						elsif	(int < -257) then
							temp1((8*(i+1) - 1) downto (i*8)) := std_logic_vector(to_signed(-257, 8));
						else
						temp1((8*(i+1) - 1) downto (i*8)) := std_logic_vector(signed(reg_in1((8*(i+1) - 1) downto (i*8))) + signed(reg_in2((8*(i+1) - 1) downto (i*8)))); 
						end if;
					end loop;
					
					for i in 8 to 15 loop
					int := to_integer(signed(reg_in1((8*(i+1) - 1) downto (i*8))) + signed(reg_in2((8*(i+1) - 1) downto (i*8))));
						if (int > 255) then --greater than 2^8 -1 which is max value supported
								temp2((8*(i+1) - 1) downto (i*8)) := std_logic_vector(to_signed(+255,8));	
						elsif	(int < -257) then
							temp2((8*(i+1) - 1) downto (i*8)) := std_logic_vector(to_signed(-257, 8));
						else
						temp2((8*(i+1) - 1) downto (i*8)) := std_logic_vector(signed(reg_in1((8*(i+1) - 1) downto (i*8))) + signed(reg_in2((8*(i+1) - 1) downto (i*8)))); 
						
						end if;
					end loop;
				reg_d(63 downto 0) <= temp1(63 downto 0);
				reg_d(127 downto 64) <= temp2;
					
				when "00100" =>														
					for i in 0 to 127 loop					 
						reg_d(i) <= reg_in2(i) or reg_in1(i);
					end loop;
				when "00101" =>
					reg_d(31 downto 0) <= reg_in1(31 downto 0);
					reg_d(63 downto 32) <= reg_in1(31 downto 0);
					reg_d(95 downto 64) <= reg_in1(31 downto 0);
					reg_d(127 downto 96) <= reg_in1(31 downto 0);
				when "00110" =>
					for i in 0 to 3	loop
						for j in 31 downto 0 loop
							if(reg_in1((i*32)+j)) = '0' then
								
							else
								reg_d(((i+1)*32 - 1)downto (i*32)) <= std_logic_vector(to_unsigned(j-31, 32)); --fix value of count!!!!!
								exit;
							end if;
						end loop;
					end loop;
				when "00111" =>
					for i in 0 to 3 loop
						if(reg_in1(((i+1)*32 - 1)downto (i*32)) > reg_in2(((i+1)*32 - 1)downto (i*32)))	then
							reg_d(((i+1)*32 - 1)downto (i*32)) <= reg_in1(((i+1)*32 - 1)downto (i*32));
							
						else
							reg_d(((i+1)*32 - 1)downto (i*32)) <= reg_in2(((i+1)*32 - 1)downto (i*32));
						end if;
					end loop;
				when "01000" =>
					for i in 0 to 3 loop
						if(reg_in1(((i+1)*32 - 1)downto (i*32)) < reg_in2(((i+1)*32 - 1)downto (i*32)))	then
							reg_d(((i+1)*32 - 1)downto (i*32)) <= reg_in1(((i+1)*32 - 1)downto (i*32));
							
						else
							reg_d(((i+1)*32 - 1)downto (i*32)) <= reg_in2(((i+1)*32 - 1)downto (i*32));
						end if;
					end loop;
				-- MSGN: multiply sign: for each of the four 32-bit word slots, the signed value in register rs1 is multiplied by the sign of the word in vector rs2 with saturation, and the result placed in register rd . 
				when "01001" =>	
				for i in 0 to 3 loop  
					int := to_integer(signed(reg_in1(((i+1)*32 - 1)downto (i*32))) * signed(reg_in2(((i+1)*32 - 1)downto (i*32))));
					if (int> 2147483647) then --greater than 2^31 -1 which is max value supported
							temp1((32*(i+1) - 1) downto (32*i)) := std_logic_vector(to_signed(+2147483647,32));	
						elsif	(int< -2147483648) then
							temp1((32*(i+1) - 1) downto (32*i)) := std_logic_vector(to_signed(-2147483648, 32));
						else
							temp1(((i+1)*32 - 1) downto (i*32)) := std_logic_vector(signed(reg_in1(((i+1)*32 - 1) downto (i*32))) - signed(reg_in2(((i+1)*32 - 1) downto (i*32))));
					end if;
				end loop;
					
				reg_d <= temp1;
				
				when "01010" =>
					temp1(31 downto 0) := std_logic_vector(unsigned(reg_in1(15 downto 0)) * unsigned(reg_in2(15 downto 0)));
					temp1(63 downto 32) := std_logic_vector(unsigned(reg_in1(47 downto 32)) * unsigned(reg_in2(47 downto 32)));
					temp2(31 downto 0) := std_logic_vector(unsigned(reg_in1(79 downto 64)) * unsigned(reg_in2(79 downto 64)));
					temp2(63 downto 32) := std_logic_vector(unsigned(reg_in1(111 downto 96)) * unsigned(reg_in2(111 downto 96)));
					
					reg_d(63 downto 0) <=temp1(63 downto 0);
					reg_d(63 downto 0) <= temp2;
				when "01011" =>
					for i in 127 downto 0 loop
						reg_d(i) <= reg_in1(i) or reg_in2(i);
					end loop;
				when "01100" =>		  
					
					for i in 0 to 7 loop
						temp1 := (others => '0');
						for j in 0 to 31 loop
							if reg_in1((i*32)+j) = '1' then
								temp1(((i*5)+4) downto (i * 5)) := std_logic_vector(unsigned(temp1(4 downto 0)) + 1);
							end if;
						end loop;
						reg_d(4 downto 0) <= temp1(4 downto 0);
						reg_d(20 downto 16) <= temp1(9 downto 5);
						reg_d(36 downto 32) <= temp1(14 downto 10);
						reg_d(52 downto 48) <= temp1(19 downto 15);
						reg_d(68 downto 64) <= temp1(24 downto 20);
						reg_d(84 downto 80) <= temp1(29 downto 25);
						reg_d(100 downto 96) <= temp1(34 downto 30);
						reg_d(116 downto 112) <= temp1(39 downto 35);
						
					end loop;
				when "01101" =>
					temp1((to_integer(unsigned(reg_in2(6 downto 0))))downto 0) := reg_in1((to_integer(unsigned(reg_in2(6 downto 0))))downto 0);
					reg_d(127 downto (127 - (to_integer(unsigned(reg_in2(6 downto 0)))))) <= temp1((to_integer(unsigned(reg_in2(6 downto 0))))downto 0);
					reg_d((126 - (to_integer(unsigned(reg_in2(6 downto 0))))) downto 0) <= reg_in1(127 downto(1 + ((to_integer(unsigned(reg_in2(6 downto 0)))))));
				when "01110" =>
					-- reg_d(31 downto 0)
					temp1((to_integer(unsigned(reg_in2(4 downto 0))))downto 0) := reg_in1((to_integer(unsigned(reg_in2(4 downto 0))))downto 0);
					reg_d(31 downto (31 - (to_integer(unsigned(reg_in2(4 downto 0)))))) <= temp1((to_integer(unsigned(reg_in2(4 downto 0))))downto 0);
					reg_d((30 - (to_integer(unsigned(reg_in2(4 downto 0))))) downto 0)	<= reg_in1(31 downto (1 + ((to_integer(unsigned(reg_in2(4 downto 0)))))));
					
					-- reg_d(63 downto 32)
					temp2((to_integer(unsigned(reg_in2(4 downto 0))))downto 0) := reg_in1(((to_integer(unsigned(reg_in2(36 downto 32)))) + 32 )downto 32);
					reg_d(63 downto (63 - to_integer(unsigned(reg_in2(36 downto 32)))) ) <= temp2((to_integer(unsigned(reg_in2(4 downto 0))))downto 0);
					reg_d(62 - (to_integer(unsigned(reg_in2(36 downto 32)))) downto 32 ) <= reg_in1(63 downto ((to_integer(unsigned(reg_in2(36 downto 32)))) + 33 ));
					
					-- reg_d(95 downto 64)
					temp3((to_integer(unsigned(reg_in2(68 downto 64))))downto 0) := reg_in1((to_integer(unsigned(reg_in2(68 downto 64)))+64)downto 64);
					reg_d(95 downto (95 - to_integer(unsigned(reg_in2(68 downto 64)))))	<= temp3((to_integer(unsigned(reg_in2(68 downto 64))))downto 0);
					reg_d(94 - (to_integer(unsigned(reg_in2(68 downto 64)))) downto 64) <= reg_in1(95 downto to_integer(unsigned(reg_in2(68 downto 64)))+ 65);
					
					-- reg_d(127 downto 96)
					temp4((to_integer(unsigned(reg_in2(4 downto 0))))downto 0) := reg_in1((to_integer(unsigned(reg_in2(100 downto 96)))+96)downto 96);
					reg_d(127 downto (127 - to_integer(unsigned(reg_in2(100 downto 96))))) <= temp4((to_integer(unsigned(reg_in2(4 downto 0))))downto 0);
					reg_d(126 - to_integer(unsigned(reg_in2(100 downto 96))) downto 96) <= reg_in1(127 downto to_integer(unsigned(reg_in2(100 downto 96))) + 97);
					
					
				when "01111" =>
					temp1 := (others => '0');
					for i in 0 to 3 loop
						temp1(((i+1)*16 - 1) downto (i*16)) := std_logic_vector(unsigned(reg_in1(((i+1)*16 - 1) downto (i*16))) * unsigned(reg_in2(3 downto 0)));
					end loop;
					for i in 4 to 7 loop
						temp2(((i+1)*16 - 1) downto (i*16)) := std_logic_vector(unsigned(reg_in1(((i+1)*16 - 1) downto (i*16))) * unsigned(reg_in2(3 downto 0)));
					end loop;
					reg_d(63 downto 0) <= temp1(63 downto 0);
					reg_d(127 downto 64) <= temp2;
				-- SFH: subtract from halfword : packed 16-bit halfword unsigned subtract of the contents of rs1 from rs2(rd = rs2 - rs1).
				when "10000" =>
				for i in 0 to 3 loop
					temp1(((i+1)*16 - 1) downto (i*16)) := std_logic_vector(unsigned(reg_in1(((i+1)*16 - 1) downto (i*16))) - unsigned(reg_in2(((i+1)*16 - 1) downto (i*16))));
				end loop;
				for i in 4 to 7 loop
					temp2(((i+1)*16 - 1) downto (i*16)) := std_logic_vector(unsigned(reg_in1(((i+1)*16 - 1) downto (i*16))) - unsigned(reg_in2(((i+1)*16 - 1) downto (i*16))));
				end loop;
				reg_d(63 downto 0) <= temp1(63 downto 0);
				reg_d(127 downto 64) <= temp2;	  
				-- SFW: subtract from word : packed 32-bit halfword unsigned subtract of the contents of rs1 from rs2 (rd = rs2 - rs1).
				when "10001" =>
				for i in 0 to 3 loop
					temp1(((i+1)*32 - 1) downto (i*32)) := std_logic_vector(unsigned(reg_in1(((i+1)*32 - 1) downto (i*32))) - unsigned(reg_in2(((i+1)*32 - 1) downto (i*32))));
				end loop;
				reg_d(127 downto 0) <= temp1;
				-- SFHS: subtract from halfword saturated : packed 16-bit signed subtraction with saturation of the contents of rs1 from rs1 (rd = rs2 - rs1).
				when "10010" =>
				for i in 0 to 3 loop
					int := to_integer((signed(reg_in1(((i+1)*16 - 1) downto (i*16))) - signed(reg_in2(((i+1)*16 - 1) downto (i*16)))));
					if (int > 65535) then --greater than 2^16 -1 which is max value supported
							temp1((16*(i+1) - 1) downto (i*16)) := std_logic_vector(to_signed(+65535,16));	
					elsif	(int < -65537) then
						temp1((16*(i+1) - 1) downto (i*16)) := std_logic_vector(to_signed(-65537, 16));
					else
						temp1(((i+1)*16 - 1) downto (i*16)) := std_logic_vector(signed(reg_in1(((i+1)*16 - 1) downto (i*16))) - signed(reg_in2(((i+1)*16 - 1) downto (i*16))));
					end if;
				end loop;
				for i in 4 to 7 loop
					int := to_integer((signed(reg_in1(((i+1)*16 - 1) downto (i*16))) - signed(reg_in2(((i+1)*16 - 1) downto (i*16)))));
					if (int > 65535) then --greater than 2^16 -1 which is max value supported
							temp2((16*(i+1) - 1) downto (i*16)) := std_logic_vector(to_signed(+65535,16));	
					elsif	(int < -65537) then
						temp2((16*(i+1) - 1) downto (i*16)) := std_logic_vector(to_signed(-65537, 16));
					else
						temp2(((i+1)*16 - 1) downto (i*16)) := std_logic_vector(signed(reg_in1(((i+1)*16 - 1) downto (i*16))) - signed(reg_in2(((i+1)*16 - 1) downto (i*16))));
					end if;
				end loop;
				
				reg_d(63 downto 0) <= temp1(63 downto 0);
				reg_d(127 downto 64) <= temp2;	
				when others =>
					reg_d <= reg_in1 xor reg_in2;
			end case;
		end case;
	
	end process;
end architecture;