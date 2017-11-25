		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    14:15:10 11/17/2017 
		-- Design Name: 
		-- Module Name:    Dat_Cache_Mem - Dat_Cache_Mem 
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
		use IEEE.NUMERIC_STD.ALL;

		-- Uncomment the following library declaration if instantiating
		-- any Xilinx primitives in this code.
		--library UNISIM;
		--use UNISIM.VComponents.all;

		entity Dat_Cache_Mem is
			 Port ( Block_Number : in  STD_LOGIC_VECTOR (6 downto 0);
					  Word_Number : in  STD_LOGIC_VECTOR (12 downto 0);
					  Read_Write : in  STD_LOGIC;
					  Data_In : in  STD_LOGIC_VECTOR (7 downto 0);
					  Data_Out : out  STD_LOGIC_VECTOR (7 downto 0):= (others => '0'));
		end Dat_Cache_Mem;

		architecture Dat_Cache_Mem of Dat_Cache_Mem is
		type Regs1024x128x8 is array (127 downto 0, 2**13-1 downto 0) of std_logic_vector (7 downto 0);
		--signal cache_mem: regs1024x128x8;
		begin
		
			process(Block_number, Word_Number, Read_Write, Data_In) 
			variable cache_mem: regs1024x128x8;
			begin
				case read_write is
						when '0' => Data_Out<=cache_mem((to_integer(unsigned(Block_Number))),(to_integer(unsigned(Word_Number))));
						when '1' => cache_mem((to_integer(unsigned(Block_Number))),(to_integer(unsigned(Word_Number)))):=Data_In;
						when others => Data_Out<=X"00";
				end case;
			end process;
		end Dat_Cache_Mem;

