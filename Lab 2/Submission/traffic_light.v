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

//Module that implements the FSM for the traffic light
module traffic_light(
    input clk,
    input rst, 
    input walk_btn, 
    input sensor, 
    output reg [2:0] main_light, 
    output reg [2:0] side_light, 
    output reg walk_light,
    output onehz, //optional output for easier reading on board
    output reg[2:0] time_counter ///optional output for easier reading on board
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
    
    //Internal module to function at 1Hz
    clockdiv clockdiv_unit(
        .clk(clk),
        .rst(rst),
        .onehz(onehz)
        );
        
    wire walk_btn_debounced;
    
    //Debounce button input 
    debouncer walk_btn_debouncer(
        .btn_in(walk_btn),
        .clk(clk),
        .btn_out(walk_btn_debounced)
        );
    
    reg[2:0] state;
    reg[2:0] next_state;
    reg walk_register;
    
    //Initialize values
    initial begin
        time_counter <= 6;
        state <= MAIN_FIRST_6;
        main_light <= GREEN;
        side_light <= RED;
        walk_register <= 0;
    end

    //Core logic
    always @ (posedge onehz or posedge rst or posedge walk_btn_debounced)
    begin
        //Reset functionality goes first, resets back to initial state (Main light is green for 6s)
        if (rst == 1'b1)
        begin
            time_counter <= 6;
            state <= MAIN_FIRST_6;
            main_light <= GREEN;
            side_light <= RED;
            walk_register <= 0;
        end
        else if (walk_btn_debounced == 1)
            //Walk button has been pressed and is queued for after Main yellow
            walk_register <= 1;
        else if (time_counter == 1) //Current state is ready to change
        begin
            //Case statement that handles the next state, based on the sensoor/walk button inputs, as well as current state
            case (state)
                MAIN_FIRST_6:
                begin
                    if (sensor)
                        next_state = MAIN_SECOND_3;
                    else
                        next_state = MAIN_SECOND_6;
                end
                MAIN_SECOND_3,
                MAIN_SECOND_6:
                begin
                    next_state = MAIN_YELLOW;
                end
                MAIN_YELLOW:
                begin
                    if (walk_register)
                        next_state = ALL_RED;
                    else
                        next_state = SIDE_FIRST_6; // check for walk_btn
                end
                SIDE_FIRST_6:
                begin
                    if (sensor)
                        next_state = SIDE_SECOND_3;
                    else
                        next_state = SIDE_YELLOW;
                end
                SIDE_SECOND_3:
                begin
                    next_state = SIDE_YELLOW;
                end
                SIDE_YELLOW:
                begin
                    next_state = MAIN_FIRST_6;
                end
                ALL_RED:
                begin
                    next_state = SIDE_FIRST_6;
                    walk_light <= 1;
                end
            endcase
            //Switch states here, blocking to allow for deterministic state
            state = next_state;
            //resets time counter based on the state we just swapped to
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
            //Sets the light based on the swapped state
            case (state)
                MAIN_FIRST_6,
                MAIN_SECOND_6,
                MAIN_SECOND_3:
                    begin
                        main_light <= GREEN;
                        side_light <= RED;
                    end
                SIDE_FIRST_6,
                SIDE_SECOND_3:
                    begin
                        main_light <= RED;
                        side_light <= GREEN;
                    end
                MAIN_YELLOW:
                    begin
                        main_light <= YELLOW;
                        side_light <= RED;
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
                        walk_light <= 1;
                    end  
            endcase
            //Special functionality to reset walk light and walk register once the walk period is over (at the start of side)
            if(state == SIDE_FIRST_6)
            begin
                walk_register <= 0;
                walk_light <= 0;
            end
        end
        else
            time_counter <= time_counter - 1; //Decrement time counter for current state until we hit 1
    end
    
endmodule