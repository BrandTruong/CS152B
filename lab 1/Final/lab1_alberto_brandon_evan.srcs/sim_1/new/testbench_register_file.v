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


module testbench_register_file(

    );
    //Init variables
    reg clk;
    reg rst;
    reg[4:0] Ra;
    reg[4:0] Rb;
    reg[4:0] Rw;
    reg WrEn;
    reg[15:0] busW;
    wire[15:0] busA;
    wire[15:0] busB;
    
    register_file register_file_UUT(
        .clk(clk),
        .rst(rst),
        .Ra(Ra),
        .Rb(Rb),
        .Rw(Rw),
        .WrEn(WrEn),
        .busW(busW),
        .busA(busA),
        .busB(busB)
        );
    always #10
    begin
        clk = ~clk;
        
    end
    initial
    begin
        //normal 
        clk = 0;
        rst = 1;
        Ra = 1;
        Rb = 2;
        Rw = 2;
        WrEn = 1;
        busW = 40;
        #20
        rst = 0;
        #25
        //Show WrEn and rst
        WrEn = 0;
        rst = 1;
        #20
        rst = 0;
        busW = 33;
        #10
        //Should write to 1 with 33, then Ra should put busA as reg1
        Rw = 1;
        WrEn = 1;
        //Test to see if reg 3 resetted?
        Rb = 3;
        #100
        rst = 1;
        
        
    end
endmodule


/* OLD MODULES HERE
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
        
        reg [3:0] sel;
        wire a_sel;
        wire b_sel;
        wire [1:0] op;
        wire set;
        
        alu_control alu_control_UUT(
            .sel(sel),
            .a_sel(a_sel),
            .b_sel(b_sel),
            .op(op),
            .set(set)
            );
            
        initial
        begin
           sel = 4'b1001;
        end
        */
        /*
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
         
             a = 16'b1;
             b = 16'b1;
             alu_control = 4'b1001;
             #10
             a = 16'b111;
             b = 16'b100;
             alu_control = 4'b1001;
             #10;        
            
         end
         reg[15:0] a;
         reg[15:0] b;
         reg[1:0] shift_control; // 00 arithmeitc left shift, 01 logical left shift, 10 arithmetic right shift, 11 logical right shfit
         wire[15:0] x;
         
         shifter shifter_UUT (
            .a(a),
            .b(b),
            .shift_control(shift_control), // 00 arithmeitc left shift, 01 logical left shift, 10 arithmetic right shift, 11 logical right shfit
            .x(x)
            );
            
         initial
         begin
            a = 16'b0111111111111111;
            b = 4;
            shift_control = 2'b00;
        end
        */