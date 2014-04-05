`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:24:41 03/08/2014 
// Design Name: 
// Module Name:    LC3_datapath 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module LC3_datapath(
	/*GENERAL INPUT*/
		input					clk,
		input					reset,
		input		[15:0]	DATABUS,
	
	/*REGFILE-RELATIVE INPUT*/
		input		[1:0]		SR1MUX,
		input		[1:0]		DRMUX,
		
	/*ALU-RELATIVE INPUT*/
		input		[1:0]		ALUK,
//		input					SR2MUX,
		
	/*ADDRESS-RELATIVE INPUT*/
		input					ADDR1MUX,
		input		[1:0]		ADDR2MUX,
		input		[1:0]		PCMUX,
		input					MARMUX,
		
	/*PSR-RELATIVE	INPUT*/
		input					Set_Priv,
		input					PSRMUX,
		
	/*INT-RELATIVE	INPUT*/
		input		[7:0]		INTV,
		input		[1:0]		VectorMUX,
		input		[1:0]		SPMUX,
		input		[2:0]		Int_Priority,
		
	/*GATES*/
		input					GateALU,
		input					GatePSR,
		input					GateSP,
		input					GateVector,
		input					GateMARMUX,
		input					GatePC,
		input					GatePCsubtract1,
		
	/*LOAD SIGNAL*/
		input					LD_BEN,
		input					LD_REG,
		input					LD_IR,
		input					LD_PC,
		input					LD_CC,
		input					LD_Priv,
		input					LD_Priority,
		input					LD_Vector,
		input					LD_SavedUSP,
		input					LD_SavedSSP,
		
	/*DATABUS OUTPUT*/
		inout	[15:0]	ALUbus_out,
		inout	[15:0]	PSRbus_out,
		inout	[15:0]	SPbus_out,
		inout	[15:0]	Vector_bus_out,
		inout	[15:0]	MARbus_out,
		inout	[15:0]	PCbus_out,
		inout	[15:0]	PCsubtract1_bus_out,
		
	/*STATE MACHINE OUTPUT*/
		output				BEN_reg,
		output				INT,
		output	[15:0]	IR_reg,
		output				Priv_reg

    );



		

		
		
	/*internal wires*/
		wire	[15:0]	SR1out;
		wire	[15:0]	SR2out;
		
		
	/*internal regs*/
		reg	[15:0]	IR;
		reg	[15:0]	PC;
		reg	[15:0]	SavedUSP;
		reg	[15:0]	SavedSSP;
		reg	[2:0]		Priority;
		reg	[2:0]		CC;
		reg				Priv;
		reg	[7:0]		Vector;
		
		
	/*IR	SEXT*/
		/*IR	[4:0]	immediate number imm5*/
			wire	[15:0]	imm5;
			assign	imm5[15:5]={11{IR[4]}};
			assign	imm5[4:0]=IR[4:0];

				
		/*IR	[5:0]	offset6*/
			wire	[15:0]	offset6;
			assign	offset6[15:6]={10{IR[5]}};
			assign	offset6[5:0]=IR[5:0];

		/*IR	[8:0]	PCoffset9*/
			wire	[15:0]	PCoffset9;
			assign	PCoffset9[15:9]={7{IR[8]}};
			assign	PCoffset9[8:0]=IR[8:0];
		
		/*IR	[10:0]	PCoffset11*/
			wire	[15:0]	PCoffset11;
			assign	PCoffset11[15:11]={5{IR[10]}};
			assign	PCoffset11[10:0]=IR[10:0];
			
	/*IR	ZEXT*/
		/*IR	[7:0]		trapvect8*/
			wire	[15:0]	trapvect;
			assign	trapvect[15:8]=8'b00000000;
			assign	trapvect[7:0]=IR[7:0];
				
	/*REGFILE*/
		/*REGFILE input Number from DATABUS*/
			wire	[15:0]	REGin;
			assign	REGin=DATABUS;
		/*SR1 MUX Logic*/
			reg	[2:0]	SR1;
			parameter
				SR1_11_9=2'b00,
				SR1_8_6=2'b01,
				SR1_SP=2'b10,
				SR1_DEF=2'b11;
			always@(*) begin
				case(SR1MUX)
					SR1_11_9:	SR1=	IR[11:9];
					SR1_8_6 :	SR1=	IR[8:6];
					SR1_SP  :	SR1=	3'b110;
					default :	SR1= IR[11:9];   //ATTENTION:THIS LINE SHOULD NEVER BE USED 
				endcase
			end
			
		/*SR2 MUX Logic*/
			wire	[2:0]	SR2;
			assign		SR2=IR[2:0];			//SR2 MUST COME FROM INST[2:0]
			
		/*DR MUX Logic*/
			reg	[2:0]	DR;
			parameter
				DR_11_9=2'b00,
				DR_R7=2'b01,
				DR_SP=2'b10,
				DR_DEF=2'b11;
	
			always@(*) begin
				case(DRMUX)
					DR_11_9	:	DR=	IR[11:9];
					DR_R7		:	DR=	3'b111;
					DR_SP		:	DR=	3'b110;
					default	:	DR=	IR[11:9];
				endcase
			end
		
		/*specialize a regfile */
			LC3_REGFILE	regfile0(
				.clk(clk),
				.REGin(REGin),
				.DR(DR),
				.LD_REG(LD_REG),
				.SR1(SR1),
				.SR2(SR2),
				.SR1out(SR1out),
				.SR2out(SR2out)
			);
	
	
	/*ALU*/
		/*ALUout output to DATABUS controled by GateALU*/
			wire	[15:0]	ALUout;
			
		/*NUMA FROM REGFILE SR1*/
			wire	[15:0]	NUMA;
			assign	NUMA=SR1out;
			
		/*NUMB MUX Logic*/
			wire	[15:0]	NUMB;
			wire				SR2MUX;
			assign	SR2MUX=IR[5];
			assign	NUMB=(SR2MUX?imm5:SR2out);
			
		/*specialize an ALU*/
			LC3_ALU	alu0(
				.NUMA(NUMA),
				.NUMB(NUMB),
				.ALUK(ALUK),
				.ALUout(ALUout)
			);
			
		
	/*IR*/
		/*IRin from DATABUS*/
			wire	[15:0]	IRin;
			assign	IRin=	DATABUS;
			
		/*IR Sequential Logic --LOAD IR*/
			always@(posedge clk)begin
				if(reset)
					IR<=16'h0000;
				else if(LD_IR)
					IR<=IRin;
			end
			

		
		
	/*ADDRESS*/
		/*ADDR1	MUX	LOGIC*/
			wire	[15:0]	ADDR1;
			assign	ADDR1=(ADDR1MUX?SR1out:PC);
		
		/*ADDR2	MUX	LOGIC*/
			reg	[15:0]	ADDR2;
			always@(*) begin
				case (ADDR2MUX)
					2'b00:	ADDR2=16'b0000000000000000;
					2'b01:	ADDR2=offset6;
					2'b10:	ADDR2=PCoffset9;
					2'b11:	ADDR2=PCoffset11;
				endcase 
			end
		
		/*ADDRADDRES*/
			wire	[15:0]	ADDR_ADDER_RES;
			assign	ADDR_ADDER_RES=ADDR1+ADDR2;
			
		/*MAR		MUX	LOGIC*/
			wire	[15:0]	MARout;
			assign	MARout=(MARMUX?ADDR_ADDER_RES:trapvect);
			
		/*PC		BUS	IN*/
			wire	[15:0]	PCbus_in;
			assign	PCbus_in=DATABUS;
			
		/*PC+1*/
			wire	[15:0]	PCadd1;
			assign	PCadd1=PC+1;
			
		/*PC-1*/
			wire	[15:0]	PCsubtract1;
			assign	PCsubtract1=PC-1;
			
		/*PC sequential logic --LOAD PC*/
			always@(posedge clk) 
				if (reset)	PC<=16'h200;
				else if (LD_PC) begin
				case (PCMUX)
					2'b00  :	PC<=PCadd1;
					2'b01	 :	PC<=PCbus_in;
					2'b10	 :	PC<=ADDR_ADDER_RES;
					default:	PC<=PCadd1;				//ATTENTION:THIS LINE SHOULD NEVER BE USED 
				endcase
				end
	

			
			
			
/*PSR AND INTERRUPTION */
	
	/*PSR INPUT from DATABUS*/
			wire	[15:0]	PSR;
			assign	PSR=DATABUS;

			
	/*CC*/
		/*CC NUMBER in from DATABUS*/
			wire	[15:0]	CCNumber;
			assign	CCNumber=DATABUS;
		
		/*PSR	[2:0] from DATABUS present CC*/
		
		/*CC	sequential logic --LOAD	CC*/
			always@(posedge clk) 
			if (reset)
				CC<=3'b000;
			else if (LD_CC) begin
				case (PSRMUX) 
					0:begin
						if(CCNumber<0)
							CC<=3'b100;
						else if (CCNumber==0)
							CC<=3'b010;
						else if (CCNumber>0)
							CC<=3'b001;
					  end
					1:		CC<=PSR[2:0];
				endcase
			end
			
			
	/*BEN*/
		/*BEN register*/
			reg			BEN;
		/*BEN Sequential Logic --LOAD BEN*/
			always@(posedge clk) begin
				if(reset)
					BEN<=0;
				else if(LD_BEN)
					BEN<=( (IR[11]&CC[2]) |(IR[10]&CC[1]) | (IR[9]&CC[0]) );
			end
		
	/*Priv*/
		/*PSR	[15]	from DATABUS present	Priv*/
		
		/*Priv sequential logic --LOAD Priv*/
			always@(posedge clk) if (reset)
				Priv<=1;
			else if (LD_Priv) begin
				case (PSRMUX)
					0:Priv<=Set_Priv;
					1:Priv<=PSR[15];
				endcase
			end
			
	/*Priority*/
		/*PSR	[10:8] from DATABUS present Priority*/
		
		/*Priority sequential logic --LOAD Priority*/
			always@(posedge clk) 
			if (reset)
				Priority<=3'b00;
			else if (LD_Priority) begin
				case (PSRMUX)
					0:Priority<=Int_Priority;
					1:Priority<=PSR[10:8];
				endcase
			end
		
	/*INT*/
		/*Priority A B*/
			wire	[2:0]	PriorityA;
			wire	[2:0]	PriorityB;
			assign	PriorityA=Int_Priority;
			assign	PriorityB=Priority;
		
		/*INT signal*/
			assign	INT=(PriorityA>PriorityB);
			
	/*Vector*/
		/*Vector output*/
			wire	[15:0]	Vector_out;
			assign	Vector_out[15:8]=8'b00000001;
			assign	Vector_out[7:0]=Vector;
		
		/*Vector sequential logic --LOAD Vector*/
			always@(posedge clk)if (LD_Vector) begin
				case (VectorMUX)
					2'b00  :	Vector<=INTV;
					2'b01  :	Vector<=8'b00000000;
					2'b10	 :	Vector<=8'b00000001;
					default:	Vector<=INTV;					//ATTENTION:THIS LINE SHOULD NEVER BE USED 
				endcase 
			end
			
	/*STACK*/
		/*SAVE-SP sequential logic*/
			always@(posedge clk) begin
				if	(reset)	begin
					SavedSSP<=16'h3000;
					SavedUSP<=16'hf000;
				end
				else begin
				if (LD_SavedUSP)
					SavedUSP<=SR1out;
				if	(LD_SavedSSP)
					SavedSSP<=SR1out;
				end
			end
			
		/*SP	MUX	LOGIC*/
			reg	[15:0]	SPout;
			always@(*) begin
				case (SPMUX)
					2'b00:	SPout=SR1out+1;
					2'b01:	SPout=SR1out-1;
					2'b10:	SPout=SavedSSP;
					2'b11:	SPout=SavedUSP;
				endcase
			end
			
			
		
/*GATE CONTROL*/
		parameter	Z16=16'bzzzzzzzzzzzzzzzz;
		/*output wires linked to DATABUS*/
//		wire	[15:0]	SPbus_out;	
			assign	SPbus_out=(GateSP?SPout:Z16);
//		wire	[15:0]	ALUbus_out;
			assign	ALUbus_out=(GateALU?ALUout:Z16);
//		wire	[15:0]	PSRbus_out;
			wire	[15:0]	PSRout;
			assign	PSRout[2:0]=CC;
			assign	PSRout[7:3]=5'b00000;
			assign	PSRout[10:8]=Priority;
			assign	PSRout[14:11]=4'b0000;
			assign	PSRout[15]=Priv;
			assign	PSRbus_out=(GatePSR?PSRout:Z16);
//		wire	[15:0]	PCbus_out;
			assign	PCbus_out=(GatePC?PC:Z16);
//		wire	[15:0]	PCsubtract1_bus_out;
			assign	PCsubtract1_bus_out=(GatePCsubtract1?PCsubtract1:Z16);
//		wire	[15:0]	MARbus_out;
			assign	MARbus_out=(GateMARMUX?MARout:Z16);
//		wire	[15:0]	Vector_bus_out;
			assign	Vector_bus_out=(GateVector?Vector_out:Z16);
	
/*OUTPUT*/
		assign	Priv_reg=Priv;
		assign	IR_reg=IR;
		assign	BEN_reg=BEN;
		
		
endmodule
