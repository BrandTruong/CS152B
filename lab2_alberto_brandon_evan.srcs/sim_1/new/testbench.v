`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2022 01:06:15 PM
// Design Name: 
// Module Name: testbench
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


module testbench(

    );
    reg clk, rst;
    reg walk_btn;
    reg sensor;
    wire [2:0] main_light;
    wire [2:0] side_light;
    wire walk_light;
    
     traffic_light_fsm traffic_light_fsm_uut (
        .clk(clk),
        .rst(rst), 
        .walk_btn(walk_btn), 
        .sensor(sensor), 
        .main_light(main_light), 
        .side_light(side_light), 
        .walk_light(walk_light)
    );
    initial
    begin
        clk = 0;
        rst = 0;
        walk_btn = 0;
        sensor = 0;
        for (integer i = 0; i < 10000; i = i + 1)
        begin
            #10
            if(i == 60) sensor = 1;
            if(i == 300) sensor = 0;
            if(i == 69) walk_btn = 1;
            if(i == 72) walk_btn = 0;
            clk = ~clk;
        end
    end
endmodule
