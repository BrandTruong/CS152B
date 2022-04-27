`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2022 12:33:30 PM
// Design Name: 
// Module Name: test_bench
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


module test_bench( 
    
    );
    
    reg clock, reset, enable;
    wire[3:0] counter_out;
    
    my_counter UUT(.clock(clock), .reset(reset), .enable(enable), .counter_out(counter_out));
    
    initial begin
        clock = 1;
        reset = 0;
        enable = 0;
        
        #5;
        //reset flushes values back to 0 (from initial don't care)
        reset = 1;
        clock = 0;
        #5;
        clock = 1;
        #5;
        reset = 0;
        clock = 0;
        #5
        clock = 1;
        #5;
        //enable
        clock = 0;
        enable = 1;
        
        //simple clock for 100ns
        for (integer i = 0; i < 20; i = i + 1)
        begin
            #5;
            clock = ~clock;
        end  
    end
endmodule
