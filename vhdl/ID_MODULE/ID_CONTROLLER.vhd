			----------------------------------------------------------------------------------
			-- Company: 
			-- Engineer: 
			-- 
			-- Create Date:    16:37:06 11/12/2017 
			-- Design Name: 
			-- Module Name:    ID_CONTROLLER - ID_CONTROLLER 
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

			entity ID_CONTROLLER is
				 Port ( COP_In  : in  	STD_LOGIC_VECTOR (6 downto 0);
						  NPC_In	 : in  	STD_LOGIC_VECTOR (28 downto 0);
						  CLK 	 : in 	STD_LOGIC;
						  Op_A_R  : out  	STD_LOGIC_VECTOR (1 downto 0):="00";
						  Op_B_R  : out  	STD_LOGIC:='0';
						  Imm 	 : out  	STD_LOGIC:='0';
						  WR 		 : out  	STD_LOGIC:='0');
			end ID_CONTROLLER;

			architecture ID_CONTROLLER of ID_CONTROLLER is
			begin
			----------------------------------------------------------------------------------
--			process(CLK, COP_IN, NPC_In)
--			begin
--				if (clk'event and clk='1') then
--					cop_out <=COP_In;
--					npc_out <=NPC_In;
--				end if;
--			end process;
			----------------------------------------------------------------------------------
			process(COP_In,CLK) begin
				if (clk='1' and clk'event) then
					case COP_In is
							when		 "0000000"=>	Op_A_R<="00";	Op_B_R<='0'; Imm<='1'; WR<='1';		--	ADD
							when      "0000001"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ADDI
							when      "0000010"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='0'; WR<='1';     --	ADDUI
							when      "0000011"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	SUB
							when      "0000100"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	SUBI
							when      "0000101"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='0'; WR<='1';     --	SUBUI
							when      "0000110"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	ADC
							when      "0000111"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ADCI
							when      "0001000"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='0'; WR<='1';     --	ADCUI
							when      "0001001"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	SBB
							when      "0001010"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	SBBI
							when      "0001011"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='0'; WR<='1';     --	SBBUI
							when      "0001100"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	INC
							when      "0001101"=>	Op_A_R<="10";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	DEC
							when      "0001110"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	INN
							when      "0001111"=>	Op_A_R<="10";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	DEN
							when      "0010000"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	CMP
							when      "0010001"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	CMPI
							when      "0010010"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='0'; WR<='0';     --	CMPUI
							when      "0010011"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	CMPN
							when      "0010100"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	MUL
							when      "0010101"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	MULU
							when      "0010110"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	MULI
							when      "0010111"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='0'; WR<='1';     --	MULUI
							when      "0011000"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	DIV
							when      "0011001"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	DIVU
							when      "0011010"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	DIVI
							when      "0011011"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='0'; WR<='1';     --	DIVUI
							when      "0011100"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	ABS
							when      "0011101"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	TNG
							when      "0011110"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	INVP
							when      "0011111"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	INVD
							when      "0100000"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	BCDP
							when      "0100001"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	BCDU
							when      "0100010"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	BTC
							when      "0100011"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	TBCD
							when      "0100100"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	TBCDU
							when      "0100101"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	TBCDI
							when      "0100110"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='0'; WR<='1';     --	TBCDUI
							when      "0100111"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	LSR
							when      "0101000"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	LSR
							when      "0101001"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	LSL
							when      "0101010"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	LSLI
							when      "0101011"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	ROR
							when      "0101100"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	RORI
							when      "0101101"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	ROL
							when      "0101110"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ROLI
							when      "0101111"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	ASR
							when      "0110000"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ASRI
							when      "0110001"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	ASL
							when      "0110010"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ASLI
							when      "0110011"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	LSO
							when      "0110100"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	LSI
							when      "0110101"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	ROO
							when      "0110110"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ROI
							when      "0110111"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	ASO
							when      "0111000"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ASI
							when      "0111001"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	NOT
							when      "0111010"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	AND
							when      "0111011"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ANDI
							when      "0111100"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ANDUI
							when      "0111101"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	OR
							when      "0111110"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ORI
							when      "0111111"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	ORUI
							when      "1000000"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	XOR
							when      "1000001"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	XORI
							when      "1000010"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	XORUI
							when      "1000011"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JMP
							when      "1000100"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JO
							when      "1000101"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JNO
							when      "1000110"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JS
							when      "1000111"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JNS
							when      "1001000"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JZ
							when      "1001001"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JNZ
							when      "1001010"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JC
							when      "1001011"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JNC
							when      "1001100"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JBE 
							when      "1001101"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JA 
							when      "1001110"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JL 
							when      "1001111"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JNL
							when      "1010000"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JLE 
							when      "1010001"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JG 
							when      "1010010"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JAX
							when      "1010011"=>	Op_A_R<="11";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	JNAX
							when      "1010100"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JMPI
							when      "1010101"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JOI
							when      "1010110"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JNOI
							when      "1010111"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JSI
							when      "1011000"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JNSI
							when      "1011001"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JZI
							when      "1011010"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JNZI
							when      "1011011"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JCI
							when      "1011100"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JNCI
							when      "1011101"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JBEI
							when      "1011110"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JAI
							when      "1011111"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JLI
							when      "1100000"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JNLI
							when      "1100001"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JLEI
							when      "1100010"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JGI
							when      "1100011"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JAXI
							when      "1100100"=>	Op_A_R<="01";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	JNAXI
							when      "1100101"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	STR
							when      "1100110"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	STRM
							when      "1100111"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	STRMI
							when      "1101000"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	LRGM
							when      "1101001"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='1';     --	LRGMI
							when      "1101010"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	LFRG
							when      "1101011"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	LFRGI
							when      "1101100"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	SFRG
							when      "1101101"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	SFRGM
							when      "1101110"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	SFRGMI
							when      "1101111"=>	Op_A_R<="01";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	SPC
							when      "1110000"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	SPCM
							when      "1110001"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	SPCMI
							when      "1110010"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='1';     --	SAH
							when      "1110011"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	SAHM
							when      "1110100"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	SAHMI
							when      "1110101"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	LAH
							when      "1110110"=>	Op_A_R<="00";  Op_B_R<='1'; Imm<='1'; WR<='0';     --	LAHI
							when      "1110111"=>	Op_A_R<="00";  Op_B_R<='0'; Imm<='1'; WR<='0';     --	NOP
							when others => Op_A_R<="00";	Op_B_R<='0'; Imm<='0'; WR<='0';
						end case;
					end if;
				end process;
			end ID_CONTROLLER;