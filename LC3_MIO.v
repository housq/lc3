`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:03:23 03/21/2014 
// Design Name: 
// Module Name:    LC3_MIO 
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
module LC3_MIO(
		input						clk,
		input						reset,
		input			[15:0]	DATABUS,
		input						MIO_EN,
		input						R_W,
		input						LD_MAR,
		input						LD_MDR,
		input						GateMDR,
		output		[15:0]	MDRbus_out,
		output					KB_INT,
		output					R,
		
		input						LD_char,
		input			[7:0]		I_char,
		output		[15:0]	DDR,
		output					WR_DDR
    );
	 
	 /*internal wires*/
		wire		[1:0]	INMUX;
		wire				LD_KBSR;
		wire				MEM_EN;
		wire				LD_DSR;
		wire				LD_DDR;
		wire				RD_KBDR;
		
		wire		[15:0]	MEMout;
		wire		[15:0]	KBSR;
		wire		[15:0]	KBDR;
		wire		[15:0]	DSR;
		
	 
	 /*MAR*/
		reg		[15:0]	MAR;
		wire		[15:0]	MARin;
		assign	MARin=DATABUS;
		/*Sequential Logic*/
			always@(posedge clk) if (LD_MAR) 
				MAR<=MARin;
	
	
	/*MDR*/
		reg		[15:0]	MDR;
		wire		[15:0]	MDRin;
		reg		[15:0]	MIOout;
		assign				MDRin=DATABUS;
		always@(posedge clk) if (LD_MDR) begin
			if(MIO_EN)
				MDR<=MIOout;
			else 
				MDR<=MDRin;
		end
		
	
	/*ADDR CTL LOGIC*/
		LC3_MIO_ADDRCTL	inst_addrctl(
									.clk			(clk),
									.ADDR			(MAR),
									.MIO_EN		(MIO_EN),
									.R_W			(R_W),
		
									.INMUX		(INMUX),
									.MEM_EN		(MEM_EN),
									.LD_KBSR		(LD_KBSR),
									.LD_DSR		(LD_DSR),
									.LD_DDR		(LD_DDR),
									.RD_KBDR		(RD_KBDR),
									.R				(R)
								);
	
	/*MEMORY*/
		LC3_MEMORY	inst_memory(
						.clk			(clk),
		
						.ADDR			(MAR),
						.DATAin		(MDR),
						.R_W			(R_W),
						.MEM_EN		(MEM_EN),
		
						.MEMout		(MEMout)
						);
						
	/*INPUT	KEYBOARD	REG*/
		LC3_keyboard_reg	inst_keyboard_reg(
									.clk			(clk),
									.reset		(reset),
									
									.LD_KBSR		(LD_KBSR),
									.RD_KBDR		(RD_KBDR),
									.DATA			(MDR),
		
									.I_char		(I_char),
									.LD_char		(LD_char),
		
									.KBDR			(KBDR),
									.KBSR			(KBSR),
									.KB_INT		(KB_INT)
								);
								
	/*OUTPUT	SCREEN	REG*/
		LC3_screen_reg		insr_screen_reg(
											.clk			(clk),
											.LD_DDR		(LD_DDR),
											.LD_DSR		(LD_DSR),
											.DATA			(MDR),
											.DSR			(DSR),
											.DDR			(DDR),
											.WR_DDR		(WR_DDR)
								);
								
	/*INMUX LOGIC*/
		always@(*)	begin
			case (INMUX)
				2'b00:	MIOout=KBSR;
				2'b01:	MIOout=KBDR;
				2'b10:	MIOout=DSR;
				2'b11:	MIOout=MEMout;
			endcase
		end

	/*GATE CONTROL*/
		assign	MDRbus_out=(GateMDR?MDR:16'bz);
		
endmodule
