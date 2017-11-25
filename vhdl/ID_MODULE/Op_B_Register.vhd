		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    00:31:06 11/12/2017 
		-- Design Name: 
		-- Module Name:    Op_B_Register - Op_B_Register 
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


		entity Op_B_Register is
			 Port ( Reg_B : in  STD_LOGIC_VECTOR (31 downto 0);
					  Imm : in  STD_LOGIC_VECTOR (31 downto 0);
					  CLK : in  STD_LOGIC;									--'0'  Op_B <= Reg_B 
					  COP : in  STD_LOGIC;									--'1'  Op_B <= Imm   
					  Op_B : out  STD_LOGIC_VECTOR (31 downto 0):=(others=>'0'));
		end Op_B_Register;

		architecture Op_B_Register of Op_B_Register is

		begin
		process(clk)begin
			if (clk'event and clk='0') then
				case COP is
							when '0' =>Op_B<= Reg_B ;
							when '1' =>Op_B<= Imm   ;
							when others => null;
				end case;	
			end if;
		end process;

		end Op_B_Register;

