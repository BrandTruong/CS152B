`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2022 12:48:18 PM
// Design Name: 
// Module Name: register_file
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

//Structural module that reads and writes to 32 16-bit registers. Reset will reset all registers (prioritizing reset over write enable), otherwise, it will write busW to the register Rw, and read registers Ra and Rb into busA and busB respectively
module register_file(
    input clk,
    input rst,
    input[4:0] Ra,
    input[4:0] Rb,
    input[4:0] Rw,
    input WrEn,
    input[15:0] busW,
    output reg[15:0] busA,
    output reg[15:0] busB
    );
    
    reg[15:0] registers [31:0];
    integer i;
    
    always @ (posedge clk)
    begin
        if (rst)
            //reset all registers
            for (i = 0; i < 32; i = i + 1)
                registers[i] = 0;
        else if (WrEn)
            //write to register specified by Rw
            registers[Rw] = busW;
        //outputs are linked to corresponding registers
        busA = registers[Ra];
        busB = registers[Rb];
    end
endmodule
