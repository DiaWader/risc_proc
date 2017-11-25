			----------------------------------------------------------------------------------
			-- Company: 
			-- Engineer: 
			-- 
			-- Create Date:    02:01:46 11/12/2017 
			-- Design Name: 
			-- Module Name:    Reg_File - Reg_File 
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
			use IEEE.NUMERIC_STD.all; 	


			entity Reg_File is
				 Port ( Reg_A_Adr : in  STD_LOGIC_VECTOR (5 downto 0);
						  Reg_B_Adr : in  STD_LOGIC_VECTOR (5 downto 0);
						  Wr_Adr 	: in  STD_LOGIC_VECTOR (5 downto 0);
						  Wr 			: in  STD_LOGIC;
						  CLK			: in  STD_LOGIC;
						  Data_In	: in  STD_LOGIC_VECTOR (31 downto 0);
						  Reg_A 		: out  STD_LOGIC_VECTOR (31 downto 0):=(others=>'0');
						  Reg_B 		: out  STD_LOGIC_VECTOR (31 downto 0):=(others=>'0'));
			end Reg_File;

			architecture Reg_File of Reg_File is
			----------------------------------------------------------------------------------
			component Reg_File_Register is
			Port (  Data_In : in  STD_LOGIC_VECTOR (31 downto 0);
					  Data_Out : out  STD_LOGIC_VECTOR (31 downto 0);
					  WE : in  STD_LOGIC);
			end component;
			----------------------------------------------------------------------------------
--			type Regs7x4 is array (3 downto 0) of std_logic_vector (6 downto 0);
			type Regs32x64 is array (63 downto 0) of std_logic_vector (31 downto 0);
			signal Reg_Out		: Regs32x64;
			signal WE_Rg		: std_logic_vector (63 downto 0):=(others=>'0');
--			signal Wr_Queue	: Regs7x4;  
--			signal Reg_A_int, Reg_B_int : std_logic_vector (31 downto 0);
--			signal Wr_Adr_now : std_logic_vector (5 downto 0):=(others=>'0');
--			signal Wr_now 		: std_logic:='0';
			----------------------------------------------------------------------------------
			begin

			----------------------------------------------------------------------------------
				Registers: for i in 63 downto 0 generate					--
					Register_i: Reg_File_Register port map (				-- оголошення масиву регістрів
							Data_In =>Data_In,									-- 
							Data_Out => Reg_Out(i),								--
							WE =>WE_Rg(i));										--
				end generate; 														--
			----------------------------------------------------------------------------------
			Reg_A<=Reg_Out(to_integer(unsigned(Reg_A_Adr))) when clk'event and clk='1';		-- mux_A
			Reg_B<=Reg_Out(to_integer(unsigned(Reg_B_Adr))) when clk'event and clk='1';		-- mux_B
			----------------------------------------------------------------------------------
			process(wr_adr, wr, clk) begin
				for i in 0 to 63 loop
					if(i=to_integer(unsigned(Wr_Adr)) and clk'event and clk='1') then
						WE_Rg(i)<=Wr;												-- DC 
					else
						WE_Rg(I)<='0';
					end if;
				end loop;
			end process;
			----------------------------------------------------------------------------------
			end Reg_File;



--			process (clk, wr, wr_adr, data_in, reg_a_adr, reg_b_adr)begin
--			
--				if (clk'event and clk='1') then					-- додатній ^ фронт 
----					Wr_now <= Wr_Queue(0)(0);						-- читання вершини черги
----					Wr_Adr_now <= Wr_Queue(0)(6 downto 1);		--
----					
----					for i in 0 to 2 loop								--
----						Wr_Queue(i) <= Wr_Queue(i+1);				--	зсув черги
----					end loop;											--
----					
----					Wr_Queue(3)(0) <= Wr;							--
----					Wr_Queue(3)(6 downto 1) <= Wr_Adr;			-- запис нового елемента черги
--			
----					Reg_A<=Reg_A_int;
----					Reg_B<=Reg_B_int;
--				end if;
--			end process;
