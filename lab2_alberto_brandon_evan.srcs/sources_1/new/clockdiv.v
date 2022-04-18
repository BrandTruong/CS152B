`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2022 01:21:56 PM
// Design Name: 
// Module Name: clockdiv
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


module clockdiv(
    input clk,
    input rst,
    output reg onehz
    );
    
    reg [31:0] period;
    
    initial
    begin
        period = 0;
        onehz = 0;
    end
    
    always @ (posedge clk)
    begin
        if (rst)
            period <= 0;
        else if (period == 49999999)
        begin
            period <= 0;
            onehz <= ~onehz;
        end
        else
            period <= period + 1;
    end
endmodule
