`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:53:53 03/08/2014 
// Design Name: 
// Module Name:    LC3_ALU 
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
module LC3_ALU(
		input				[15:0]	NUMA,
		input				[15:0]	NUMB,
		input				[1:0]	ALUK,
		output	reg	[15:0]	ALUout
    );
		always@(NUMA or NUMB or ALUK) begin
			case (ALUK)
				2'b00:	ALUout<=NUMA+NUMB;
				2'b01:	ALUout<=NUMA&NUMB;
				2'b10:	ALUout<=~NUMA;
				2'b11:	ALUout<=NUMA;
			endcase
		end
			


endmodule
