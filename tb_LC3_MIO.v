`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:53:52 03/22/2014 
// Design Name: 
// Module Name:    tb_LC3_MIO 
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
module tb_LC3_MIO;

reg				CLK;
reg				reset;
reg	[15:0]	DATAin;
reg				MIO_EN;
reg				R_W;
reg				LD_MAR;
reg				LD_MDR;
reg				GateMDR;
wire	[15:0]	MDRbus_out;
wire				KB_INT;
wire				R;

initial
	begin
		reset=1;
		CLK=1;
		DATAin=16'b0;
		MIO_EN=0;
		R_W=0;
		LD_MAR=0;
		LD_MDR=0;
		GateMDR=0;
	end
	
initial
	begin
		#2	reset=0;
		#2	DATAin=16'h0100;
			LD_MAR=1;
		#2	LD_MAR=0;
		#2	LD_MDR=1;
			MIO_EN=1;
			R_W=0;
			GateMDR=1;
		#20
			MIO_EN=0;
			R_W=0;
			DATAin=16'h000f;
			LD_MAR=1;
		#2	LD_MAR=0;
			MIO_EN=1;
			
	end
	
initial
	forever
		#1	CLK=~CLK;

LC3_MIO	tb_mio(
		.clk						(CLK),
		.reset					(reset),
		.DATABUS					(DATAin),
		.MIO_EN					(MIO_EN),
		.R_W						(R_W),
		.LD_MAR					(LD_MAR),
		.LD_MDR					(LD_MDR),
		.GateMDR					(GateMDR),
		.MDRbus_out				(MDRbus_out),
		.KB_INT					(KB_INT),
		.R							(R),
		
		.LD_char					(LD_char),
		.I_char					(I_char),
		.DDR						(DDR),
		.WR_DDR					(WR_DDR)
    );

endmodule
