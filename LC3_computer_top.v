`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:44:23 03/16/2014 
// Design Name: 
// Module Name:    LC3_computer_top 
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
module LC3_computer_top(
		input				clk,
		input				reset,
		
		input						LD_char,
		input			[7:0]		I_char,
		output		[15:0]	DDR,
		output					WR_DDR
    );
		wire		[39:0]	CONTROL;
	 
	 
		wire		[15:0]		DATABUS;
	
	/*REGFILE-RELATIVE INPUT*/
		wire		[1:0]		SR1MUX;
		wire		[1:0]		DRMUX;
		
	/*ALU-RELATIVE INPUT*/
		wire		[1:0]		ALUK;
		wire					SR2MUX;
		
	/*ADDRESS-RELATIVE INPUT*/
		wire					ADDR1MUX;
		wire		[1:0]		ADDR2MUX;
		wire		[1:0]		PCMUX;
		wire					MARMUX;
		
	/*PSR-RELATIVE	INPUT*/
		wire					Set_Priv;
		wire					PSRMUX;
		
	/*INT-RELATIVE	INPUT*/
		wire		[7:0]		INTV;
		wire		[1:0]		VectorMUX;
		wire		[1:0]		SPMUX;
		wire		[2:0]		Int_Priority;
		
	/*GATES*/
		wire					GateALU;
		wire					GatePSR;
		wire					GateSP;
		wire					GateVector;
		wire					GateMARMUX;
		wire					GatePC;
		wire					GatePCsubtract1;
		
	/*LOAD SIGNAL*/
		wire					LD_REG;
		wire					LD_IR;
		wire					LD_PC;
		wire					LD_CC;
		wire					LD_Priv;
		wire					LD_Priority;
		wire					LD_Vector;
		wire					LD_SavedUSP;
		wire					LD_SavedSSP;
		
		
	/*STATE MACHINE OUTPUT*/
		wire				INT;
		wire	[2:0]		CC;
		wire	[15:0]	IR;
		wire				Priv;
		wire				BEN;
		
		assign	Set_Priv=1'b0;
		assign	R_W=CONTROL[1];
		assign	MIO_EN=CONTROL[2];
		assign	ALUK=CONTROL[4:3];
		assign	PSRMUX=CONTROL[5];
		assign	VectorMUX=CONTROL[7:6];
		assign	MARMUX=CONTROL[8];
		assign	SPMUX=CONTROL[10:9];
		assign	ADDR2MUX=CONTROL[12:11];
		assign	ADDR1MUX=CONTROL[13];
		assign	SR1MUX=	CONTROL[15:14];
		assign	DRMUX=	CONTROL[17:16];
		assign	PCMUX=	CONTROL[19:18];
		assign	GateSP=	CONTROL[20];
		assign	GatePSR= CONTROL[21];
		assign	GatePCsubtract1=CONTROL[22];
		assign	GateVector=CONTROL[23];
		assign	GateMARMUX=CONTROL[24];
		assign	GateALU=	CONTROL[25];
		assign	GateMDR=	CONTROL[26];
		assign	GatePC=	CONTROL[27];
		assign	LD_Vector=CONTROL[28];
		assign	LD_SavedUSP=CONTROL[29];
		assign	LD_SavedSSP=CONTROL[30];
		assign	LD_Priv	=CONTROL[31];
		assign	LD_Priority=CONTROL[32];
		assign	LD_PC		=CONTROL[33];
		assign	LD_CC		=CONTROL[34];
		assign	LD_REG	=CONTROL[35];
		assign	LD_BEN	=CONTROL[36];
		assign	LD_IR		=CONTROL[37];
		assign	LD_MDR	=CONTROL[38];
		assign	LD_MAR	=CONTROL[39];
		
/*instance of StateMachine*/
		wire					R;
		
LC3_FSM		instance_fsm(
									.clk		(clk),
									.reset	(reset),
									.Priv		(Priv),
									.BEN		(BEN),
									.IR		(IR[15:11]),
									.R			(R),
									.INT		(INT),
		
									.CONTROL	(CONTROL)
    );
		
		
		
/*instance of datapath*/		
		LC3_datapath	inst_datapath0(
	/*GENERAL INPUT*/
		.clk(clk),
		.reset(reset),
		.DATABUS(DATABUS),
	
	/*REGFILE-RELATIVE INPUT*/
		.SR1MUX(SR1MUX),
		.DRMUX(DRMUX),
		
	/*ALU-RELATIVE INPUT*/
		.ALUK(ALUK),
		
	/*ADDRESS-RELATIVE INPUT*/
		.ADDR1MUX(ADDR1MUX),
		.ADDR2MUX(ADDR2MUX),
		.PCMUX(PCMUX),
		.MARMUX(MARMUX),
		
	/*PSR-RELATIVE	INPUT*/
		.Set_Priv(Set_Priv),
		.PSRMUX(PSRMUX),
		
	/*INT-RELATIVE	INPUT*/
		.INTV(INTV),
		.VectorMUX(VectorMUX),
		.SPMUX(SPMUX),
		.Int_Priority(Int_Priority),
		
	/*GATES*/
		.GateALU(GateALU),
		.GatePSR(GatePSR),
		.GateSP(GateSP),
		.GateVector(GateVector),
		.GateMARMUX(GateMARMUX),
		.GatePC(GatePC),
		.GatePCsubtract1(GatePCsubtract1),
		
	/*LOAD SIGNAL*/
		.LD_BEN(LD_BEN),
		.LD_REG(LD_REG),
		.LD_IR(LD_IR),
		.LD_PC(LD_PC),
		.LD_CC(LD_CC),
		.LD_Priv(LD_Priv),
		.LD_Priority(LD_Priority),
		.LD_Vector(LD_Vector),
		.LD_SavedUSP(LD_SavedUSP),
		.LD_SavedSSP(LD_SavedSSP),
		
	/*DATABUS OUTPUT*/
		.ALUbus_out	(DATABUS),
		.PSRbus_out (DATABUS),
		.SPbus_out 	(DATABUS),
		.Vector_bus_out(DATABUS),
		.MARbus_out	(DATABUS),
		.PCbus_out(DATABUS),
		.PCsubtract1_bus_out(DATABUS),
		
	/*STATE MACHINE OUTPUT*/
		.INT(INT),
		.IR_reg(IR),
		.Priv_reg(Priv),
		.BEN_reg(BEN)

    );

/*instance of MIO*/
LC3_MIO inst_memory_io(
									.clk			(clk),
									.reset		(reset),
									.DATABUS		(DATABUS),
									.MIO_EN		(MIO_EN),
									.R_W			(R_W),
									.LD_MAR		(LD_MAR),
									.LD_MDR		(LD_MDR),
									.GateMDR		(GateMDR),
									.MDRbus_out	(DATABUS),
									.KB_INT		(KB_INT),
									.R				(R),
		
									.LD_char		(LD_char),
									.I_char		(I_char),
									.DDR			(DDR),
									.WR_DDR		(WR_DDR)
    );
	 
/*instance of interrupt controler*/
LC3_int_controller inst_int_controller(
								.KB_INT		(KB_INT),
								.INT_Priority	(Int_Priority),
								.INTV			(INTV)
    );
	 
		


endmodule
