`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:22:03 03/22/2014 
// Design Name: 
// Module Name:    LC3_MEMORY 
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
module LC3_MEMORY(
		input							clk,
		
		input				[15:0]	ADDR,
		input				[15:0]	DATAin,
		input							R_W,
		input							MEM_EN,
		
		output			[15:0]	MEMout
    );
	 
LC3_RAMblock inst_block(
  .a(ADDR), // input [15 : 0] a
  .d(DATAin), // input [15 : 0] d
  .clk(clk), // input clk
  .we(MEM_EN&R_W), // input we
  .spo(MEMout) // output [15 : 0] spo
);


endmodule
