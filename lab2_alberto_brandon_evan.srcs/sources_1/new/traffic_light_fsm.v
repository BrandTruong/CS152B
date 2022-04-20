`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2022 12:04:03 PM
// Design Name: 
// Module Name: debouncer
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

module traffic_light_fsm(
    input clk,
    input rst, 
    input walk_btn, 
    input sensor, 
    output reg [2:0] main_light, 
    output reg [2:0] side_light, 
    output reg walk_light
);
    localparam RED = 3'b100;
    localparam YELLOW = 3'b010;
    localparam GREEN = 3'b001;
    
    localparam MAIN_FIRST_6 = 0;
    localparam MAIN_SECOND_3 = 1;
    localparam MAIN_SECOND_6 = 2;
    localparam MAIN_YELLOW = 3;
    localparam SIDE_FIRST_6 = 4;
    localparam SIDE_SECOND_3 = 5;
    localparam SIDE_YELLOW = 6;
    localparam ALL_RED = 7;
    
    wire onehz;
    
    clockdiv clockdiv_unit(
        .clk(clk),
        .rst(rst),
        .onehz(onehz)
        );
        
    wire walk_btn_debounced;
        
    debouncer walk_btn_debouncer(
        .btn_in(walk_btn),
        .clk(clk),
        .btn_out(walk_btn_debounced)
        );
    
    reg[2:0] state = 0;
    reg[2:0] next_state = 1;
    
    reg[3:0] time_counter = 6;
    
    reg walk_register = 0;
    
    always @ (state)
    begin
        case (state)
            MAIN_FIRST_6,
            MAIN_SECOND_6,
            SIDE_FIRST_6:
                time_counter <= 6;
            MAIN_SECOND_3,
            SIDE_SECOND_3,
            ALL_RED:
                time_counter <= 3;
            MAIN_YELLOW,
            SIDE_YELLOW:
                time_counter <= 2;
        endcase
    end
    
    //walk button register/logic
    always @ (posedge walk_btn)
    begin
        walk_register = 1;
    end
    
    always @ (state or sensor)
    begin
        next_state = 0;
        case (state)
            MAIN_FIRST_6:
                if (sensor)
                    next_state <= MAIN_SECOND_3;
                else
                    next_state <= MAIN_SECOND_6;
            MAIN_SECOND_3,
            MAIN_SECOND_6:
                next_state <= MAIN_YELLOW;
            MAIN_YELLOW:
                if (walk_register)
                    next_state <= ALL_RED;
                else
                    next_state <= SIDE_FIRST_6; // check for walk_btn
            SIDE_FIRST_6:
            begin
                walk_register <= 0;
                walk_light <= 0;
                if (sensor)
                    next_state <= SIDE_SECOND_3;
                else
                    next_state <= SIDE_YELLOW;
            end
            SIDE_SECOND_3:
                next_state <= SIDE_YELLOW;
            SIDE_YELLOW:
                next_state <= MAIN_FIRST_6;
            ALL_RED:
            begin
                next_state <= SIDE_FIRST_6;
                walk_light <= 1;
            end
        endcase
    end
    
    always @ (posedge onehz)
    begin
        if (rst == 1'b1)
        begin
            state = 0;
            next_state = 1;
            time_counter = 6;
        end
        else begin
            time_counter = time_counter - 1;
            if (time_counter == 0)
                state = next_state;
        end
        
        //traffic light change
        
        if(rst == 1'b1)
        begin
            main_light = GREEN;
            side_light = RED;
        end
        else 
        begin
            case (state)
                MAIN_FIRST_6,
                MAIN_SECOND_3,
                MAIN_SECOND_6:
                begin
                    main_light = GREEN;
                    side_light = RED;
                end
                MAIN_YELLOW:
                begin
                    main_light = YELLOW;
                    side_light = RED;
                end
                SIDE_FIRST_6,
                SIDE_SECOND_3:
                begin
                    main_light = RED;
                    side_light = GREEN;
                end
                SIDE_YELLOW:
                begin
                    main_light = RED;
                    side_light = YELLOW;
                end
                ALL_RED:
                begin
                    main_light = RED;
                    side_light = RED;
                end
            endcase
        end
    end
    /*
    always @(onehz)
    begin
        if(rst == 1'b1)
        begin
            main_light <= GREEN;
            side_light <= RED;
        end
        else 
        begin
            case (state)
                MAIN_FIRST_6,
                MAIN_SECOND_3,
                MAIN_SECOND_6:
                begin
                    main_light <= GREEN;
                    side_light <= RED;
                end
                MAIN_YELLOW:
                begin
                    main_light <= YELLOW;
                    side_light <= RED;
                end
                SIDE_FIRST_6,
                SIDE_SECOND_3:
                begin
                    main_light <= RED;
                    side_light <= GREEN;
                end
                SIDE_YELLOW:
                begin
                    main_light <= RED;
                    side_light <= YELLOW;
                end
                ALL_RED:
                begin
                    main_light <= RED;
                    side_light <= RED;
                end
            endcase
        end
    end
    */
endmodule