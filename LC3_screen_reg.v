`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:51:26 03/22/2014 
// Design Name: 
// Module Name:    LC3_screen_reg 
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

module LC3_screen_reg(
		input						clk,
		input						LD_DDR,
		input						LD_DSR,
		input			[15:0]	DATA,
		
		output	reg[15:0]	DSR,
		output	reg[15:0]	DDR,
		output	reg			WR_DDR
    );
/*TODO This LC3 Screen Module does not contain the function of screen interrupt*/
		
		always@(posedge clk)	begin
			if(LD_DDR)	begin
				DDR<=DATA;
				WR_DDR<=1'b1;
			end else 
				WR_DDR<=1'b0;
			if(LD_DSR)
				DSR[14:0]<=DATA[14:0];
			
			DSR[15]<=1'b1;
		end

endmodule
