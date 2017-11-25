		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    01:41:36 11/22/2017 
		-- Design Name: 
		-- Module Name:    RISC_PIPELINE - RISC_PIPELINE 
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

		entity RISC_PIPELINE is
		end RISC_PIPELINE;

		architecture RISC_PIPELINE of RISC_PIPELINE is
		----------------------------------------------------------------------------------
		
		-- 										IF SIGNALS
		SIGNAL	I_Adr_M 	: STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
		SIGNAL	I_B 		: STD_LOGIC;
		SIGNAL	I_Mem_WR : STD_LOGIC_VECTOR (1 downto 0):= (others => '0');
		SIGNAL	NPC_IF 	: STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
		SIGNAL	Ins_IF 	: STD_LOGIC_VECTOR (39 downto 0):= (others => '1');
		--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
			component IF_Module is
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
			end component;
			
		----------------------------------------------------------------------------------
		
		-- 										ID SIGNALS
			SIGNAL	Op_A_ID 	: STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			SIGNAL	Op_B_ID 	: STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
			SIGNAL	COP_ID 	: STD_LOGIC_VECTOR (6  downto 0):= (others => '0');
			SIGNAL	WR_ID 	: STD_LOGIC:='0';
			SIGNAL	Ad_ID 	: STD_LOGIC_VECTOR (5  downto 0):= (others => '0');
			SIGNAL	NPC_ID 	: STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
		--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
			component ID_Module is
					Port( NPC_IF 	: in  STD_LOGIC_VECTOR (28 downto 0);
						  Ins_IF 	: in  STD_LOGIC_VECTOR (39 downto 0);
						  CLK_ID 	: in  STD_LOGIC;
						  AD_MA 		: in  STD_LOGIC_VECTOR (5  downto 0);
						  Data_MA	: in  STD_LOGIC_VECTOR (31 downto 0);
						  WR_MA 		: in  STD_LOGIC;
						  Op_A_ID 	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
						  Op_B_ID 	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
						  COP_ID 	: out STD_LOGIC_VECTOR (6  downto 0):= (others => '0');
						  WR_ID 		: out STD_LOGIC:='0';
						  Ad_ID 	: out STD_LOGIC_VECTOR (5  downto 0):= (others => '0');
						  NPC_ID 	: out STD_LOGIC_VECTOR (28 downto 0):= (others => '0'));
			end component;
			
		----------------------------------------------------------------------------------
		
		-- 										EX SIGNALS
			SIGNAL	Jump_EX 	: STD_LOGIC:='0';
			SIGNAL	RES_EX 	: STD_LOGIC_VECTOR (31 downto 0):=(others=> '0');
			SIGNAL	COP_EX 	: STD_LOGIC_VECTOR (1  downto 0):=(others=> '0');
			SIGNAL	Op_B_EX 	: STD_LOGIC_VECTOR (31 downto 0):=(others=> '0');
			SIGNAL	WR_EX 	: STD_LOGIC:='0';
			SIGNAL	AD_EX 	: STD_LOGIC_VECTOR (5 downto 0):=(others=> '0');		
		--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
			component EX_Module is
				 Port ( Op_A_ID 	: in  STD_LOGIC_VECTOR (31 downto 0);
						  Op_B_ID 	: in  STD_LOGIC_VECTOR (31 downto 0);
						  CLK_EX 	: in  STD_LOGIC;
						  COP_ID 	: in  STD_LOGIC_VECTOR (6 downto 0);
						  WR_ID 		: in  STD_LOGIC;
						  AD_ID 		: in  STD_LOGIC_VECTOR (5 downto 0);
						  Jump_EX 	: out STD_LOGIC:='0';
						  RES_EX 	: out STD_LOGIC_VECTOR (31 downto 0):=(others=> '0');
						  COP_EX 	: out STD_LOGIC_VECTOR (1  downto 0):=(others=> '0');
						  Op_B_EX 	: out STD_LOGIC_VECTOR (31 downto 0):=(others=> '0');
						  WR_EX 		: out STD_LOGIC:='0';
						  AD_EX 		: out STD_LOGIC_VECTOR (5 downto 0):=(others=> '0'));
			end component;
			
		----------------------------------------------------------------------------------
		
		-- 										MA SIGNALS
		SIGNAL Data_MA 	: std_logic_vector (31 downto 0):= (others => '0');
		SIGNAL WR_MA 		: STD_LOGIC :='0';
		SIGNAL AD_MA 		: STD_LOGIC_VECTOR (5  downto 0):= (others => '0');
		SIGNAL D_Adr_M 	: STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
		SIGNAL D_M_In  	: STD_LOGIC_VECTOR (7  downto 0):= (others => '0');
		SIGNAL D_Mem_WR 	: STD_LOGIC_VECTOR (1  downto 0):= (others => '0');
		SIGNAL D_B 			: STD_LOGIC :='0';
		SIGNAL HALT 		: STD_LOGIC :='0';
		--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
			component MA_Module is
			 Port ( Res_EX 	: in  STD_LOGIC_VECTOR (31 downto 0);
					  Op_B_EX 	: in  STD_LOGIC_VECTOR (31 downto 0);
					  COP_EX 	: in  STD_LOGIC_VECTOR (1  downto 0);
					  WR_EX		: in  STD_LOGIC;
					  AD_EX		: in  STD_LOGIC_VECTOR (5 downto 0);
					  CLK_Dat_M : in  STD_LOGIC;
					  CLK_MA 	: in  STD_LOGIC;
					  D_Load_M 	: in  STD_LOGIC_VECTOR (7  downto 0);
					  Data_MA 	: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
					  WR_MA 		: out STD_LOGIC :='0';
					  AD_MA 		: out STD_LOGIC_VECTOR (5  downto 0):= (others => '0');
					  D_Adr_M 	: out STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
					  D_Store_M : out STD_LOGIC_VECTOR (7  downto 0):= (others => '0');
					  D_Mem_WR 	: out STD_LOGIC_VECTOR (1  downto 0):= (others => '0');
					  D_B 		: out STD_LOGIC :='0';
					  HALT		: OUT STD_LOGIC);
			end component;
			
		----------------------------------------------------------------------------------
		
		-- 											MEMORY SIGNALS
		SIGNAL M_Data_Out: STD_LOGIC_VECTOR (7  downto 0):= (others => '0');
		--  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --  --
			COMPONENT Memory is
				 Port ( Address : in  STD_LOGIC_VECTOR (28 downto 0);
						  Data_In : in  STD_LOGIC_VECTOR (7  downto 0);
						  Data_Out: out STD_LOGIC_VECTOR (7  downto 0):= (others => '0');
						  R_W 	 : in  STD_LOGIC_vector (1  downto 0));
			end COMPONENT;	
			
		----------------------------------------------------------------------------------
		
		-- 										CONTROL UNIT SIGNALS
		SIGNAL CLK_IF  	: STD_LOGIC:='0';
		SIGNAL CLK_ID  	: STD_LOGIC:='0';
		SIGNAL CLK_EX  	: STD_LOGIC:='0';
		SIGNAL CLK_MA 		: STD_LOGIC:='0';
		SIGNAL CLK_Ins_M	: STD_LOGIC:='0';
		SIGNAL CLK_Dat_M	: STD_LOGIC:='0';
		SIGNAL clk			: std_logic:='0';

		component CLK_GENERATOR is
			 generic(PERIOD	: TIME := 100 PS);	
			 Port ( EX_JUMP 	: in  STD_LOGIC;
			 		  R_C 	  	: in  STD_LOGIC;
			 		  I_C			: in  STD_LOGIC;
					  D_C 		: in  STD_LOGIC;
					  CLK_IF  	: out STD_LOGIC:='0';
					  CLK_ID  	: out STD_LOGIC:='0';
					  CLK_EX  	: out STD_LOGIC:='0';
					  CLK_MA 	: out STD_LOGIC:='0';
					  CLK_Ins_M	: out STD_LOGIC:='0';
					  CLK_Dat_M	: out STD_LOGIC:='0';
					  clk			: out std_logic:='0';
					  HALT		: in  STD_LOGIC);
		end component;
		
		-----------------------------------------------------------------
		
		SIGNAL R_C : STD_LOGIC:='1';					--Conv_Activate
		SIGNAL I_C : STD_LOGIC:='1';					--Ins_mem_Activate
		SIGNAL D_C : STD_LOGIC:='1';					--Dat_mem_Activate
		SIGNAL Bus_Control :  STD_LOGIC_VECTOR (1 downto 0):="00";
		
		COMPONENT Control_Block
			Port (  clk : in  std_logic;
					  D_B : in  STD_LOGIC;							--Busy_D  
					  I_B : in  STD_LOGIC;							--Busy_I  
					  D_M : in  STD_LOGIC;							--D_Mem_WR(1) 
					  I_M : in  STD_LOGIC;							--I_Mem_WR(1) 
					  R_C : out STD_LOGIC:='1';					--Conv_Activate
					  I_C : out STD_LOGIC:='1';					--Ins_mem_Activate
					  D_C : out STD_LOGIC:='1';					--Dat_mem_Activate
					  Bus_Control : out  STD_LOGIC_VECTOR (1 downto 0):="00");
		END COMPONENT;
		
		-----------------------------------------------------------------
		
		SIGNAL M_Adr 		: STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
		SIGNAL M_WR  		: STD_LOGIC_VECTOR (1  downto 0):= (others => '0');
		SIGNAL M_Dat_In  	: STD_LOGIC_VECTOR (7  downto 0):= (others => '0');
		
		COMPONENT Memory_Bus_Controller is
			 Port ( I_Adr_M 	: in  STD_LOGIC_VECTOR (28 downto 0);
					  I_Mem_WR 	: in  STD_LOGIC_VECTOR (1  downto 0);
					  D_M_In 	: in  STD_LOGIC_VECTOR (7  downto 0);
					  D_Adr_M 	: in  STD_LOGIC_VECTOR (28 downto 0);
					  D_Mem_WR 	: in  STD_LOGIC_VECTOR (1  downto 0);
					  CONTROL 	: in  STD_LOGIC_VECTOR (1  downto 0); -- "10"=Ins_Mem,  "11"=Dat_Mem
					  M_Adr 		: out STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
					  M_WR 		: out STD_LOGIC_VECTOR (1  downto 0):= (others => '0');
					  M_In 		: out STD_LOGIC_VECTOR (7  downto 0):= (others => '0'));
		end COMPONENT;
		
		-----------------------------------------------------------------

		begin
		----------------------------------------IF----------------------------------------
			
			IF_S: IF_Module  Port map
						( Jump_EX 	=> Jump_EX,
						  Jump_Adr 	=> Res_EX(28 downto 0),
						  CLK_Ins_M => CLK_Ins_M,
						  CLK_IF		=> CLK_IF,	
						  I_Data_In => M_Data_Out,
						  I_Adr_M 	=> I_Adr_M,	
						  I_B 		=> I_B,
						  I_Mem_WR 	=> I_Mem_WR,	
						  NPC_IF 	=> NPC_IF,
						  Ins_IF 	=> Ins_IF);		
		
		----------------------------------------ID----------------------------------------
		
			ID_S: ID_Module Port map
						( NPC_IF 	=> NPC_IF,
						  Ins_IF 	=> Ins_IF,
						  CLK_ID 	=> CLK_ID,
						  AD_MA 		=> AD_MA ,		
						  Data_MA	=> Data_MA,	
						  WR_MA 		=> WR_MA ,		
						  Op_A_ID 	=> Op_A_ID,
						  Op_B_ID 	=> Op_B_ID,
						  COP_ID 	=> COP_ID,
						  WR_ID 		=> WR_ID,
						  Ad_ID 		=> Ad_ID,
						  NPC_ID 	=> NPC_ID);
		
		----------------------------------------EX----------------------------------------
				 
			EX_S: EX_Module Port map
						( Op_A_ID 	=>	Op_A_ID,
						  Op_B_ID 	=>	Op_B_ID,
						  CLK_EX  	=>	CLK_EX,
						  COP_ID  	=>	COP_ID,
						  WR_ID 	 	=>	WR_ID,
						  AD_ID 	 	=>	AD_ID,
						  Jump_EX 	=>	Jump_EX,
						  RES_EX  	=>	RES_EX,
						  COP_EX  	=>	COP_EX,
						  Op_B_EX 	=>	Op_B_EX,
						  WR_EX 	 	=>	WR_EX,
						  AD_EX 	 	=>	AD_EX);
			
		----------------------------------------MA----------------------------------------
			
			MA_S:  MA_Module Port map
						( Res_EX 	=> Res_EX,
						  Op_B_EX 	=> Op_B_EX,
						  COP_EX 	=> COP_EX,
						  WR_EX		=> WR_EX,
						  AD_EX		=> AD_EX,
						  CLK_Dat_M => CLK_Dat_M,
						  CLK_MA 	=> CLK_MA,
						  D_Load_M 	=> M_Data_Out,	
						  Data_MA 	=> Data_MA,
						  WR_MA 		=> WR_MA,	
						  AD_MA 		=> AD_MA,	
						  D_Adr_M 	=> D_Adr_M,
						  D_Store_M => D_M_In,
						  D_Mem_WR 	=> D_Mem_WR,	
						  D_B 		=> D_B,
						  HALT		=> HALT);
						  
		----------------------------------------------------------------------------------
		
		------------------------------------MEMORY----------------------------------------
			memory_module:  Memory Port map
					  (  Address  => M_Adr,
						  Data_In  => M_Dat_In,
						  Data_Out => M_Data_Out,
						  R_W 	  => M_WR);	
		
		-----------------------------------CONTROLS---------------------------------------
			controls: Control_Block PORT MAP (
				   clk => clk,
				   D_B => D_B,
			      I_B => I_B,
			      D_M => D_Mem_WR(1),
			      I_M => I_Mem_WR(1),
			      R_C => R_C,
			      I_C => I_C,
			      D_C => D_C,
			      Bus_Control => Bus_Control );
			
			bus_controller: Memory_Bus_Controller Port map
				  (  I_Adr_M 	=> I_Adr_M,
					  I_Mem_WR 	=> I_Mem_WR,	
					  D_M_In 	=> D_M_In,
					  D_Adr_M 	=> D_Adr_M,
					  D_Mem_WR 	=> D_Mem_WR,	
					  CONTROL 	=> Bus_Control, -- "10"=Ins_Mem,  "11"=Dat_Mem
					  M_Adr 		=> M_Adr,
					  M_WR 		=> M_WR,	
					  M_In 		=> M_Dat_In);  
			
			
			clk_gen: CLK_GENERATOR Port map  
					  (  EX_JUMP 	=> JUMP_EX,	
				 		  R_C 	  	=> R_C,
				 		  I_C			=> I_C,
						  D_C 		=> D_C,
						  CLK_IF  	=> CLK_IF,
						  CLK_ID  	=> CLK_ID,
						  CLK_EX  	=> CLK_EX,
						  CLK_MA 	=> CLK_MA,
						  CLK_Ins_M	=> CLK_Ins_M,
						  CLK_Dat_M	=> CLK_Dat_M,
						  clk       => clk,
						  HALT		=> HALT);	
		
		end RISC_PIPELINE;

