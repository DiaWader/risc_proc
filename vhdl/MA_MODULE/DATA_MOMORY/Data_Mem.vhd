		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    00:46:09 11/13/2017 
		-- Design Name: 
		-- Module Name:    Data_Mem - Data_Mem 
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
		use IEEE.NUMERIC_STD.ALL;


		entity Data_Mem is
			 Port (   Address_In: in  STD_LOGIC_VECTOR (28 downto 0);
					  Address_M	: out  STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
					  Data_In_R : in  STD_LOGIC_VECTOR (31 downto 0);
					  Data_Out_R: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
					  COP 		: in  STD_LOGIC_VECTOR (1 downto 0);
					  Busy 		: out STD_LOGIC:= '0';
					  CLK		: in  std_logic;
					  Mem_WR	: out std_logic_vector (1 downto 0):= (others => '0');
					  Data_In_M : in  std_logic_vector (7 downto 0);
					  Data_Out_M: out std_logic_vector (7 downto 0):= (others => '0'));
		end Data_Mem;
		
		
		
		architecture Data_Mem of Data_Mem is
			component Data_Cache is
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
			end component;
		--------------------------------------------------------------------------
		TYPE		machine IS(idle, load_1, load_2, store_1, store_2);			
		signal   Address_C : std_logic_vector (28 downto 0);  
		signal   C_Data_Out, C_Data_In_R  : std_logic_vector (7 downto 0);
		signal   Busy_C, activate, busy_int,COP_C  : std_logic:='0';
		begin
			
			cache :Data_Cache Port map
					( Address_In 	=> Address_C,
					  Activate 		=> Activate,
					  clk 			=> clk,
					  Data_In_R 	=> C_Data_In_R ,
					  Data_Out		=> C_Data_Out,
					  Data_In_M 	=> Data_In_M,
					  Address_Out   => Address_M,
					  Mem_WR 		=> Mem_WR,
					  Busy 			=> Busy_C,
					  COP 			=> COP_C);
			Data_Out_M<=C_Data_Out;
			process (clk, Address_In,Data_In_M,Data_In_R, cop)
			variable MA_Mem_Controller : machine :=idle;
			variable iter : integer:=0;
			variable IF_Busy : std_logic:='0';
			variable data_buffer_in : std_logic_vector (31 downto 0);
			variable data_buffer_out: std_logic_vector (31 downto 0);
			begin
				if(clk'event and clk='1') then
						case MA_Mem_Controller is
							when idle => 
						--------------------------------------
									if (COP="11") then----------- 1
										Busy<='1';
										Address_C<=Address_In;
										iter:=0;
										activate<='1';
										cop_c<='0';	
										data_buffer_in:=Data_In_R;
										C_Data_In_R <= Data_In_R(31 downto 24);
										MA_Mem_Controller:=store_1;
						--------------------------------------
									elsif (cop="10") then-------- 2
										busy<='1';
										Address_C<=Address_In;
										Iter:=0;
										activate<='1';
										cop_c<='1';
										MA_Mem_Controller:=load_1;
						--------------------------------------
									else------------------------- 0
										address_C<=Address_In;
										Busy<='0';
										activate<='0';
									end if;
						-------------------------------------
							when load_1 =>	------------------- 6  
										activate <= '0';  
										MA_Mem_Controller:=load_2;
						-------------------------------------	
							when load_2 =>
							if(busy_c='0') then
										iter:=iter+1;
										Address_C<=std_logic_vector(to_unsigned(to_integer(unsigned(Address_C))+1,29));
										data_buffer_out :=std_logic_vector(shift_left(unsigned (data_buffer_out),8));
										data_buffer_out (7 downto 0):= C_Data_Out;
						-------------------------------------			
									if(iter<4) then------------- 7
										activate <='1';
										MA_Mem_Controller:=load_1;
									----------------------------
									else------------------------ 8
										activate <='0';
										Busy<='0';
										Data_Out_R<=data_buffer_out;
										MA_Mem_Controller:=idle;
									end if;
								end if;
						--------------------------------------
							when store_1 =>-------------------4
									iter:=iter+1;
									activate <= '0';
									Address_C<=std_logic_vector(to_unsigned(to_integer(unsigned(Address_C))+1,29));
									MA_Mem_Controller:=store_2;					
						-------------------------------------
							when store_2 =>------------------
								if(busy_c='0') then
										
									if(iter<4) then----------- 3
										activate <='1';
										MA_Mem_Controller:=store_1;
										data_buffer_in :=std_logic_vector(shift_left(unsigned (data_buffer_in),8));
										C_data_in_r <= data_buffer_in(31 downto 24);
									else---------------------- 5
										activate <='0';
										Busy<='0';
										MA_Mem_Controller:=idle;
									end if;
								end if;
						end case;
				end if;
				
--				if (IF_Busy'event) then
	--				Busy_int<=IF_Busy;
		--		end if;
			end process;
		
		end Data_Mem;

