		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    17:38:45 11/19/2017 
		-- Design Name: 
		-- Module Name:    Control_Block - Control_Block 
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

		entity Control_Block is
			Port (  clk : in  std_logic;
					  D_B : in  STD_LOGIC;							--Busy_D  
					  I_B : in  STD_LOGIC;							--Busy_I  
					  D_M : in  STD_LOGIC;							--D_Mem_WR(1) 
					  I_M : in  STD_LOGIC;							--I_Mem_WR(1) 
					  R_C : out STD_LOGIC:='1';					--Conv_Activate
					  I_C : out STD_LOGIC:='1';					--Ins_mem_Activate
					  D_C : out STD_LOGIC:='1';					--Dat_mem_Activate
					  Bus_Control : out  STD_LOGIC_VECTOR (1 downto 0):="00");
		end Control_Block;

		architecture Control_Block of Control_Block is
		TYPE		machine IS(run, cache_run, I_M_Loop,D_M_Loop, D_M_Frozen, I_M_Frozen);	
		begin
		
		main: process( D_B,I_B,D_M,I_M,clk)
		variable main_controller: machine := run;
		begin
			case main_controller is
			--=============================================================-- RUN
				when run => ----------------------------------------------
					if(I_B'event and I_B='1') then ----------------------- 1
						main_controller:=cache_run;
						R_C<='0';
					end if;
			--=============================================================-- CACHE_RUN
				when cache_run => ----------------------------------------
					if((D_M'event and D_M='1') or D_M='1') then----------- 2
						main_controller:=D_M_Loop;
						Bus_Control<="11";			--bus under Dat_Mem control
				----------------------------------------------------------
					elsif((I_M'event and(not D_M'event)and I_M='1') or 
						(I_M='1' and D_B='0')) then ---------------------- 3
						main_controller:=I_M_Loop;
						Bus_Control<="10";			--bus under Ins_Mem control
				----------------------------------------------------------
					elsif(I_B='0' and D_B='0')then --------------------- 4
						main_controller:=run;
						R_C<='1';
						I_C<='1';
						D_C<='1';
					elsif(I_B='0') then
						I_C<='0';
					elsif(D_B='0') then
						D_C<='0';
					end if;
			--=============================================================-- I_M_LOOP
				when I_M_Loop => -----------------------------------------
					if (I_B'event and I_B='0') then ---------------------- 7
						main_controller:=cache_run;
						I_C<='0';					-- end Ins_Mem activity
						Bus_Control<="00";			-- bus in sleep mode
				----------------------------------------------------------
					elsif(D_M'event and D_M='1'and(not I_B'event)) then -- 5
						main_controller:=D_M_Frozen;
						D_C<='0';					-- froze Dat_Mem
					end if;----------------------------------------------- 6
				----------------------------------------------------------
					if (D_B='0') then	---------------------- 16
						D_C<='0';
					end if;		  	
			--=============================================================-- D_M_FROZEN
			  	when D_M_Frozen => ---------------------------------------
					if (I_B'event and I_B='0') then ---------------------- 8
					  	main_controller:=D_M_Loop;
						I_C<='0';					-- end Ins_Mem activity
						Bus_Control<="11";			-- bus under Dat_Mem control 
						D_C<='1';					-- unfroze Dat_Mem						  
			  		end if;----------------------------------------------- 9
			--=============================================================-- D_M_LOOP
				when D_M_Loop => -----------------------------------------
					if (D_B'event and D_B='0') then ---------------------- 11
						main_controller:=cache_run;
						D_C<='0';					-- end Dat_Mem activity
						Bus_Control<="00";			-- bus in sleep mode
				----------------------------------------------------------
					elsif (I_M'event and I_M='1') then ------------------- 10
						main_controller:=I_M_Frozen;
						I_C<='0'; 					-- froze Ins_Mem
					end if;----------------------------------------------- 12
				----------------------------------------------------------	
					if (I_B='0') then ---------------------- 15
						I_C<='0';
					end if;
			--=============================================================-- I_M_FROZEN
				when I_M_Frozen => ---------------------------------------
					if (D_B'event and D_B='0') then ---------------------- 13 
						main_controller:=I_M_Loop;
						D_C<='0';					-- end Dat_Mem activity
						Bus_Control<="10";			-- bus under Ins_Mem control 
						I_C<='1';					-- unfroze Ins_Mem				
					end if;----------------------------------------------- 14	
			--=============================================================--   
			end case;
		end process;
		
		
		end Control_Block;

