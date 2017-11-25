		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    22:21:24 11/17/2017 
		-- Design Name: 
		-- Module Name:    Data_Cache - Data_Cache 
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

		entity Data_Cache is
			 Port ( Address_In 	: in  STD_LOGIC_VECTOR (28 downto 0);
					  Activate 		: in  STD_LOGIC;
					  clk 			: in  STD_LOGIC;
					  Data_In_R 	: in  STD_LOGIC_VECTOR (7 downto 0);
					  Data_Out		: out STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
					  Data_In_M 	: in  STD_LOGIC_VECTOR (7 downto 0);
					--  Data_Out	: out STD_LOGIC_VECTOR (7 downto 0);
					  Address_Out   : out STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
					  Mem_WR 		: out STD_LOGIC_vector (1 downto 0):= (others => '0');
					  Busy 			: out STD_LOGIC;
					  COP 			: in  std_logic);
		end Data_Cache;

		architecture Data_Cache of Data_Cache is
		component Dat_cache_machine is
			 Port ( COP 			: in  std_logic;
					  cmp 			: in  STD_LOGIC;
					  V_In 			: out STD_LOGIC:='0';
					  D_In 			: out STD_LOGIC:='0';
					  D_Out 			: in  STD_LOGIC;
					  CLK 			: in  STD_LOGIC;
					  Activate		: in  STD_LOGIC;
					  store_block	: out std_logic:='0';
					  Data_In_C		: out std_logic:='0';
					  Data_Out_C	: out std_logic:='0';
					  COP_TF 		: out STD_LOGIC_VECTOR (1 downto 0):="00";
					  MEM_WR 		: out STD_LOGIC_VECTOR (1 downto 0):="00";
					  R_W 			: out STD_LOGIC:='0';
					  Word_Counter : out STD_LOGIC_vector(12 downto 0);
					  Cache_Word_C : out STD_LOGIC:='0';
					  Busy 			: out STD_LOGIC:='0');
		end component;
		
		component Dat_Cache_Mem is
			 Port ( Block_Number : in  STD_LOGIC_VECTOR (6 downto 0);
					  Word_Number : in  STD_LOGIC_VECTOR (12 downto 0);
					  Read_Write : in  STD_LOGIC;
					  Data_In : in  STD_LOGIC_VECTOR (7 downto 0);
					  Data_Out : out  STD_LOGIC_VECTOR (7 downto 0):= (others => '0'));
		end component;
		
		component Dat_Mem_Tag_Table is
			 Port ( Block_Number : in  STD_LOGIC_VECTOR (6 downto 0);
					  Tag_In 		: in  STD_LOGIC_VECTOR (8 downto 0);
					  Tag_Out 		: out  STD_LOGIC_VECTOR (8 downto 0);
					  V_In 			: in  STD_LOGIC;
					  V_Out 			: out  STD_LOGIC;
					  D_In 			: in  STD_LOGIC;
					  D_Out 			: out  STD_LOGIC;
					  COP 			: in  STD_LOGIC_VECTOR (1 downto 0));
		end component;
		SIGNAL  V_In ,V_Out,D_In ,D_Out, Store_Block, CMP, Data_In_C, Data_Out_C,  R_W,Cache_Word_C : std_logic :='0';
		signal Word_Counter, Word_Number : std_logic_vector (12 downto 0);
		signal data_in : std_logic_vector (7 downto 0);
		signal tag_out : std_logic_vector (8 downto 0);
		signal cop_tf  : std_logic_vector (1 downto 0);
		
		begin  
		----------------------------------------------------------------------			
		--	CMP_KS
		cmp<= '1' when tag_out = Address_In(28 downto 20) and v_out = '1' else
			'0'; 
		----------------------------------------------------------------------
		controlls:  Dat_cache_machine Port map
					( COP 			=> cop,
					  cmp 			=> cmp,
					  V_In 			=> V_In,
					  D_In 			=> D_In 			,
					  D_Out 			=> D_Out 		,	
					  CLK 			=> CLK 			,
					  Activate		=> Activate		,
					  store_block	=> store_block	,
					  Data_In_C		=> Data_In_C	,	
					  Data_Out_C	=> Data_Out_C	,
					  COP_TF 		=> COP_TF 		,
					  MEM_WR 		=> MEM_WR 		,
					  R_W 			=> R_W 			,
					  Word_Counter => Word_Counter,
					  Cache_Word_C => Cache_Word_C,
					  Busy 			=> Busy);
		----------------------------------------------------------------------
		--store_block_MUX			  
		Address_Out<= Address_In(28 downto 20) & Address_In(19 downto 13) & Word_number  when store_block='0' else
						 Tag_Out & Address_In(19 downto 13) & Word_number 				 when store_block='1';
		----------------------------------------------------------------------
		--word_number_MUX
		Word_Number	<=	Address_In(12 downto 0) when cache_word_c='0' else
							word_counter 				when cache_word_c='1';
		----------------------------------------------------------------------
		cache_mem: Dat_Cache_Mem Port map
					( Block_Number => Address_In(19 downto 13),
					  Word_Number  => Word_number,
					  Read_Write   => R_W,		--0 read 1 write
					  Data_In      => Data_In, 
					  Data_Out     => Data_Out);
		----------------------------------------------------------------------
		--Data_In_MUX
		Data_In<=Data_In_R when Data_In_C='0' else
					Data_In_M when Data_In_C='1';
		--Data_Out_MUX
--		Data_Out<=Data_Out_R when Data_Out_C='0' else
--		Data_Out<=
--					 Data_Out_M when Data_Out_C='1';		
		----------------------------------------------------------------------
		tags: Dat_Mem_Tag_Table Port map
					( Block_Number => Address_In(19 downto 13),
					  Tag_In 		=> Address_In(28 downto 20),
					  Tag_Out 		=> Tag_Out,
					  V_In 			=> V_In ,
					  V_Out 			=> V_Out,
					  D_In 			=> D_In ,
					  D_Out 			=> D_Out,
					  COP 			=> COP_TF);
		end Data_Cache;

