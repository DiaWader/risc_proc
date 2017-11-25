		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    15:25:26 11/19/2017 
		-- Design Name: 
		-- Module Name:    Memory_Bus_Controller - Memory_Bus_Controller 
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

		-- Uncomment the following library declaration if using
		-- arithmetic functions with Signed or Unsigned values
		--use IEEE.NUMERIC_STD.ALL;

		-- Uncomment the following library declaration if instantiating
		-- any Xilinx primitives in this code.
		--library UNISIM;
		--use UNISIM.VComponents.all;

		entity Memory_Bus_Controller is
			 Port ( I_Adr_M 	: in  STD_LOGIC_VECTOR (28 downto 0);
					  I_Mem_WR 	: in  STD_LOGIC_VECTOR (1  downto 0);
					  D_M_In 	: in  STD_LOGIC_VECTOR (7  downto 0);
					  D_Adr_M 	: in  STD_LOGIC_VECTOR (28 downto 0);
					  D_Mem_WR 	: in  STD_LOGIC_VECTOR (1  downto 0);
					  CONTROL 	: in  STD_LOGIC_VECTOR (1  downto 0); -- "10"=Ins_Mem,  "11"=Dat_Mem
					  M_Adr 		: out STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
					  M_WR 		: out STD_LOGIC_VECTOR (1  downto 0):= (others => '0');
					  M_In 		: out STD_LOGIC_VECTOR (7  downto 0):= (others => '0'));
		end Memory_Bus_Controller;

		architecture Memory_Bus_Controller of Memory_Bus_Controller is		 
		begin
			process(CONTROL, I_Adr_M, I_Mem_WR, D_M_In, D_Adr_M, D_Mem_WR)begin
				case CONTROL is 
					when "10" =>	--- bus under Ins_Mem control
						M_Adr<=I_Adr_M;
						M_WR <=I_Mem_WR;
						M_In <=(others=>'0');
					when "11" =>	--- bus under Dat_Mem control
						M_Adr<=D_Adr_M;
						M_WR <=D_Mem_WR;
						M_In <=D_M_In; 
					when others =>
						M_Adr<=(others=>'0');
						M_WR <=(others=>'0');
						M_In <=(others=>'0');
				end case;
			end process;   
		end Memory_Bus_Controller;

