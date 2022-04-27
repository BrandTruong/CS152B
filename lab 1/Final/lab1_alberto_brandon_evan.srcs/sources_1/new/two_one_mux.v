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

module two_one_mux_behavorial(
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

module two_one_mux(
    input sel,
    input a,
    input b,
    output x
    );
    wire a_res;
    wire not_sel;
    not(not_sel, sel);
    and(a_res, not_sel, a);
    wire b_res;
    and(b_res, sel, b);
    
    or(x, b_res, a_res);
    /*
    always @*
        if(sel)
            x = b;
        else
            x = a;
            */
endmodule

module four_bit_two_one_mux(
    input sel,
    input[3:0] a,
    input[3:0] b,
    output[3:0] x
    );
    
    // if sel = 1 pick b else pick a
    wire[3:0] a_res;
    wire[3:0] b_res;
    wire not_sel;
    not(not_sel, sel);
    and(a_res[0], not_sel, a[0]);
    and(a_res[1], not_sel, a[1]);
    and(a_res[2], not_sel, a[2]);
    and(a_res[3], not_sel, a[3]);
    and(b_res[0], sel, b[0]);
    and(b_res[1], sel, b[1]); 
    and(b_res[2], sel, b[2]); 
    and(b_res[3], sel, b[3]);     
    
    or(x[0], b_res[0], a_res[0]);
    or(x[1], b_res[1], a_res[1]);   
    or(x[2], b_res[2], a_res[2]);   
    or(x[3], b_res[3], a_res[3]);                              
endmodule

module sixteen_bit_two_one_mux(
    input sel,
    input[15:0] a,
    input[15:0] b,
    output[15:0] x
    );
    
    // if sel = 1 pick b else pick a
    wire[15:0] a_res;
    wire[15:0] b_res;
    wire not_sel;
    not(not_sel, sel);
    and(a_res[0], not_sel, a[0]);
    and(a_res[1], not_sel, a[1]);
    and(a_res[2], not_sel, a[2]);
    and(a_res[3], not_sel, a[3]);
    and(a_res[4], not_sel, a[4]);
    and(a_res[5], not_sel, a[5]);
    and(a_res[6], not_sel, a[6]);
    and(a_res[7], not_sel, a[7]);
    and(a_res[8], not_sel, a[8]);
    and(a_res[9], not_sel, a[9]);
    and(a_res[10], not_sel, a[10]);
    and(a_res[11], not_sel, a[11]);
    and(a_res[12], not_sel, a[12]);
    and(a_res[13], not_sel, a[13]);
    and(a_res[14], not_sel, a[14]);
    and(a_res[15], not_sel, a[15]);
    
    and(b_res[0], sel, b[0]);
    and(b_res[1], sel, b[1]); 
    and(b_res[2], sel, b[2]); 
    and(b_res[3], sel, b[3]);
    and(b_res[4], sel, b[4]);
    and(b_res[5], sel, b[5]);
    and(b_res[6], sel, b[6]);
    and(b_res[7], sel, b[7]);
    and(b_res[8], sel, b[8]);
    and(b_res[9], sel, b[9]);
    and(b_res[10], sel, b[10]);
    and(b_res[11], sel, b[11]);
    and(b_res[12], sel, b[12]);
    and(b_res[13], sel, b[13]);
    and(b_res[14], sel, b[14]);
    and(b_res[15], sel, b[15]);    
    
    or(x[0], b_res[0], a_res[0]);
    or(x[1], b_res[1], a_res[1]);   
    or(x[2], b_res[2], a_res[2]);   
    or(x[3], b_res[3], a_res[3]);
    or(x[4], b_res[4], a_res[4]);
    or(x[5], b_res[5], a_res[5]);
    or(x[6], b_res[6], a_res[6]);
    or(x[7], b_res[7], a_res[7]);
    or(x[8], b_res[8], a_res[8]);
    or(x[9], b_res[9], a_res[9]);
    or(x[10], b_res[10], a_res[10]);
    or(x[11], b_res[11], a_res[11]); 
    or(x[12], b_res[12], a_res[12]); 
    or(x[13], b_res[13], a_res[13]); 
    or(x[14], b_res[14], a_res[14]); 
    or(x[15], b_res[15], a_res[15]); 
    endmodule
