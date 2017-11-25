			----------------------------------------------------------------------------------
			-- Company: 
			-- Engineer: 
			-- 
			-- Create Date:    19:07:11 11/21/2017 
			-- Design Name: 
			-- Module Name:    IF_Module - IF_Module 
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

			entity IF_Module is
				 Port ( Jump_EX 	: in  STD_LOGIC;
						  Jump_Adr 	: in  STD_LOGIC_VECTOR (28 downto 0);
						  CLK_Ins_M : in  STD_LOGIC;
						  CLK_IF		: in  STD_LOGIC;
						  I_Data_In : in  STD_LOGIC_VECTOR (7 downto 0);
						  I_Adr_M 	: out STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
						  I_B 		: out STD_LOGIC;
						  I_Mem_WR 	: out STD_LOGIC_VECTOR (1 downto 0):= (others => '0');
						  NPC_IF 	: out STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
						  Ins_IF 	: out STD_LOGIC_VECTOR (39 downto 0):= (others => '1'));
			end IF_Module;

			architecture IF_Module of IF_Module is
				----------------------------------------------------------------------------
				component Instruction_Mem is
					 Port ( Address_In : in  STD_LOGIC_VECTOR (28 downto 0);
							  Data_In  	 : in  std_logic_vector (7  downto 0);
							  clk 		 : in  std_logic;
							  Data_Out 	 : out STD_LOGIC_VECTOR (39 downto 0);
							  Address_out: out STD_LOGIC_VECTOR (28 downto 0);
							  Busy 		 : out STD_LOGIC:='0';
							  Mem_WR	    : out std_logic_vector (1 downto 0); --00, 01 - distable; 10 - read, 11-write
							  COP 		 : in  std_logic_vector (1 downto 0));
				end component;
				----------------------------------------------------------------------------
				component NPC_Form is
					 Port ( PC 	: in  STD_LOGIC_VECTOR (28 downto 0);
							  NPC : out STD_LOGIC_VECTOR (28 downto 0):="00000000000000000000000000000";
							  CLK : in  STD_LOGIC);
				end component;
				----------------------------------------------------------------------------
				SIGNAL PC, NPC  : std_logic_vector (28 downto 0) :='0'& X"0000000";
				
			begin
			
				--IF_PC_MUX
				PC<= Jump_Adr when Jump_EX='1' and jump_EX'event else
					  NPC;
				----------------------------------------------------------------------------
				IF_Ins_Mem : Instruction_Mem Port map
								( Address_In => PC,
								  Data_In  	 => I_Data_In,
								  clk 		 => CLK_Ins_M,
								  Data_Out 	 => Ins_IF,
								  Address_out=> I_Adr_M,
								  Busy 		 => I_B,
								  Mem_WR	 	 => I_Mem_WR, 
								  COP 		 => "00");
				----------------------------------------------------------------------------
				IF_NPC_Form:  NPC_Form Port map
								( PC 		=> PC,
								  NPC		=> NPC,
								  CLK 	=> CLK_IF);
				-- дублювання сигналу
				NPC_IF<=NPC;
				----------------------------------------------------------------------------
			end IF_Module;

