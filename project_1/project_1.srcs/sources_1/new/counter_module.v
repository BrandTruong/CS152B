`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2022 12:25:53 PM
// Design Name: 
// Module Name: counter_module
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


module counter_module(
    input clock,
    input reset,
    input enable,
    output reg [3:0] counter
    );
    always @ (posedge clock) begin
            if(reset) begin
                counter <= 4'b0000;
            end
            else if(enable) begin
                counter <= counter + 1'b1;
            end
        end
endmodule
