`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2022 12:13:55 PM
// Design Name: 
// Module Name: testbench_16bit_alu
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


module testbench_16bit_alu(

    );
    reg [15:0] a;
    reg [15:0] b;
    reg [3:0] alu_control;
    wire overflow;
    wire zero;
    wire [15:0] result;
        
    sixteen_bit_alu sixteen_bit_alu(
        .a(a),
        .b(b),
        .alu_ctrl(alu_control),
        .overflow(overflow),
        .zero(zero),
        .result(result)
        );
     
     initial
     begin
        
        // subtraction
        // subtacting positive
        a = 100;
        b = 96;
        alu_control = 4'b0000;
        #10
        // subtraction negative
        a = 95;
        b = 97;
        #10
        a = -95;
        b = -97;
        #10
        // subtraction overflow;
        a = 16'b1000000000000000;
        b = 1;
        #10
        
        
        // addition
        // adding positive
        a = 100;
        b = 96;
        alu_control = 4'b0001;
        #10
        // adding two negative
        a = -95;
        b = -97;
        #10
        // adding negative and positive
        a = -95;
        b = 97;
        #10
        // addition overflow;
        a = 16'b0111111111111111;
        b = 1;
        #10
        
        // bitwise or
        a = 16'b1010101010101010;
        b = 16'b0101010101010101;
        alu_control = 4'b0010;
        #10
        a = 1;
        b = 1;
        #10
        a = 0;
        b = 0;
        #10
        
        // bitwise and
        a = 16'b1010101010101010;
        b = 16'b0101010101010101;
        alu_control = 4'b0011;
        #10
        a = 1;
        b = 1;
        #10
        a = 0;
        b = 0;
        #10
        
        // decrement
        // positive
        a = 100;
        b = 69;
        alu_control = 4'b0100;
        #10
        // negative
        a = -100;
        #10
        // overflow
        a = 16'b1000000000000000;
        #10
        
        // increment
        // positive
        a = 100;
        b = 69;
        alu_control = 4'b0101;
        #10
        // negative
        a = -100;
        #10
        // overflow
        a = 16'b0111111111111111;
        #10
        
        // invert
        a = 16'b1111111111111111;
        b = 69;
        alu_control = 4'b0110;
        #10
        a = 16'b0000000000000000;
        #10
        a = 16'b1011011011011000;
        
        
        
        /*
         a = 16'b1;
         b = 16'b1;
         alu_control = 4'b1001;
         #10
         a = 16'b111;
         b = 16'b100;
         alu_control = 4'b1001;
         #10;        
        */
     end
endmodule
