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


//Module that implements a 4-bit counter, running on a .67Hz clock divider
module my_counter(
    input clock,
    input reset,
    input enable,
    output reg [3:0] counter_out
    );
    
    reg [25:0] clock_reg;
    wire clock_en;
    //2^25 = 2^25*2/(10^6*100) = 0.67 s, period for .67s (low for first half, high for last half)
    //Will need to change clock divider amt when simulating results
    assign clock_en = clock_reg[25];
    
    //uses internal clock of 100 Mhz to count reg, overflow makes the 25 bit reg go back to 0
    always @ (posedge clock)
        clock_reg <= clock_reg + 1;
    
    //reset priority, then enable will check if increment
    always @ (posedge clock_en)
        if (reset)
            counter_out <= 0;
        else if (enable)
            counter_out <= counter_out + 1;
endmodule
