		----------------------------------------------------------------------------------
		-- Company: 
		-- Engineer: 
		-- 
		-- Create Date:    23:50:32 11/21/2017 
		-- Design Name: 
		-- Module Name:    MA_Module - MA_Module 
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

		entity MA_Module is
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
					  HALT		: out std_logic :='0');
		end MA_Module;

		architecture MA_Module of MA_Module is
		----------------------------------------------------------------------------------
		component Data_Mem Port 
					( Address_In: in  STD_LOGIC_VECTOR (28 downto 0);
					  Address_M	: out STD_LOGIC_VECTOR (28 downto 0):= (others => '0');
					  Data_In_R : in  STD_LOGIC_VECTOR (31 downto 0);
					  Data_Out_R: out STD_LOGIC_VECTOR (31 downto 0):= (others => '0');
					  COP 		: in  STD_LOGIC_VECTOR (1 downto 0);
					  Busy 		: out STD_LOGIC:= '0';
					  CLK			: in  std_logic;
					  Mem_WR		: out std_logic_vector (1 downto 0):= (others => '0');
					  Data_In_M : in  std_logic_vector (7 downto 0);
					  Data_Out_M: out std_logic_vector (7 downto 0):= (others => '0'));
		end component;
		----------------------------------------------------------------------------------
		signal Data_Out_R : std_logic_vector (31 downto 0):= (others=>'0');
		begin
		----------------------------------------------------------------------------------
			MA_Dat_Mem : Data_Mem Port map
						  (  Address_In => Res_EX(28 downto 0),
							  Address_M	 => D_Adr_M,
							  Data_In_R  => Op_B_EX,
							  Data_Out_R => Data_Out_R,
							  COP 		 => COP_EX,
							  Busy 		 => D_B, 
							  CLK		 	 => CLK_Dat_M,
							  Mem_WR	 	 => D_Mem_WR,
							  Data_In_M  => D_Load_M,
							  Data_Out_M => D_Store_M);
			
			HALT_PROC:PROCESS(COP_EX, CLK_MA)
			BEGIN
				IF(CLK_MA'EVENT AND CLK_MA='1' AND COP_EX="01") THEN
				HALT<='1';
				ELSE HALT<='0';
				END IF;
			END PROCESS;
			
			process(CLK_MA, Data_Out_R, Res_EX, COP_EX, WR_EX, AD_EX)
			variable Res_Intr : std_logic_vector (31 downto 0):= (others => '0');
			variable WR_Intr, COP_Intr : std_logic :='0';
			variable AD_Intr : std_logic_vector (5 downto 0):= (others => '0');
			begin
				if (CLK_MA'event and CLK_MA='1') then
						Res_Intr:=Res_EX;
						COP_Intr:=COP_EX(1);
						WR_Intr :=WR_EX;
						AD_Intr :=AD_Ex;
				elsif (CLK_MA'event and CLK_MA='0') then
					case COP_Intr is 
						when '1'    => Data_MA <=Data_Out_R;
						when others => Data_MA <= Res_Intr;
					end case;
					WR_Ma<=WR_Intr;
					AD_MA<=AD_Intr;
				end if;
			end process;
			
			
		end MA_Module;

