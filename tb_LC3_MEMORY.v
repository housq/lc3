`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:16:46 03/22/2014 
// Design Name: 
// Module Name:    tb_LC3_MEMORY 
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
module tb_LC3_MEMORY;
	 reg					CLK;
	 reg	[15:0]		ADDR;
	 reg	[15:0]		DATA;
	 reg					R_W;
	 reg					MEM_EN;
	 
	 wire	[15:0]		MEMout;
	 
initial
	begin
		MEM_EN=1;
		R_W=0;
		ADDR=16'b00000001;
		DATA=16'b10100101;
	end
	
initial
	begin
		#10	R_W=1;
		#10	R_W=0;
				ADDR=16'b00000010;
		#2		DATA=16'b11111110;
		#2		R_W=1;
		#10	R_W=0;
				ADDR=16'b00000001;
		#10	ADDR=16'b00000010;
	end
		
	LC3_MEMORY		tb_mem(
				.clk		(CLK),
		
				.ADDR		(ADDR),
				.DATAin	(DATA),
				.R_W		(R_W),
				.MEM_EN	(MEM_EN),
		
				.MEMout	(MEMout)
			);


endmodule
