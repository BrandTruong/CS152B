`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2022 12:50:12 PM
// Design Name: 
// Module Name: one_bit_alu
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


module one_bit_alu_msb(
    input a,
    input b,
    input a_sel,
    input b_sel,
    input cin,
    input[1:0] op,
    input less,
    output result,
    output set_less,
    output overflow
    );
    
    
    wire a_not;
    wire a_processed;
    not(a_not, a);
    two_one_mux ainvert (.sel(a_sel), .a(a), .b(a_not), .x(a_processed));
    
    wire b_not;
    wire b_processed;
    not(b_not, b);
    two_one_mux binvert (.sel(b_sel), .a(b), .b(b_not), .x(b_processed));
    
    wire op_and;
    and(op_and, a_processed, b_processed);
    
    wire op_or;
    or(op_or, a_processed, b_processed);
    
    wire cout;
    wire op_add;
    addbit addbit_UUT (.a(a_processed), .b(b_processed), .cin(cin), .cout(cout), .sum(op_add));
    
    wire mux_and_or;
    two_one_mux and_or (.sel(op[0]), .a(op_and), .b(op_or), .x(mux_and_or));
    
    wire mux_add_less;
    two_one_mux add_less (.sel(op[0]), .a(op_add), .b(less), .x(mux_add_less));
    
    two_one_mux result_mux (.sel(op[1]), .a(mux_and_or), .b(mux_add_less), .x(result));
    
    xor(overflow, cin, cout);
    
    assign set_less = op_add;    
endmodule

module one_bit_alu(
    input a,
    input b,
    input a_sel,
    input b_sel,
    input cin,
    input[1:0] op,
    input less,
    output result,
    output cout
    );
    
    wire a_not;
    wire a_processed;
    not(a_not, a);
    two_one_mux ainvert (.sel(a_sel), .a(a), .b(a_not), .x(a_processed));
    
    wire b_not;
    wire b_processed;
    not(b_not, b);
    two_one_mux binvert (.sel(b_sel), .a(b), .b(b_not), .x(b_processed));
    
    wire op_and;
    and(op_and, a_processed, b_processed);
    
    wire op_or;
    or(op_or, a_processed, b_processed);
    
    wire op_add;
    addbit addbit_UUT (.a(a_processed), .b(b_processed), .cin(cin), .cout(cout), .sum(op_add));
    
    wire mux_and_or;
    two_one_mux and_or (.sel(op[0]), .a(op_and), .b(op_or), .x(mux_and_or));
    
    wire mux_add_less;
    two_one_mux add_less (.sel(op[0]), .a(op_add), .b(less), .x(mux_add_less));
    
    two_one_mux result_mux (.sel(op[1]), .a(mux_and_or), .b(mux_add_less), .x(result));
endmodule
