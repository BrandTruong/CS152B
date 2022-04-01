`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2022 12:26:29 PM
// Design Name: 
// Module Name: my_counter
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


module my_counter(
    input clock,
    input reset,
    input enable,
    output reg [3:0] counter_out
    );
    
    reg [25:0] clock_reg;
    wire clock_en;
    
    assign clock_en = clock_reg[25];
    
    always @ (posedge clock)
        clock_reg <= clock_reg + 1;
    
    always @ (posedge clock_en)
        if (reset)
            counter_out <= 0;
        else if (enable)
            counter_out <= counter_out + 1;
endmodule
