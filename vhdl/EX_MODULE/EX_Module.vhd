			----------------------------------------------------------------------------------
			-- Company: 
			-- Engineer: 
			-- 
			-- Create Date:    21:35:30 11/21/2017 
			-- Design Name: 
			-- Module Name:    EX_Module - EX_Module 
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

			entity EX_Module is
				 Port ( Op_A_ID 	: in  STD_LOGIC_VECTOR (31 downto 0);
						  Op_B_ID 	: in  STD_LOGIC_VECTOR (31 downto 0);
						  CLK_EX 	: in  STD_LOGIC;
						  COP_ID 	: in  STD_LOGIC_VECTOR (6 downto 0);
						  WR_ID 		: in  STD_LOGIC;
						  AD_ID 		: in  STD_LOGIC_VECTOR (5 downto 0);
						  Jump_EX 	: out STD_LOGIC:='0';
						  RES_EX 	: out STD_LOGIC_VECTOR (31 downto 0):=(others=> '0');
						  COP_EX 	: out STD_LOGIC_VECTOR (1  downto 0):=(others=> '0');
						  Op_B_EX 	: out STD_LOGIC_VECTOR (31 downto 0):=(others=> '0');
						  WR_EX 		: out STD_LOGIC:='0';
						  AD_EX 		: out STD_LOGIC_VECTOR (5 downto 0):=(others=> '0'));
			end EX_Module;

			architecture EX_Module of EX_Module is
			--------------------------------------------------------------------------------------
				COMPONENT ALP
					Port ( Op_A : in  STD_LOGIC_VECTOR (31 downto 0);
							 Op_B : in  STD_LOGIC_VECTOR (31 downto 0);
							 COP 	: in  STD_LOGIC_VECTOR (6 downto 0);
							 Res 	: out STD_LOGIC_VECTOR (31 downto 0);
							 Jump : out STD_LOGIC;
							 CLK 	: in  STD_LOGIC);
				END COMPONENT;
			--------------------------------------------------------------------------------------		
			begin
			--------------------------------------------------------------------------------------	
				EX_ALP:ALP	Port Map( 
					Op_A 	=> Op_A_ID,
					Op_B 	=> Op_B_ID,
					COP 	=> COP_ID,
					Res 	=> Res_EX,
					Jump 	=> Jump_EX,
					CLK 	=> CLK_EX);	
			--------------------------------------------------------------------------------------
				process(CLK_EX, COP_ID, WR_ID, AD_ID, Op_B_ID) 
				
				variable Op_B_Intr : std_logic_vector (31 downto 0):=(others=>'0');
				variable COP_Intr  : std_logic_vector (1 downto 0) :="00";
				variable WR_Intr	 : std_logic :='0';
				variable AD_Intr   : std_logic_vector (5 downto 0) :=(others=>'0');
				begin
					if (clk_ex'event and clk_ex='1') then
						Op_B_Intr:=Op_B_ID;
						WR_Intr :=WR_ID;
						AD_Intr :=AD_ID;
						--------------------------------------------------------------------------------------
						case COP_ID is                                  --	сигнали керування пам'яттю даних
							when  "1100110" => COP_Intr := "11";         --
							when  "1101000" => COP_Intr := "10";         --
							when  "1101001" => COP_Intr := "10";			--
							when  "1110000" => COP_Intr := "01";			-- HALT
							when others		 => COP_Intr := "00";         --
						end case;
						--------------------------------------------------------------------------------------
					elsif (clk_ex'event and clk_ex='0') then	
						Op_B_EX 	<=Op_B_Intr;
						WR_EX 	<=WR_Intr;
						AD_EX 	<=AD_Intr;
						COP_EX	<=COP_Intr;
					end if;
				end process;
			end EX_Module;

