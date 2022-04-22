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

module traffic_light(
    input clk,
    input rst, 
    input walk_btn, 
    input sensor, 
    output reg [2:0] main_light, 
    output reg [2:0] side_light, 
    output reg walk_light,
    output onehz,
    output reg[2:0] time_counter
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
    
    //wire onehz;
    
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
    
    reg[2:0] state;
    reg[2:0] next_state;
    reg walk_register;
    
    initial begin
        time_counter <= 6;
        state <= MAIN_FIRST_6;
        next_state <= MAIN_SECOND_6;
        main_light <= GREEN;
        side_light <= RED;
        walk_register <= 0;
    end


    
    always @ (posedge onehz or posedge rst or posedge walk_btn_debounced)
    begin
        if (rst == 1'b1)
        begin
            time_counter <= 6;
            state <= MAIN_FIRST_6;
            next_state <= MAIN_SECOND_6;
            main_light <= GREEN;
            side_light <= RED;
            walk_register <= 0;
        end
        else if (walk_btn_debounced == 1)
            walk_register <= 1;
        else if (time_counter == 1)
        begin
            state = next_state;
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
            case (state)
                MAIN_FIRST_6:
                begin
                    if (sensor)
                        next_state <= MAIN_SECOND_3;
                    else
                        next_state <= MAIN_SECOND_6;
                    main_light <= GREEN;
                    side_light <= RED;
                end
                MAIN_SECOND_3,
                MAIN_SECOND_6:
                begin
                    next_state <= MAIN_YELLOW;
                    main_light <= GREEN;
                    side_light <= RED;
                end
                MAIN_YELLOW:
                begin
                    if (walk_register)
                        next_state <= ALL_RED;
                    else
                        next_state <= SIDE_FIRST_6; // check for walk_btn
                    main_light <= YELLOW;
                    side_light <= RED;
                end
                SIDE_FIRST_6:
                begin
                    walk_register <= 0;
                    walk_light <= 0;
                    main_light <= RED;
                    side_light <= GREEN;
                    if (sensor)
                        next_state <= SIDE_SECOND_3;
                    else
                        next_state <= SIDE_YELLOW;
                end
                SIDE_SECOND_3:
                begin
                    next_state <= SIDE_YELLOW;
                    main_light <= RED;
                    side_light <= GREEN;
                end
                SIDE_YELLOW:
                begin
                    next_state <= MAIN_FIRST_6;
                    main_light <= RED;
                    side_light <= YELLOW;
                end
                ALL_RED:
                begin
                    main_light <= RED;
                    side_light <= RED;
                    next_state <= SIDE_FIRST_6;
                    walk_light <= 1;
                end
            endcase
        end
        else
            time_counter <= time_counter - 1;
    end
    /*
    always @ (state)
    begin
        
        case (state)
            MAIN_FIRST_6:
            begin
                if (sensor)
                    next_state <= MAIN_SECOND_3;
                else
                    next_state <= MAIN_SECOND_6;
                main_light <= GREEN;
                side_light <= RED;
            end
            MAIN_SECOND_3,
            MAIN_SECOND_6:
            begin
                next_state <= MAIN_YELLOW;
                main_light <= GREEN;
                side_light <= RED;
            end
            MAIN_YELLOW:
            begin
                if (walk_register)
                    next_state <= ALL_RED;
                else
                    next_state <= SIDE_FIRST_6; // check for walk_btn
                main_light <= YELLOW;
                side_light <= RED;
            end
            SIDE_FIRST_6:
            begin
                main_light <= RED;
                side_light <= GREEN;
                walk_register <= 0;
                walk_light <= 0;
                if (sensor)
                    next_state <= SIDE_SECOND_3;
                else
                    next_state <= SIDE_YELLOW;
            end
            SIDE_SECOND_3:
            begin
                next_state <= SIDE_YELLOW;
                main_light <= RED;
                side_light <= GREEN;
            end
            SIDE_YELLOW:
            begin
                next_state <= MAIN_FIRST_6;
                main_light <= RED;
                side_light <= YELLOW;
            end
            ALL_RED:
            begin
                main_light <= RED;
                side_light <= RED;
                next_state <= SIDE_FIRST_6;
                walk_light <= 1;
            end
        endcase
    end */
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
