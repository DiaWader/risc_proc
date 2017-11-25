		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    14:15:14 11/12/2017 
		-- Design Name: 
		-- Module Name:    Reg_File_Register - Reg_File_Register 
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

		entity Reg_File_Register is
			 Port ( Data_In : in  STD_LOGIC_VECTOR (31 downto 0);
					  Data_Out : out  STD_LOGIC_VECTOR (31 downto 0);
					  WE : in  STD_LOGIC);
		end Reg_File_Register;

		architecture Reg_File_Register of Reg_File_Register is
		signal reg : std_logic_vector (31 downto 0):=(others=>'0');
		begin
			Data_Out	<= reg;
			reg		<= Data_In when WE='1';
		end Reg_File_Register;

