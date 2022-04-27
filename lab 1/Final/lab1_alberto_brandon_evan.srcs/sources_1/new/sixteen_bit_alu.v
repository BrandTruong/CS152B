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
    wire inc_dec;
    reg less = 0;
    
    wire [15:0] cin;
    assign cin[0] = b_sel;
    
    alu_control alu_control_unit(
        .sel(alu_ctrl),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .op(op),
        .inc_dec(inc_dec)
        );
        
    wire control;
    and(control, a_sel, b_sel);
    
    wire [15:0] alu_result;
    wire [15:0] shift_result;
    
    sixteen_bit_two_one_mux alu_or_shift(
        .sel(control),
        .a(alu_result),
        .b(shift_result),
        .x(result)
        );
        
    wire [15:0] b_final;
    
    //Invert logic    
    wire inv;
    wire b_sel_not;    
    not(b_sel_not, b_sel);
    and(inv, b_sel_not, a_sel);
    
    wire inc_dec_or_inv;
    or(inc_dec_or_inv, inc_dec, inv);
    
    sixteen_bit_two_one_mux b_or_one(
        .sel(inc_dec_or_inv),
        .a(b),
        .b(1),
        .x(b_final)
        );
        
    shifter shifter_unit(
        .a(a),
        .b(b),
        .shift_control(op), // 00 arithmeitc left shift, 01 logical left shift, 10 arithmetic right shift, 11 logical right shfit
        .x(shift_result)
        );
    wire shift_overflow;
    xor(shift_overflow, a[15], shift_result[15]);
    wire alu_overflow;
    
    wire arithmetic_left_shift_control;
    wire not_first_bit;
    wire not_zeroth_bit;
    not(not_zeroth_bit, alu_ctrl[0]);
    not(not_first_bit, alu_ctrl[1]);
    and(arithmetic_left_shift_control, not_zeroth_bit, not_first_bit, alu_ctrl[3], alu_ctrl[2]);
    
    wire alu_shift_overflow;
    two_one_mux alu_or_shift_overflow(
        .sel(arithmetic_left_shift_control),
        .a(alu_overflow),
        .b(shift_overflow),
        .x(alu_shift_overflow)
        );
    wire overflow_slt_control;
    and(overflow_slt_control, alu_ctrl[3], alu_ctrl[0]);
    two_one_mux final_overflow(
        .sel(overflow_slt_control),
        .a(alu_shift_overflow),
        .b(0),
        .x(overflow)
        );
    
    wire zero_bits[15:0];
    
    xnor(zero_bits[15], a[15], b[15]);
    xnor(zero_bits[14], a[14], b[14]);
    xnor(zero_bits[13], a[13], b[13]);
    xnor(zero_bits[12], a[12], b[12]);
    xnor(zero_bits[11], a[11], b[11]);
    xnor(zero_bits[10], a[10], b[10]);
    xnor(zero_bits[9], a[9], b[9]);
    xnor(zero_bits[8], a[8], b[8]);
    xnor(zero_bits[7], a[7], b[7]);
    xnor(zero_bits[6], a[6], b[6]);
    xnor(zero_bits[5], a[5], b[5]);
    xnor(zero_bits[4], a[4], b[4]);
    xnor(zero_bits[3], a[3], b[3]);
    xnor(zero_bits[2], a[2], b[2]);
    xnor(zero_bits[1], a[1], b[1]);
    xnor(zero_bits[0], a[0], b[0]);
    
    wire inputs_are_equal;
    and(inputs_are_equal, zero_bits[15], zero_bits[14], zero_bits[13], zero_bits[12], zero_bits[11], zero_bits[10], zero_bits[9],
    zero_bits[8], zero_bits[7], zero_bits[6], zero_bits[5], zero_bits[4], zero_bits[3], zero_bits[2], zero_bits[1], zero_bits[0]);
    //assign zero = a~^b;
    
    nor(zero, result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]);  
    
    wire set_less; 
    wire set;
    or(set, set_less, inputs_are_equal);
            
    one_bit_alu bit_0 (
        .a(a[0]),
        .b(b_final[0]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[0]), // change to cout of previous
        .op(op),
        .less(set),
        .result(alu_result[0]),
        .cout(cin[1])
        );
    
    
    one_bit_alu bit_1 (
        .a(a[1]),
        .b(b_final[1]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[1]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[1]),
        .cout(cin[2])
        );
    
    one_bit_alu bit_2 (
        .a(a[2]),
        .b(b_final[2]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[2]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[2]),
        .cout(cin[3])
        );
        
    one_bit_alu bit_3 (
        .a(a[3]),
        .b(b_final[3]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[3]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[3]),
        .cout(cin[4])
        );
        
    one_bit_alu bit_4 (
        .a(a[4]),
        .b(b_final[4]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[4]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[4]),
        .cout(cin[5])
        );
        
    one_bit_alu bit_5 (
        .a(a[5]),
        .b(b_final[5]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[5]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[5]),
        .cout(cin[6])
        );
    
    one_bit_alu bit_6 (
        .a(a[6]),
        .b(b_final[6]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[6]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[6]),
        .cout(cin[7])
        );
        
    one_bit_alu bit_7 (
        .a(a[7]),
        .b(b_final[7]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[7]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[7]),
        .cout(cin[8])
        );
        
    one_bit_alu bit_8 (
        .a(a[8]),
        .b(b_final[8]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[8]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[8]),
        .cout(cin[9])
        );
                
    one_bit_alu bit_9 (
        .a(a[9]),
        .b(b_final[9]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[9]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[9]),
        .cout(cin[10])
        );
    
    one_bit_alu bit_10 (
        .a(a[10]),
        .b(b_final[10]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[10]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[10]),       
        .cout(cin[11])
        );
        
    one_bit_alu bit_11 (
        .a(a[11]),
        .b(b_final[11]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[11]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[11]),
        .cout(cin[12])
        );
        
    one_bit_alu bit_12 (
        .a(a[12]),
        .b(b_final[12]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[12]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[12]),
        .cout(cin[13])
        );
        
    one_bit_alu bit_13 (
        .a(a[13]),
        .b(b_final[13]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[13]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[13]),
        .cout(cin[14])
        );
    
    one_bit_alu bit_14 (
        .a(a[14]),
        .b(b_final[14]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[14]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[14]),
        .cout(cin[15])
        );
        
    one_bit_alu_msb bit_15 (
        .a(a[15]),
        .b(b_final[15]),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin[15]), // change to cout of previous
        .op(op),
        .less(less),
        .result(alu_result[15]),
        .set_less(set_less),
        .overflow(alu_overflow)
        ); 
endmodule