			----------------------------------------------------------------------------------
			-- Company: 
			-- Engineer: 
			-- 
			-- Create Date:    21:21:49 11/15/2017 
			-- Design Name: 
			-- Module Name:    Ins_Mem_Tag_Table - Ins_Mem_Tag_Table 
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

			entity Ins_Mem_Tag_Table is
				 Port ( Block_Number : in  STD_LOGIC_VECTOR (6 downto 0);
						  Tag_out	: out  STD_LOGIC_VECTOR (11 downto 0);
						  Tag_in		: in   STD_LOGIC_VECTOR (11 downto 0);
						  V_out		: out  STD_LOGIC;
						  V_in		: in   STD_LOGIC;
						  D_out		: out  STD_LOGIC;
						  D_in		: in   STD_LOGIC;
						  COP 		: in 	 STD_LOGIC_VECTOR (1 downto 0));					-- read tag and V
			end Ins_Mem_Tag_Table;

			architecture Ins_Mem_Tag_Table of Ins_Mem_Tag_Table is
			type Regs128x14 is array (127 downto 0) of std_logic_vector (13 downto 0);
			--signal Tag_Table : Regs128x14;--tag|V|D
			begin			
				process(block_number, COP) 
				variable Tag_Table : Regs128x14;--tag|V|D
				begin
					if(cop="00") then
						Tag_out <= Tag_Table (to_integer(unsigned(Block_Number)))(13 downto 2);
						V_out   <= Tag_Table (to_integer(unsigned(Block_Number)))(1);
						D_out   <= Tag_Table (to_integer(unsigned(Block_Number)))(0);
					elsif(cop="11") then
						Tag_Table (to_integer(unsigned(Block_Number)))(13 downto 2):=	Tag_in;
						Tag_Table (to_integer(unsigned(Block_Number)))(1)          :=  V_in  ;
						Tag_Table (to_integer(unsigned(Block_Number)))(0)          :=  D_in  ;
					end if;
				end process;
			end Ins_Mem_Tag_Table;

