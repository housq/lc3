`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:35:27 03/22/2014 
// Design Name: 
// Module Name:    LC3_keyboard_reg 
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
module LC3_keyboard_reg(
		input						clk,
		input						reset,
		
		input						LD_KBSR,
		input						RD_KBDR,
		input			[15:0]	DATA,
		
		input			[7:0]		I_char,
		input						LD_char,
		
		output	reg[15:0]	KBDR,
		output	reg[15:0]	KBSR,
		output					KB_INT
    );
		
		always@(posedge	clk)	if (reset)	begin
			KBSR<=16'b0;
			KBDR<=16'b0;
		end
		else begin
			if(LD_char)	begin
				KBDR<={8'b0,I_char};
				KBSR[15]<=1'b1;
			end else	if(RD_KBDR)
				KBSR[15]<=1'b0;
			
			if(LD_KBSR)
				KBSR[14:0]<=DATA[14:0];
			
		end
		

		assign	KB_INT=KBSR[15]&KBSR[14];

endmodule
