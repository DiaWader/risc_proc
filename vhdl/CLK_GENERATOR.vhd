		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    00:08:18 11/15/2017 
		-- Design Name: 
		-- Module Name:    CLK_GENERATOR - CLK_GENERATOR 
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

		--use IEEE.NUMERIC_STD.ALL;
		entity CLK_GENERATOR is
			 generic( PERIOD	: TIME := 100 PS);	
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
		end CLK_GENERATOR;

		architecture CLK_GENERATOR of CLK_GENERATOR is
		TYPE		machine IS(run, jump_0, jump_1,jump_2,  jump_1_1,jump_2_1, jump_3, mem_inter);	
	--	SIGNAL	current_state   :  machine := run;					--state machine
	--	SIGNAL 	last_state 		 :  machine;
		signal CLK_INTERN,CLK_IF_s, CLK_ID_s, CLK_EX_s, CLK_MA_s,CLK_Dat_M_S,CLK_Ins_M_S  :std_logic :='0';
		signal CLK_IF_I, CLK_ID_I, CLK_EX_I, CLK_MA_I : std_logic :='1';
		begin
		
		process begin
		IF (HALT='0') THEN
			wait for PERIOD/2;
			CLK_INTERN<=NOT CLK_INTERN;
		ELSE 
		WAIT;
		END IF;
		end process;
		clk<=CLK_INTERN;
		--------------------------------------------------------
--		process(CLK_INTERN) begin
--
--				CLK_Ins_M <= clk_intern when I_C='1';			
--				CLK_Dat_M <= clk_intern when D_C='1'; 		--
--				clk_if    <= clk_intern when CLK_IF_I='1';	--
--				clk_id    <= clk_intern when CLK_ID_I='1';	--
--				clk_ex    <= clk_intern when CLK_EX_I='1';	--
--				clk_ma    <= clk_intern when CLK_MA_I='1';	--
--
--		end process;
				
				CLK_Ins_M <= clk_intern when I_C='1' and CLK_INTERN'event ;			
				CLK_Dat_M <= clk_intern when D_C='1' and CLK_INTERN'event; 		--
				clk_if    <= clk_intern when CLK_IF_I='1' and CLK_INTERN'event;	--
				clk_id    <= clk_intern when CLK_ID_I='1' and CLK_INTERN'event;	--
				clk_ex    <= clk_intern when CLK_EX_I='1' and CLK_INTERN'event;	--
				clk_ma    <= clk_intern when CLK_MA_I='1' and CLK_INTERN'event;	--

		--------------------------------------------------------
		--CLK_IF <= clk_if_s;
--		CLK_ID <= clk_id_s;
--		CLK_EX <= clk_ex_s;
--		CLK_MA <= clk_ma_s;
--		CLK_Ins_M <= CLK_Ins_M_S;
--		CLK_Dat_M <= CLK_Dat_M_S;
		--------------------------------------------------------
		process(CLK_INTERN, EX_JUMP, R_C)
		variable current_state : machine := run;
		variable last_state : machine;
		begin
			case current_state is
					------------------------------------------
					when RUN =>
							CLK_IF_I<='1'; 
							CLK_ID_I<='1';
							CLK_EX_I<='1';
							CLK_MA_I<='1';
							if (EX_JUMP = '1' and ex_jump'event) then
								CLK_ID_I<='0';
								CLK_EX_I<='0';
								current_state := jump_0;
							end if;
							if (R_C = '0') then
								last_state := current_state;
								CLK_IF_I <= '0'; 
								CLK_ID_I <= '0';
								CLK_EX_I <= '0';
								CLK_MA_I <= '0';
								current_state := mem_inter;
							end if;
					------------------------------------------
					when jump_0 =>
							CLK_IF_I<='1'; 
							CLK_ID_I<='0';
							CLK_EX_I<='0';
							CLK_MA_I<='1';
							current_state:=jump_1;
							if (R_C = '0') then
								last_state := jump_1;
								CLK_IF_I <= '0'; 
								CLK_ID_I <= '0';
								CLK_EX_I <= '0';
								CLK_MA_I <= '0';
								current_state := mem_inter;
							end if;
					------------------------------------------ 
					when jump_1 =>
							CLK_IF_I<='1'; 
							CLK_ID_I<='0';
							CLK_EX_I<='0';
							CLK_MA_I<='1';
							current_state:=jump_1_1;
							if (R_C = '0') then
								last_state := current_state;
								CLK_IF_I <= '0'; 
								CLK_ID_I <= '0';
								CLK_EX_I <= '0';
								CLK_MA_I <= '0';
								current_state := mem_inter;
							end if;
					------------------------------------------
					when jump_1_1 =>
							CLK_IF_I<='1'; 
							CLK_ID_I<='1';
							CLK_EX_I<='0';
							CLK_MA_I<='1';
							current_state:=jump_2;
							if (R_C = '0') then
								last_state := current_state;
								CLK_IF_I <= '0'; 
								CLK_ID_I <= '0';
								CLK_EX_I <= '0';
								CLK_MA_I <= '0';
								current_state := mem_inter;
							end if;
					------------------------------------------
					when jump_2 =>
							CLK_IF_I<='1'; 
							CLK_ID_I<='1';
							CLK_EX_I<='0';
							CLK_MA_I<='1';
							current_state :=jump_2_1;
							if (R_C = '0') then
								last_state := current_state;
								CLK_IF_I <= '0'; 
								CLK_ID_I <= '0';
								CLK_EX_I <= '0';
								CLK_MA_I <= '0';
								current_state := mem_inter;
							end if;
					------------------------------------------		
					when jump_2_1 =>
							CLK_IF_I<='1'; 
							CLK_ID_I<='1';
							CLK_EX_I<='1';
							CLK_MA_I<='1';
							current_state :=run;
							if (R_C = '0') then
								last_state := current_state;
								CLK_IF_I <= '0'; 
								CLK_ID_I <= '0';
								CLK_EX_I <= '0';
								CLK_MA_I <= '0';
								current_state := mem_inter;
							end if;
					------------------------------------------
					when jump_3 =>
							CLK_IF_I<='1'; 
							CLK_ID_I<='1';
							CLK_EX_I<='1';
							CLK_MA_I<='1';
							current_state :=run;
							if (R_C = '0') then
								last_state := current_state;
								CLK_IF_I <= '0'; 
								CLK_ID_I <= '0';
								CLK_EX_I <= '0';
								CLK_MA_I <= '0';
								current_state := mem_inter;
							end if;
					------------------------------------------
					when mem_inter =>
							if (R_C = '1') then
								current_state := last_state;
								if(last_state = jump_0 or last_state = jump_1 or last_state = jump_1_1 ) then 
									CLK_IF_I <= '1';
									CLK_ID_I <= '0';
									CLK_EX_I <= '0';
									CLK_MA_I <= '1';
								elsif (last_state = jump_2 or last_state = jump_2_1 or last_state = jump_3) then 
									CLK_IF_I <= '1';
									CLK_ID_I <= '1';
									CLK_EX_I <= '0';
									CLK_MA_I <= '1';
								else 
									CLK_IF_I <= '1'; 
									CLK_ID_I <= '1';
									CLK_EX_I <= '1';
									CLK_MA_I <= '1';
								end if;
							end if;
					------------------------------------------
				end case;
		end process;
		--------------------------------------------------------
		end CLK_GENERATOR;

