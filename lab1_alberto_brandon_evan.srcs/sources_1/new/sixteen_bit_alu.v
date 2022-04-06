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


module sixteen_bit_alu(
    input [15:0] a,
    input [15:0] b,
    input [3:0] alu_ctrl,
    output overflow,
    output zero,
    output [15:0] result
    );
    
    wire a_sel;
    wire b_sel;
    wire [1:0] op;
    wire set;
    reg less = 0;
    
    wire [15:0] cin;
    assign cin[0] = b_sel;
    
    alu_control alu_control_unit(
        .sel(alu_ctrl),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .op(op),
        .set(set)
        );
        
    one_bit_alu bit_0 (
        .a(a[0]),
        .b(b[0]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[0]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[0]),
        .cout(cin[1])
        );
    
    
    one_bit_alu bit_1 (
        .a(a[1]),
        .b(b[1]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[1]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[1]),
        .cout(cin[2])
        );
    
    one_bit_alu bit_2 (
        .a(a[2]),
        .b(b[2]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[2]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[2]),
        .cout(cin[3])
        );
        
    one_bit_alu bit_3 (
        .a(a[3]),
        .b(b[3]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[3]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[3]),
        .cout(cin[4])
        );
        
    one_bit_alu bit_4 (
        .a(a[4]),
        .b(b[4]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[4]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[4]),
        .cout(cin[5])
        );
        
    one_bit_alu bit_5 (
        .a(a[5]),
        .b(b[5]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[5]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[5]),
        .cout(cin[6])
        );
    
    one_bit_alu bit_6 (
        .a(a[6]),
        .b(b[6]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[6]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[6]),
        .cout(cin[7])
        );
        
    one_bit_alu bit_7 (
        .a(a[7]),
        .b(b[7]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[7]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[7]),
        .cout(cin[8])
        );
        
    one_bit_alu bit_8 (
        .a(a[8]),
        .b(b[8]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[8]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[8]),
        .cout(cin[9])
        );
                
    one_bit_alu bit_9 (
        .a(a[9]),
        .b(b[9]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[9]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[9]),
        .cout(cin[10])
        );
    
    one_bit_alu bit_10 (
        .a(a[10]),
        .b(b[10]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[10]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[10]),       
        .cout(cin[11])
        );
        
    one_bit_alu bit_11 (
        .a(a[11]),
        .b(b[11]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[11]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[11]),
        .cout(cin[12])
        );
        
    one_bit_alu bit_12 (
        .a(a[12]),
        .b(b[12]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[12]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[12]),
        .cout(cin[13])
        );
        
    one_bit_alu bit_13 (
        .a(a[13]),
        .b(b[13]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[13]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[13]),
        .cout(cin[14])
        );
    
    one_bit_alu bit_14 (
        .a(a[14]),
        .b(b[14]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[14]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[14]),
        .cout(cin[15])
        );
        
    one_bit_alu_msb bit_15 (
        .a(a[15]),
        .b(b[15]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[15]), // change to cout of previous
        .op(op),
        .less(less),
        .result(result[15]),
        .set(set),
        .overflow(overflow)
        ); 
endmodule