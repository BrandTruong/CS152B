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


module addbit(
    input cin,
    input a,
    input b,
    output cout,
    output sum
    );
    //Sum
    wire a_xor_b;
    xor(a_xor_b, a, b);
    xor(sum, a_xor_b, cin);
    //Carry out
    wire a_and_b;
    and(a_and_b, a, b);
    wire and_xor;
    and(and_xor, cin, a_xor_b);
    or(cout, a_and_b, and_xor);
    
    
endmodule
