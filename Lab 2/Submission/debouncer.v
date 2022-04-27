`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2022 12:04:03 PM
// Design Name: 
// Module Name: debouncer
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


//Modules that uses D flip flop in order to implement a single pulse whenever the button is pressed.
module debouncer(input btn_in, input clk, input rst, output btn_out);
    wire clk_div;
    wire q1, q2, not_q2, q0;
    clock_div clock_div_1(.clk(clk), .clk_div(clk_div));
    //Double flip flop allows for a single posedge
    d_flipflop d_flipflop_1(.clk(clk_div), .d(q0), .q(q1));
    d_flipflop d_flipflop_2(.clk(clk_div), .d(q1), .q(q2));;
    assign q0 = btn_in;
    assign not_q2 = ~q2;
    assign btn_out = q1 & not_q2;
endmodule

//Internal module to use a clock divider running faster than 1Hz
module clock_div(input clk, output reg clk_div);
    reg [26:0] counter = 0;
    always @(posedge clk)
    begin
        counter <= (counter>=249999)?0:counter+1;
        clk_div <= (counter<125000)?1'b0:1'b1;
    end
endmodule

//Flip Flop logic
module d_flipflop(input clk, input d, output reg q);
    always @(posedge clk)
        q <= d;
endmodule
