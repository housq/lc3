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
module tb_lc3_top;


reg	clk;
reg	reset;
reg	LD_char;
reg	[7:0]	I_char;
wire	[15:0]	DDR;
wire				WR_DDR;


initial
	begin
		clk=0;
		reset=1;
		LD_char=0;
		I_char=8'h30;
	end
	
initial
	begin
		#4	reset=0;
		#2 LD_char=1;
		#2 LD_char=0;
	end

initial
	forever
		#1	clk=~clk;

LC3_computer_top	lc3(
		.clk						(clk),
		.reset					(reset),
		
		.LD_char					(LD_char),
		.I_char					(I_char),
		.DDR						(DDR),
		.WR_DDR					(WR_DDR)
    );
	 
endmodule