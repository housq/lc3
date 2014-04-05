`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:47:55 03/21/2014 
// Design Name: 
// Module Name:    LC3_MIO_ADDRCTL 
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
module LC3_MIO_ADDRCTL(
		input						clk,
		input			[15:0]	ADDR,
		input						MIO_EN,
		input						R_W,
		
		output	reg[1:0]		INMUX,
		output	reg			MEM_EN,
		output	reg			LD_KBSR,
		output	reg			LD_DSR,
		output	reg			LD_DDR,
		output	reg			RD_KBDR,
		output	reg			R
		
    );
		wire		WR;
		assign	WR=MIO_EN&R_W;
		parameter	
			ADDR_KBSR=16'hfe00,
			ADDR_KBDR=16'hfe02,
			ADDR_DSR= 16'hfe04,
			ADDR_DDR= 16'hfe06;
		always@(*) begin
			case (ADDR)
				ADDR_KBSR:
					begin
						INMUX=2'b00;
						{LD_KBSR,LD_DSR,LD_DDR}={WR,1'b0,1'b0};
						MEM_EN=1'b0;
						RD_KBDR=1'b0;
					end
				ADDR_KBDR:
					begin
						INMUX=2'b01;
						{LD_KBSR,LD_DSR,LD_DDR}=3'b0;
						MEM_EN=1'b0;
						RD_KBDR=1'b1;
					end
				ADDR_DSR:
					begin
						INMUX=2'b10;
						{LD_KBSR,LD_DSR,LD_DDR}={1'b0,WR,1'b0};
						MEM_EN=1'b0;
						RD_KBDR=1'b0;
					end
				ADDR_DDR:
					begin
						INMUX=2'bxx;
						{LD_KBSR,LD_DSR,LD_DDR}={1'b0,1'b0,WR};
						MEM_EN=1'b0;
						RD_KBDR=1'b0;
					end
				default:
					begin
						INMUX=2'b11;
						{LD_KBSR,LD_DSR,LD_DDR}=3'b0;
						MEM_EN=MIO_EN;
						RD_KBDR=1'b0;
					end
			endcase
		end
					
/*READY	SIGNAL*/
		reg	[3:0]		cs;
		reg	[3:0]		ns;
		always@(*)	begin
			if(!MIO_EN)
				ns=4'd0;
			else if(cs==0)	begin
				if(MEM_EN)
					ns=4'd14;
				else
					ns=4'd15;
			end
			else 
				ns=cs+1;
		end
		
		always@(posedge	clk)	begin
			cs<=ns;
		end
		
		always@(posedge	clk)	begin
			if(MIO_EN&(ns==4'd15))
				R<=1'b1;
			else
				R<=1'b0;
		end	


endmodule
