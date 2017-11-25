			----------------------------------------------------------------------------------
			-- Company: 
			-- Engineer: 
			-- 
			-- Create Date:    17:46:32 11/16/2017 
			-- Design Name: 
			-- Module Name:    Instruction_Cache - Instruction_Cache 
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

			entity Instruction_Cache is
			 Port ( Address_In: in  STD_LOGIC_VECTOR (28 downto 0);
					  Activate  : in 	std_logic;
					  clk 		: in 	std_logic;
					  Data_In  	: in 	std_logic_vector (7 downto 0);
					  Data_Out 	: out STD_LOGIC_VECTOR (7 downto 0);
					  Address_out: out STD_LOGIC_VECTOR (28 downto 0);
					  Mem_WR		: out std_logic_vector (1 downto 0); --00, 01 - distable; 10 - read, 11-write
					  Busy 		: out STD_LOGIC);
			end Instruction_Cache;

			architecture Instruction_Cache of Instruction_Cache is
			------------------------------------------------------------------
				component Ins_Mem_Tag_Table is
					 Port ( Block_Number : in  STD_LOGIC_VECTOR (6 downto 0);
							  Tag_out	: out  STD_LOGIC_VECTOR (11 downto 0);
							  Tag_in		: in   STD_LOGIC_VECTOR (11 downto 0);
							  V_out		: out  STD_LOGIC;
							  V_in		: in   STD_LOGIC;
							  D_out		: out  STD_LOGIC;
							  D_in		: in   STD_LOGIC;
							  COP 		: in 	 STD_LOGIC_VECTOR (1 downto 0));					-- read tag and V
				end component;
			------------------------------------------------------------------	
				component Ins_Cache_Mem is
				 Port ( Block_Number : in   STD_LOGIC_VECTOR (6 downto 0);
						  Word_Number 	: in   STD_LOGIC_VECTOR (9 downto 0);
						  Read_Write 	: in   STD_LOGIC;		--0 read 1 write
						  Data_In 		: in   STD_LOGIC_VECTOR (7 downto 0);
						  Data_Out 		: out  STD_LOGIC_VECTOR (7 downto 0));
				end component;
			------------------------------------------------------------------
			
				component cache_machine is
				 Port ( cmp 		: in  STD_LOGIC;
						  activate  : in  STD_LOGIC;
						  clk 		: in  STD_LOGIC;
						  cop_TF		: out std_logic_vector (1 downto 0);
						  cache_word_c	: out  STD_LOGIC:='0';
						  V_i				: out  STD_LOGIC:='0';
						  cache_mem_rw	: out  STD_LOGIC:='0';
						  word_counter : out  STD_LOGIC_VECTOR (9 downto 0):=(others=>'0');
						  busy 			: out std_logic:='0';
						  mem_WR		: out std_logic_vector:="00");
				end component;

			------------------------------------------------------------------
			SIGNAL Block_Number					: std_logic_vector (6 downto 0):=(others=>'0');
			SIGNAL Tag_Out,  Tag_in 			: STD_LOGIC_VECTOR (11 DOWNTO 0);
			SIGNAL V_out, V_in, D_out, D_in, Cache_RW, cmp,cache_mem_RW, cache_word_c	: std_logic :='0';
			signal Word_number, Word_Counter	: std_logic_vector (9 downto 0):=(others=>'0');
			signal Tag_Table_COP 				: std_logic_vector (1 downto 0);
			signal cache_in, cache_out 		: std_logic_vector (7 downto 0);
			begin
			------------------------------------------------------------------
				tags: Ins_Mem_Tag_Table Port map
						( Block_Number =>Address_In(16 downto 10),
						  Tag_out		=>Tag_out		,
						  Tag_in		=>Address_In(28 downto 17),
						  V_out			=>V_out			,
						  V_in			=>V_in			,
						  D_out			=>D_out			,
						  D_in			=>D_in			,
						  COP 			=>Tag_Table_COP);

				cmp<= '1' when tag_out = Address_In(28 downto 17) and v_out = '1' else
						'0';
				
			------------------------------------------------------------------
				cache_mem: Ins_Cache_Mem Port map
						( Block_Number => Address_In(16 downto 10),
						  Word_Number 	=> Word_number,
						  Read_Write 	=> cache_mem_RW,		--0 read 1 write
						  Data_In 		=> Data_In , 
						  Data_Out 		=> Data_Out );
		--		mem_wr<=cache_mem_RW;
			------------------------------------------------------------------
				Word_number<= Address_In(9 downto 0) when Cache_Word_C = '0' else
								  Word_Counter when Cache_Word_C = '1';
			------------------------------------------------------------------
				controlls:  cache_machine  Port map 
							( cmp 			=> cmp,
							  activate 		=> activate,
							  cop_TF  		=> Tag_Table_COP,
							  cache_word_c	=> cache_word_c,
							  cache_mem_RW => cache_mem_RW,
							  mem_wr			=>	mem_wr,
							  word_counter => Word_Counter,
							  busy			=> Busy,
							  V_i				=> V_in,
							  clk				=> clk);
			------------------------------------------------------------------
				Address_out<=Address_In(28 downto 10)&Word_number;
			
			end Instruction_Cache;