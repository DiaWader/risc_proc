		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    23:03:05 11/15/2017 
		-- Design Name: 
		-- Module Name:    Ins_Cache_Mem - Behavioral 
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

		entity Ins_Cache_Mem is
			 Port ( Block_Number : in   STD_LOGIC_VECTOR (6 downto 0);
					  Word_Number 	: in   STD_LOGIC_VECTOR (9 downto 0);
					  Read_Write 	: in   STD_LOGIC;		--0 read 1 write
					  Data_In 		: in   STD_LOGIC_VECTOR (7 downto 0);
					  Data_Out 		: out  STD_LOGIC_VECTOR (7 downto 0));
		end Ins_Cache_Mem;

		architecture Behavioral of Ins_Cache_Mem is
		--									  | BlockNumer |  WordNumber  |
		type Regs1024x128x8 is array (127 downto 0, 1023 downto 0) of std_logic_vector (7 downto 0);
		--signal cache_mem: regs1024x128x8;
		begin
		
			process(Block_number, Word_Number, Read_Write, Data_In) 
			variable cache_mem: regs1024x128x8;
			begin
				case read_write is
						when '0' => Data_Out<=cache_mem((to_integer(unsigned(Block_Number))),(to_integer(unsigned(Word_Number))));
						when '1' => cache_mem((to_integer(unsigned(Block_Number))),(to_integer(unsigned(Word_Number)))):=Data_In;
						when others => null;
				end case;
			end process;

		end Behavioral;

