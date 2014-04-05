`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:36:05 03/22/2014 
// Design Name: 
// Module Name:    LC3_RAMblock 
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
module LC3_RAMblock(
		input [15 : 0] a,
		input [15 : 0] d,
		input clk,
		input we,
		output [15 : 0] spo
    );
	 
	 (*  ram_init_file = "LC3MEM.mif " *)reg	[15:0]	block	[65535:0];
	 
	 initial block[16'h002]=16'h700;
	 initial block[16'h180]=16'h200;
	 
	 initial block[16'h200]=16'b0010000000000001; //LD R0,#2
	 initial block[16'h201]=16'b1100000000000000; //JMP R0
	 initial block[16'h202]=16'h203;
	 initial block[16'h203]=16'b1010001000000011; //LDI R1,#3
	 initial block[16'h204]=16'b0110010001000000; //LDR R2,R1,#0
	 initial block[16'h205]=16'b0100000010000000; //JSRR R2
	 initial block[16'h206]=16'b1111000000000010; //TRAP x02
	 initial block[16'h207]=16'h208;					 
	 initial block[16'h208]=16'h209;
	 initial block[16'h209]=16'h20a;
	 initial block[16'h20a]=16'b1100000111000000; //RET
	 
	 //set keyboard interrupt
	 initial block[16'h6fe]=16'b0100000000000000;
	 initial block[16'h6ff]=16'hfe00;				 //KBSR
	 initial block[16'h700]=16'b0010011111111101; //LD  R3,#-3
	 initial block[16'h701]=16'b1011011111111101; //STI R3,#-3
	 initial block[16'h702]=16'b1100000111000000; //RET
	 
	 

	 

	 always@(posedge clk)	begin
		if(we)
			block[a]<=d;
	 end
	 
	 assign	spo=block[a];

endmodule
