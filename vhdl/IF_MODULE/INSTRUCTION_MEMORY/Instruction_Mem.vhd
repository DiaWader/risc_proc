		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    00:49:09 11/13/2017 
		-- Design Name: 	
		-- Module Name:    Instruction_Mem - Instruction_Mem 
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


		entity Instruction_Mem is
			 Port ( Address_In : in  STD_LOGIC_VECTOR (28 downto 0);
					  Data_In  	 : in 	std_logic_vector (7 downto 0);
					  clk 		 : in 	std_logic;
					  Data_Out 	 : out STD_LOGIC_VECTOR (39 downto 0):= (others => '1');
					  Address_out: out STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
					  Busy 		 : out STD_LOGIC:='0';
					  Mem_WR	    : out std_logic_vector (1 downto 0):= (others => '0'); --00, 01 - distable; 10 - read, 11-write
					  COP 		 : in  std_logic_vector (1 downto 0):= (others => '0'));
		end Instruction_Mem;

		architecture Instruction_Mem of Instruction_Mem is
		--------------------------------------------------------------------------
		component Instruction_Cache is
			 Port ( Address_In: in  STD_LOGIC_VECTOR (28 downto 0);
					  Activate  : in 	std_logic;
					  clk 		: in 	std_logic;
					  Data_In  	: in 	std_logic_vector (7 downto 0);
					  Data_Out 	: out STD_LOGIC_VECTOR (7 downto 0);
					  Address_out: out STD_LOGIC_VECTOR (28 downto 0);
					  Mem_WR		: out std_logic_vector (1 downto 0); --00, 01 - distable; 10 - read, 11-write
					  Busy 		: out STD_LOGIC);
		end component;
		--------------------------------------------------------------------------
		TYPE		machine IS(idle, loop_1, loop_2);			
		signal   Address_C : std_logic_vector (28 downto 0);  
		signal   cache_Data_Out : std_logic_vector (7 downto 0);
		signal   Busy_C, activate, busy_int : std_logic:='0';
		begin
			
			cache :Instruction_Cache Port map
					( Address_In=> Address_C,
					  Activate  => Activate,
					  clk 		=> clk,
					  Data_In  	=> Data_In,
					  Data_Out 	=> cache_Data_Out ,
					  Mem_WR		=> Mem_WR,
					  Busy 		=> Busy_C,
					  Address_Out=> Address_Out);
			
			--process (cache_Data_Out)
			
			process (clk, Address_In, data_in, cop)
			variable IF_Mem_Controller : machine :=idle;
			variable iter : integer:=0;
			variable IF_Busy : std_logic:='0';
			variable data_buffer : std_logic_vector (39 downto 0);
			begin
				if(clk'event and clk='1') then
						case IF_Mem_Controller is
							when idle => 
								if (COP="00") then			-- 1
									Busy<='1';
									Address_C<=Address_In;
									iter:=0;
									activate<='1';
									IF_Mem_Controller:=loop_1;
								else 								-- 0
									address_C<=Address_In;
								--	push<=0;
									Busy<='0';
									end if;
							when loop_1 =>						-- 2
									activate <= '0';
--									push<='1'; 
									IF_Mem_Controller:=loop_2;
							when loop_2 =>
							if(busy_c='0') then
								data_buffer :=std_logic_vector(shift_left(unsigned (data_buffer),8));
								data_buffer (7 downto 0):= cache_Data_Out;
								address_c<=std_logic_vector(to_unsigned(to_integer(unsigned(address_c))+1,29));
								iter:=iter+1;
								if(iter<5) then			-- 3
						--			push<='0';
									activate <='1';
									IF_Mem_Controller:=loop_1;
								else	 					-- 4
									activate <='0';
						--			push <='0';
									Busy<='0';
									Data_Out<=data_buffer;
									IF_Mem_Controller:=idle;
								end if;
							end if;
						end case;
				end if;
				
--				if (IF_Busy'event) then
	--				Busy_int<=IF_Busy;
		--		end if;
			end process;

		end Instruction_Mem;