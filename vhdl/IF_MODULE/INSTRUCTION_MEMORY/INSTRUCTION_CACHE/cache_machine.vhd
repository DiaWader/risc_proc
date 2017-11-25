			----------------------------------------------------------------------------------
			-- Company: 
			-- Engineer: 
			-- 
			-- Create Date:    00:35:07 11/16/2017 
			-- Design Name: 
			-- Module Name:    cache_machine - Behavioral 
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

			entity cache_machine is
				 Port (   cmp 		: in  STD_LOGIC;
						  activate  : in  STD_LOGIC;
						  clk 		: in  STD_LOGIC;
						  cop_TF		: out std_logic_vector (1 downto 0);
						  cache_word_c	: out  STD_LOGIC:='0';
						  V_i				: out  STD_LOGIC:='0';
						  cache_mem_rw	: out  STD_LOGIC:='0';
						  word_counter : out  STD_LOGIC_VECTOR (9 downto 0):=(others=>'0');
						  busy 			: out std_logic:='0';
						  mem_WR		: out std_logic_vector:="00");
			end cache_machine;

			architecture Behavioral of cache_machine is
			TYPE		machine IS(idle, tag_check, write_lp1, write_lp2);			--needed states
			--	SIGNAL	current_state   :  machine := run;					--state machine
			--	SIGNAL 	last_state 		 :  machine;
			-- signal word_counter_int : STD_LOGIC_VECTOR (9 downto 0));
			begin
			process (clk, activate, cmp)
			variable current_state: machine :=idle;
			variable word_counter_int : integer :=0;
			begin
				if (clk'event) then
					case current_state is
					------------------------------------------
						when idle =>
								if(activate='1') then					--1
									current_state :=tag_check;	
									cop_tf   <="00";	
									busy	<='1';	
								elsif (activate='0') then				--0
									word_counter<="0000000000";	
									cache_word_c<='0';	
									V_i<='0';	
									cop_tf<="00"	;
									Cache_Mem_RW<='0';
									mem_WR<="00";
								end if;	
					------------------------------------------	
						when tag_check =>	
								if(cmp='1') then 							--2
									current_state :=idle;	
									busy <='0';	
								elsif(cmp='0') then						--3
									V_i <='1';
									cop_tf<="11";
									Cache_Word_C<='1';
									Word_counter_int:=0;
									word_counter<=std_logic_vector(to_unsigned(word_counter_int,10));
									current_state :=write_lp1;
									Cache_Mem_RW<='1';
									mem_WR <="10";
								end if;
					------------------------------------------
						when write_lp1 =>									--4
									word_counter_int:=word_counter_int+1;	
									V_i 			<='0';									--
									Cache_Mem_RW<='0';
									mem_WR		<="00";
									cop_tf		<="00";
									current_state :=write_lp2;
					------------------------------------------
						when write_lp2 =>									--5
								if(word_counter_int<1024) then								
									word_counter	<=std_logic_vector(to_unsigned(word_counter_int,10));
									current_state 	:=write_lp1;
									Cache_Mem_RW	<='1';
									mem_WR 			<="10";
								elsif(word_counter_int=1024) then	--6
									Cache_Mem_RW	<='0';
									mem_WR 			<="00";
									cache_word_C	<='0';
									current_state :=tag_check;		
								end if;
					------------------------------------------
					end case;
				end if;
			end process;

			end Behavioral;

