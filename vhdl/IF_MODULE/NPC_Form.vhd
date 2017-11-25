		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    01:10:57 11/13/2017 
		-- Design Name: 
		-- Module Name:    NPC_Form - NPC_Form 
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
		use IEEE.NUMERIC_STD.all; 	

		entity NPC_Form is
			 Port ( PC : in  STD_LOGIC_VECTOR (28 downto 0);
					  NPC : out  STD_LOGIC_VECTOR (28 downto 0):="00000000000000000000000000000";
					  CLK : in  STD_LOGIC);
		end NPC_Form;

		architecture NPC_Form of NPC_Form is

		begin
		process(CLK)begin
			if(clk'event and clk='0') then
				NPC<=std_logic_vector(to_unsigned(to_integer(unsigned(PC))+5,29));
			end if;
		end process;
		end NPC_Form;

