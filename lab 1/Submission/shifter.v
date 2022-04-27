`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2022 01:08:28 PM
// Design Name: 
// Module Name: shifter
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

//Behavioral module that implements the corresponding shifts in 16-bit format, shifting a by b amount. Since left shifts are the same, we handle both cases together. Right shift arithmetic will use the most significant value to replace the other bits, and logical will use 0 to replace.
module shifter(
    input[15:0] a,
    input[15:0] b,
    input[1:0] shift_control, // 00 arithmeitc left shift, 01 logical left shift, 10 arithmetic right shift, 11 logical right shfit
    output reg[15:0] x
    );
    
    integer i;
    integer j;
    always @*
    begin
        if (b > 0)
            case (shift_control)
                2'b00, // arithmetic left
                2'b10: // logical left
                    begin
                        for (i = 15; i >= b; i = i - 1)
                            x[i] = a[i - b];
                        for (j = b - 1; j >= 0; j = j - 1)
                            x[j] = 0;
                    end
                2'b01: // arithmetic right
                    begin
                        for (i = b; i <= 15; i = i + 1)
                            x[i - b] = a[i];
                        for (j = 15 - b + 1; j <= 15; j = j + 1)
                            x[j] = a[15];
                    end
                2'b11: // logical right
                begin
                    for (i = b; i <= 15; i = i + 1)
                        x[i - b] = a[i];
                    for (j = 15 - b + 1; j <= 15; j = j + 1)
                        x[j] = 0;
                end
            endcase
    end
    
    
endmodule
