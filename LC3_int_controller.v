`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:12:38 03/22/2014 
// Design Name: 
// Module Name:    LC3_int_controller 
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
module LC3_int_controller(
		input					KB_INT,
		output		[2:0]	INT_Priority,
		output		[7:0]	INTV
    );
	 
	 assign	INTV=8'h80;
	 
	 assign	INT_Priority=(KB_INT?3'b001:3'b000);


endmodule
