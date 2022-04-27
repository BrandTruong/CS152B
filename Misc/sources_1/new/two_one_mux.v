`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2022 12:08:28 PM
// Design Name: 
// Module Name: 16_bit_ALU
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


module two_one_mux(
    input sel,
    input a,
    input b,
    output reg x
    );
    
    
    always @*
        if(sel)
            x = b;
        else
            x = a;
endmodule

module four_bit_two_one_mux(
    input sel,
    input[3:0] a,
    input[3:0] b,
    output reg[3:0] x
    );
    
    // if sel = 1 pick b else pick a
    always @*
        if(sel)
            x = b;
        else
            x = a;
endmodule

module sixteen_bit_two_one_mux(
    input sel,
    input[15:0] a,
    input[15:0] b,
    output reg[15:0] x
    );
    
    // if sel = 1 pick b else pick a
    always @*
        if(sel)
            x = b;
        else
            x = a;
endmodule
