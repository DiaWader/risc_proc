		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    00:18:31 11/12/2017 
		-- Design Name: 
		-- Module Name:    Op_A_Register - Op_A_Register 
		-- Project Name: 
		-- Target Devices: 
		-- Tool versions: 
		-- Description: 
		--
		-- Dependencies: 
		--
		-- Revision: 
		-- Revision 0.01 - File Created
		-- Additional Comments: 
		--
		----------------------------------------------------------------------------------
		library IEEE;
		use IEEE.STD_LOGIC_1164.ALL;


		entity Op_A_Register is
			 Port ( Reg_A : in  STD_LOGIC_VECTOR (31 downto 0);		  --"00"  Op_A  Reg_A 		
					  NPC   : in  STD_LOGIC_VECTOR (28 downto 0);        --"01"  Op_A  NPC			
					  COP   : in  STD_LOGIC_VECTOR (1 downto 0);         --"10"  Op_A  X"FFFFFFFF"
					  CLK   : in  STD_LOGIC;                             --"11"  Op_A  X"00000000"
					  Op_A  : out  STD_LOGIC_VECTOR (31 downto 0):=(others=>'0'));
		end Op_A_Register;

		architecture Op_A_Register of Op_A_Register is
		
		begin
		process(clk)begin
			if (clk'event and clk='0') then
				case COP is
							when "00" =>Op_A<= Reg_A 		 ;
							when "01" =>Op_A<= "000"&NPC	 ;
							when "10" =>Op_A<= X"FFFFFFFF" ;
							when "11" =>Op_A<= X"00000000" ;
							when others => null;
				end case;	
			end if;
		end process;
		end Op_A_Register;

