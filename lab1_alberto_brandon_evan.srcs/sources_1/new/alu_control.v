`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2022 12:29:38 PM
// Design Name: 
// Module Name: twelve_one_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_control(
    input[3:0] sel,
    output a_sel,
    output b_sel,
    output [1:0] op,
    output inc_dec
    );
    
    // a-sel, b-sel, op, set
    // op codes and: 00, or: 01, add: 10, slt (less): 11
    /*
    localparam SUB = 5'b01100;
    localparam ADD = 5'b00100;
    localparam OR = 5'b00010;
    localparam AND = 5'b00000;
    localparam DEC = 5'b01100;
    localparam INC = 5'b00100;
    localparam INV = 5'b10010;
    localparam ASL = 5'b11100;
    localparam ASR = 5'b11101;
    localparam LSL = 5'b11110;
    localparam LSR = 5'b11111;
    localparam SLT = 5'b00111;
    */
    localparam SUB = 5'b01100;
    localparam ADD = 5'b00100;
    localparam OR = 5'b00010;
    localparam AND = 5'b00000;
    localparam DEC = 5'b01101;
    localparam INC = 5'b00101;
    localparam INV = 5'b10010;
    localparam ASL = 5'b11000;
    localparam ASR = 5'b11010;
    localparam LSL = 5'b11100;
    localparam LSR = 5'b11110;
    localparam SLT = 5'b01110;
    
    // layer 0
    wire [4:0] layer_0_mux_output_0;
    five_bit_two_one_mux layer_0_mux_0 (.sel(sel[0]), .a(SUB), .b(ADD), .x(layer_0_mux_output_0));
        
    wire [4:0] layer_0_mux_output_1;
    five_bit_two_one_mux layer_0_mux_1 (.sel(sel[0]), .a(OR), .b(AND), .x(layer_0_mux_output_1));
    
    wire [4:0] layer_0_mux_output_2;
    five_bit_two_one_mux layer_0_mux_2 (.sel(sel[0]), .a(DEC), .b(INC), .x(layer_0_mux_output_2));
    
    wire [4:0] layer_0_mux_output_3;
    five_bit_two_one_mux layer_0_mux_3 (.sel(sel[0]), .a(INV), .b(0), .x(layer_0_mux_output_3));
    
    wire [4:0] layer_0_mux_output_4;
    five_bit_two_one_mux layer_0_mux_4 (.sel(sel[0]), .a(LSL), .b(SLT), .x(layer_0_mux_output_4));
    
    wire [4:0] layer_0_mux_output_5;
    five_bit_two_one_mux layer_0_mux_5 (.sel(sel[0]), .a(LSR), .b(0), .x(layer_0_mux_output_5));
    
    wire [4:0] layer_0_mux_output_6;
    five_bit_two_one_mux layer_0_mux_6 (.sel(sel[0]), .a(ASL), .b(0), .x(layer_0_mux_output_6));
        
    wire [4:0] layer_0_mux_output_7;
    five_bit_two_one_mux layer_0_mux_7 (.sel(sel[0]), .a(ASR), .b(0), .x(layer_0_mux_output_7));
    
    // layer 1

    wire [4:0] layer_1_mux_output_0;
    five_bit_two_one_mux layer_1_mux_0 (.sel(sel[1]), .a(layer_0_mux_output_0), .b(layer_0_mux_output_1), .x(layer_1_mux_output_0));
        
    wire [4:0] layer_1_mux_output_1;
    five_bit_two_one_mux layer_1_mux_1 (.sel(sel[1]), .a(layer_0_mux_output_2), .b(layer_0_mux_output_3), .x(layer_1_mux_output_1));
    
    wire [4:0] layer_1_mux_output_2;
    five_bit_two_one_mux layer_1_mux_2 (.sel(sel[1]), .a(layer_0_mux_output_4), .b(layer_0_mux_output_5), .x(layer_1_mux_output_2));
    
    wire [4:0] layer_1_mux_output_3;
    five_bit_two_one_mux layer_1_mux_3 (.sel(sel[1]), .a(layer_0_mux_output_6), .b(layer_0_mux_output_7), .x(layer_1_mux_output_3));
        
    // layer 2
    
    wire [4:0] layer_2_mux_output_0;
    five_bit_two_one_mux layer_2_mux_0 (.sel(sel[2]), .a(layer_1_mux_output_0), .b(layer_1_mux_output_1), .x(layer_2_mux_output_0));
            
    wire [4:0] layer_2_mux_output_1;
    five_bit_two_one_mux layer_2_mux_1 (.sel(sel[2]), .a(layer_1_mux_output_2), .b(layer_1_mux_output_3), .x(layer_2_mux_output_1));
    
    // layer 3
        
    wire [4:0] mux_output;
    five_bit_two_one_mux layer_3_mux_0 (.sel(sel[3]), .a(layer_2_mux_output_0), .b(layer_2_mux_output_1), .x(mux_output));
    
    assign a_sel = mux_output[4];
    assign b_sel = mux_output[3];
    assign op = mux_output[2:1];
    assign inc_dec = mux_output[0];
endmodule