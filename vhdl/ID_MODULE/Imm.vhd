		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    01:11:08 11/12/2017 
		-- Design Name: 
		-- Module Name:    Imm_ks - Imm_ks 
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


		entity Imm_ks is
			 Port ( Imm_part : in  STD_LOGIC_VECTOR (20 downto 0);
					  COP : in  STD_LOGIC;
					  CLK : in std_logic;
					  Imm_Op : out  STD_LOGIC_VECTOR (31 downto 0));
		end Imm_ks;

		architecture Imm_ks of Imm_ks is

		begin
		Imm_Op(20 downto 0) <= Imm_part 							when clk'event and clk='1';
		Imm_Op(31 downto 21)<=	(others=>'0') 	when COP='0' and clk'event and clk='1' else
										(others=>Imm_part(20)) 		when clk'event and clk='1';

		end Imm_ks;

