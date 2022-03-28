`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2022 12:38:25 PM
// Design Name: 
// Module Name: counter_tb
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


module counter_tb;
    reg clock, reset, enable;
    wire [3:0] counter;
    counter_module UUT (
        .clock(clock),
        .reset(reset),
        .enable(enable),
        .counter(counter)
    );
    
    initial begin
        clock <= 1'b0;
        enable <= 1'b1;
        reset <= 1'b1;
        #30
        reset <= 1'b0;
        #40
        enable <= 1'b0;
        #20
        enable <= 1'b1;
    end
    always begin
        clock = ~clock;
        #5;
    end
endmodule
