`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2022 12:05:13 PM
// Design Name: 
// Module Name: debouncer_test
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


module debouncer_test(
    );
    reg clk;
    reg rst;
    reg btn_in;
    wire btn_out;
    debouncer debouncer(.btn_in(btn_in), .clk(clk), .rst(rst), .btn_out(btn_out));
    initial
    begin
        clk = 0;
        rst = 0;
        btn_in =0;
        #100
        btn_in = 1;
        for (integer i = 0; i < 10000; i = i + 1)
        begin
            if(i == 100)
                btn_in = 0;
            if(i == 1000)
                btn_in = 1;
            if(i == 1050)
                btn_in = 0;
            clk = ~clk;
            #10;
        end
    end
endmodule
