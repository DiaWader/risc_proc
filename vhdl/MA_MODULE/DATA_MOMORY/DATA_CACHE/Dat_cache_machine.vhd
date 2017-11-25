		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    15:03:53 11/17/2017 
		-- Design Name: 
		-- Module Name:    Dat_cache_machine - Dat_cache_machine 
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

		entity Dat_cache_machine is
			 Port ( COP 			: in  std_logic;
					  cmp 			: in  STD_LOGIC;
					  V_In 			: out STD_LOGIC:='0';	
					  D_In 			: out STD_LOGIC:='0';
					  D_Out 		: in  STD_LOGIC;
					  CLK 			: in  STD_LOGIC;
					  Activate		: in  STD_LOGIC;
					  store_block	: out std_logic:='0';
					  Data_In_C		: out std_logic:='0';
					  Data_Out_C	: out std_logic:='0';
					  COP_TF 		: out STD_LOGIC_VECTOR (1 downto 0):="00";
					  MEM_WR 		: out STD_LOGIC_VECTOR (1 downto 0):="00";
					  R_W 			: out STD_LOGIC:='0';
					  Word_Counter 	: out STD_LOGIC_vector(12 downto 0);
					  Cache_Word_C 	: out STD_LOGIC:='0';
					  Busy 			: out STD_LOGIC:='0');
		end Dat_cache_machine;

		architecture Dat_cache_machine of Dat_cache_machine is
		TYPE		machine IS(idle, cmp_s, d_check, load_1, load_2, Store_1, Store_2);			--needed states
		begin
		
			process (clk, activate, cmp)
			variable current_state: machine :=idle;
			variable word_counter_int : integer :=0;
			
			begin
				if (clk'event) then
					case current_state is
					-----------------------------------------------
						when idle =>
								if(activate='1') then ----------------1
									current_state :=cmp_s;	
									cop_tf   <="00";	
									busy	<='1';	
					-----------------------------------------------				
								elsif (activate='0') then ------------0
									word_counter <="0000000000000";	
									cache_word_c <='0';		
									cop_tf		 <="00"	;
									R_W <='0';
									mem_WR <="00";
									V_In 	 <= '0';
 								    D_In 	 <= '0';
									Busy	 <= '0'; 
									Data_In_C	<='0';	
									Data_Out_C	<='0';
								end if;	
					-----------------------------------------------	
						when cmp_s =>	
								if(cmp='1') then----------------------2
									if(cop='0') then-------------------store word
										cache_word_c<='0';
										R_W <='1';
										D_In<='1';
										COP_TF<="10";
										Busy	 <= '0'; 
									elsif (cop='1') then---------------load  word
										cache_word_c<='0';
										R_W <='0';
										Busy	 <= '0'; 
									end if;	
									Busy	 <= '0';  
									current_state :=idle;	
					--------------------------------------------------
								elsif(cmp='0') then-------------------3
									Word_counter_int:=0;
									word_counter	<=std_logic_vector(to_unsigned(word_counter_int,13));
									R_W				<='1';
									cache_word_c<='1';
									mem_WR 			<="00";
									current_state  :=d_check;
									Busy			<='1';
								end if;
					-----------------------------------------------
						when d_check =>
								if(not(d_out='1')) then--------------------4
									Data_In_C		<='1';
									store_block		<='0';
									V_in  			<='1';
									cop_tf			<="11";
									R_W				<='1';
									Word_counter_int:=0;
									word_counter	<=std_logic_vector(to_unsigned(word_counter_int,13));
									mem_WR 			<="10";
									current_state 	:=load_1;
								else 				-----------------5
							--		Data_Out_C		<='1';
									store_block		<='1';
									D_in			<='0';
									cop_tf			<="10";	
									Word_counter_int:=0;
									word_counter	<=std_logic_vector(to_unsigned(word_counter_int,13));
									R_W				<='0';
									mem_WR 			<="11";
									current_state :=store_1;
								end if;
					-----------------------------------------------
						when load_1 =>	-----------------------------7
									word_counter_int:=word_counter_int+1;	
									V_in 		<='0';									
									R_W			<='0';
									mem_WR		<="00";
									cop_tf		<="00";
									current_state :=load_2;
					-----------------------------------------------
						when load_2 =>	
								if(word_counter_int<2**13) then-------6								
									word_counter	<=std_logic_vector(to_unsigned(word_counter_int,13));
									current_state 	:=load_1;
									R_W				<='1';
									mem_WR 			<="10";
					-----------------------------------------------
								elsif(word_counter_int=2**13) then----8
									R_W				<='0';
									mem_WR 			<="00";
									cache_word_C	<='0';
									current_state :=cmp_s; 
									Data_In_C<='0';
									Data_Out_C<='0';
								end if;
					-----------------------------------------------
						when store_1 => ----------------------------9
								word_counter_int:=word_counter_int+1;									
									R_W			<='0';
									mem_WR		<="00";
									cop_tf		<="00";
									current_state :=store_2;
					-----------------------------------------------
						when store_2 => 
							if (word_counter_int<2**13) then---------10
									word_counter	<=std_logic_vector(to_unsigned(word_counter_int,13));
									current_state 	:=store_1;
									R_W				<='0';
									mem_WR 			<="11";
							elsif(word_counter_int=2**13)then--------11
									Data_In_C		<='1';
									store_block		<='0';
									V_in  			<='1';
									cop_tf			<="11";
									R_W				<='1';
									Word_counter_int:=0;
									word_counter	<=std_logic_vector(to_unsigned(word_counter_int,13));
									mem_WR 			<="10";
									current_state 	:=load_1;
							end if;
					-----------------------------------------------
					end case;  
					
				end if;
			end process;
		end Dat_cache_machine;

