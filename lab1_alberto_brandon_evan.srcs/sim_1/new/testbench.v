`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2022 12:16:42 PM
// Design Name: 
// Module Name: testbench
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


module testbench(

    );
    /*
    reg sel;
    reg a;
    reg b;
    wire x;
    
    two_one_mux mux_UUT(.sel(sel), .a(a), .b(b), .x(x));
    
    initial
    begin
        a = 0;
        b = 1;
        sel = 0;
    end
    
    reg cin;
    reg a;
    reg b;
    wire cout;
    wire sum;
    
    addbit addbit_UUT(.cin(cin), .a(a), .b(b), .cout(cout), .sum(sum));
    
    initial
    begin
        cin = 0;
        a = 0;
        b = 0;
        #10
        cin = 0;
        a = 1;
        b = 0;
        #10
        cin = 0;
        a = 0;
        b = 1;
        #10
        cin = 0;
        a = 1;
        b = 1;
        #10
        cin = 1;
        a = 1;
        b = 1;
        #10
        cin = 1;
        a = 0;
        b = 1;
        #10
        cin = 1;
        a = 0;
        b = 0;
        #10
        cin = 1;
        a = 1;
        b = 0;
    end
    */
    
    reg a;
    reg b;
    reg a_sel;
    reg b_sel;
    reg cin;
    reg[1:0] op;
    reg less;
    wire result;
    wire set;
    wire overflow;
    wire cout;
    
    
    one_bit_alu one_bit_alu_UUT(
         .a(a),
        .b(b),
        .a_sel(a_sel),
        .b_sel(b_sel),
        .cin(cin),
        .op(op),
        .less(less),
        .result(result),
        .set(set),
        .overflow(overflow),
        .cout(cout)
        );
        
     initial
     begin
        a = 1;
        b = 1;
        a_sel = 0;
        b_sel = 0;
        cin = 1;
        op = 2;
        less = 0;
     end
    
endmodule
