`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:33:40 03/08/2014 
// Design Name: 
// Module Name:    LC3_REGFILE 
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
module LC3_REGFILE(
		input						clk,
		input			[15:0]	REGin,
		input			[2:0]		DR,
		input						LD_REG,
		input		[2:0]		SR1,
		input			[2:0]		SR2,
		output		[15:0]	SR1out,
		output		[15:0]	SR2out
    );
	/*internal regs R0~R7*/
	reg	[15:0]		R[7:0];
	
	/*Sequential logic*/
	always@(posedge clk) begin
		if (LD_REG)
			R[DR]<=REGin;
	end
	
	/*Combinational logic*/
	assign	SR1out=R[SR1];
	assign	SR2out=R[SR2];
	


endmodule
