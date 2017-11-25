			----------------------------------------------------------------------------------
			-- Company: 
			-- Engineer: 
			-- 
			-- Create Date:    20:00:41 11/21/2017 
			-- Design Name: 
			-- Module Name:    ID_Module - ID_Module 
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

			entity ID_Module is
				 Port ( NPC_IF 	: in  STD_LOGIC_VECTOR (28 downto 0);
						  Ins_IF 	: in  STD_LOGIC_VECTOR (39 downto 0);
						  CLK_ID 	: in  STD_LOGIC;
						  AD_MA 		: in  STD_LOGIC_VECTOR (5  downto 0);
						  Data_MA	: in  STD_LOGIC_VECTOR (31 downto 0);
						  WR_MA 		: in  STD_LOGIC;
						  Op_A_ID 	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
						  Op_B_ID 	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
						  COP_ID 	: out STD_LOGIC_VECTOR (6  downto 0):= (others => '0');
						  WR_ID 		: out STD_LOGIC:='0';
						  Ad_ID 		: out STD_LOGIC_VECTOR (5  downto 0):= (others => '0');
						  NPC_ID 	: out STD_LOGIC_VECTOR (28 downto 0):= (others => '0'));
			end ID_Module;

			architecture ID_Module of ID_Module is		
			----------------------------------------------------------------------------------
				component Imm_ks is
					 Port ( Imm_part 	: in  STD_LOGIC_VECTOR (20 downto 0);
							  COP 		: in  STD_LOGIC;
							  CLK 		: in  std_logic;
							  Imm_Op 	: out STD_LOGIC_VECTOR (31 downto 0));
				end component;
			----------------------------------------------------------------------------------	
				component Op_A_Register is
				 Port ( Reg_A : in  STD_LOGIC_VECTOR (31 downto 0);		  --"00"  Op_A  Reg_A 		
						  NPC   : in  STD_LOGIC_VECTOR (28 downto 0);        --"01"  Op_A  NPC			
						  COP   : in  STD_LOGIC_VECTOR (1 downto 0);         --"10"  Op_A  X"FFFFFFFF"
						  CLK   : in  STD_LOGIC;                             --"11"  Op_A  X"00000000"
						  Op_A  : out  STD_LOGIC_VECTOR (31 downto 0));
				end component;
			----------------------------------------------------------------------------------	
				component Op_B_Register is
					 Port (  Reg_B : in  STD_LOGIC_VECTOR (31 downto 0);
								Imm 	: in  STD_LOGIC_VECTOR (31 downto 0);
								CLK 	: in  STD_LOGIC;										--'0'  Op_B <= Reg_B 
								COP 	: in  STD_LOGIC;										--'1'  Op_B <= Imm   
								Op_B 	: out STD_LOGIC_VECTOR (31 downto 0));
				end component;
			----------------------------------------------------------------------------------	
				component Reg_File is
					 Port ( 	Reg_A_Adr 	: in  STD_LOGIC_VECTOR (5 downto 0);
								Reg_B_Adr  	: in  STD_LOGIC_VECTOR (5 downto 0);
								Wr_Adr 		: in  STD_LOGIC_VECTOR (5 downto 0);
								Wr 			: in  STD_LOGIC;
								CLK			: in  STD_LOGIC;
								Data_In		: in  STD_LOGIC_VECTOR (31 downto 0);
								Reg_A 		: out STD_LOGIC_VECTOR (31 downto 0);
								Reg_B 		: out STD_LOGIC_VECTOR (31 downto 0));
				end component;
			----------------------------------------------------------------------------------	
				component ID_CONTROLLER is
					 Port ( COP_In  : in  	STD_LOGIC_VECTOR (6 downto 0);
							  NPC_In	 : in  	STD_LOGIC_VECTOR (28 downto 0);
							  CLK 	 : in 	STD_LOGIC;
							  Op_A_R  : out  	STD_LOGIC_VECTOR (1 downto 0);
							  Op_B_R  : out  	STD_LOGIC;
							  Imm 	 : out  	STD_LOGIC;
							  WR 		 : out  	STD_LOGIC);
				end component;
			----------------------------------------------------------------------------------
			-- INTERNAL SIGNALS
			SIGNAL Reg_A, Reg_B, Imm_Op : std_logic_vector (31 downto 0):=(others=> '0');
			-- CONTROL SIGNALS
			SIGNAL Imm_COP, WR, Op_B_COP : std_logic :='0';
			signal Op_A_COP : std_logic_vector (1 downto 0):="00";
			
			begin
			----------------------------------------------------------------------------------
				ID_Imm_ks: Imm_ks Port map
							( Imm_part	=> Ins_IF(26 downto 6),
							  COP			=> Imm_COP,
							  CLK			=> CLK_ID,
							  Imm_Op		=> Imm_Op);
			----------------------------------------------------------------------------------	
				ID_Op_A: Op_A_Register  Port map
							( Reg_A 	=> Reg_A,				  		--"00"  Op_A  Reg_A 		
							  NPC   	=> NPC_IF,      		  		--"01"  Op_A  NPC			
							  COP   	=> Op_A_COP,         		--"10"  Op_A  X"FFFFFFFF"
							  CLK   	=> CLK_ID,						--"11"  Op_A  X"00000000"
							  Op_A  	=> Op_A_ID);
			----------------------------------------------------------------------------------				  
				ID_Op_B: Op_B_Register Port map
							( Reg_B 	=> Reg_B,
							  Imm 	=> Imm_Op,
							  CLK 	=> CLK_ID,						--'0'  Op_B <= Reg_B 
							  COP 	=> Op_B_COP,					--'1'  Op_B <= Imm   
							  Op_B 	=> Op_B_ID);
			----------------------------------------------------------------------------------				  
				ID_Reg_File: Reg_File Port map
							(  Reg_A_Adr	=> Ins_IF(32 downto 27),
								Reg_B_Adr	=> Ins_IF(26 downto 21),
								Wr_Adr 	 	=> AD_MA,
								Wr 			=> WR_MA,
								CLK			=> CLK_ID,
								Data_In		=> Data_MA, 
								Reg_A 		=> Reg_A, 
								Reg_B 		=> Reg_B);
			----------------------------------------------------------------------------------					
				ID_CONTROLLER_ks:  ID_CONTROLLER Port map
							( COP_In  => Ins_IF (39 downto 33),
							  NPC_In	 => NPC_IF,
							  CLK 	 => CLK_ID,
							  Op_A_R  => Op_A_COP,
							  Op_B_R  => Op_B_COP, 
							  Imm 	 => Imm_COP, 
							  WR 		 => WR);
			----------------------------------------------------------------------------------	
			process(CLK_ID, Ins_IF, WR) 
			variable Ins_Intr : std_logic_vector (39 downto 0):=(others=>'0');
			begin
				if(CLK_ID'event and CLK_ID='1') then					--
					Ins_Intr:=Ins_IF;											--output_signals
				elsif(CLK_ID'event and CLK_ID='0') then
					WR_ID	<= WR;
					Ad_ID<= Ins_Intr (5 downto 0);
					COP_ID<= Ins_Intr (39 downto 33);
				end if;					
			end process;
			----------------------------------------------------------------------------------
			end ID_Module;

