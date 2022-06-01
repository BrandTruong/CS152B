`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
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
module vga_top(
	input wire clk,			//master clock = 50MHz
	input wire clr,			//right-most pushbutton for reset
	output wire [6:0] seg,	//7-segment display LEDs
	output wire [3:0] an,	//7-segment display anode enable
	output wire dp,			//7-segment display decimal point
	output wire [3:0] red,	//red vga output - 3 bits
	output wire [3:0] green,//green vga output - 3 bits
	output wire [3:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync,			//vertical sync out
	//inout [7:0] JB_kypd,
	input [15:0] keyout
	);

// 7-segment clock interconnect
wire segclk;
// VGA display clock interconnect
wire dclk;

/*
wire [3:0] Decode;
assign keyout = Decode;
// disable the 7-segment decimal points
assign dp = 1;


kypd U4(
    .clk(clk),
    .row(JB_kypd[7:4]),
    .col(JB_kypd[3:0]),
    .key(Decode)
    );
*/
// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(clr),
	.segclk(segclk),
	.dclk(dclk)
	);

// 7-segment display controller
segdisplay U2(
	.segclk(segclk),
	.clr(clr),
	.seg(seg),
	.an(an)
	);

// VGA controller
vga640x480 U3(
    .data(keyout),
	.dclk(dclk),
	.clr(clr),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue)
	);

endmodule

