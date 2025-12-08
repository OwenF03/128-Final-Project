`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2025 02:07:52 PM
// Design Name: 
// Module Name: COUNT_BCD
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

`define ONES 3:0
`define TENS 7:4
`define HUNDREDS 11:8
//`define THOUSANDS 15:12

// Will convert value from counter into BCD
// This module is designed to finish a conversion before starting a new one 
// New conversion occurs when the value supplied to count changes, so it is possible that values will
// be lost if the count value changes rapidly mid conversion, consider using a FIFO if this is a problem. 
module value_bcd(
    input wire clk,  
    input wire reset, 
    input wire en, // Enable 
    input wire [7:0] count, 
    output reg [11:0] BCD,
    output reg rdy
    );
    
    //States 
    parameter IDLE = 0; 
    parameter SHIFT = 1;
    parameter ADD = 2;
    // Kind of a parameterized design 
    parameter IN_WIDTH = 8;
    parameter OUT_WIDTH = 12;
    
    reg [7:0] count_p; //Previous counter value (latched at start of conversion)
    reg [3:0] shift_idx; //Index to shift in from count 
    reg [1:0] state; //State information
    reg [11:0] BCD_temp; //Store previous 
    
    // State machine
    always @(posedge clk or posedge reset) begin
        //Reset logic
        if(reset) begin
            BCD <= 0;
            rdy <= 0; 
            shift_idx <= 0; 
            count_p <= 0; 
            state <= IDLE;
        end
        else begin
            case(state)
                IDLE : begin // Wait for new value to convert
                    if((count_p != count) && en) begin //Prepare for new calculation
                        rdy <= 0;
                        BCD <= 0; //Reset BCD
                        count_p <= count; //Latch counter value 
                        shift_idx <= 0; //reset shift index
                        state <= SHIFT; // Become non idle when a new value arrives
                    end 
                    else state <= IDLE; //Otherwise keep in idle
                    rdy <= 0; //Ready already asserted, keep low
                end
                SHIFT : begin //Shift value in 
                    BCD <= {BCD[OUT_WIDTH - 1:0], count_p[1 - shift_idx]}; //Shift in new value
                    shift_idx <= shift_idx + 1; //Iterate shift index
                    state <= ADD; //Next state to add 
                    rdy <= 0; // Not ready
                end
                ADD : begin // Check for addition 
                    // If shift index is IN_WIDTH, all bits shfited and final add complete, next state will be idle 
                    // and ready signal asserted
                    if(shift_idx == IN_WIDTH) begin
                        rdy <= 1;    // Result is ready
                        state <= IDLE;  // Go to idle
                    end
                    else begin // Single assignment to BCD buffer with updated values if applicable
                        BCD <= 
                        { 
                            (BCD[`HUNDREDS] >= 5) ? BCD[`HUNDREDS] + 4'd3 : BCD[`HUNDREDS],
                            (BCD[`TENS] >= 5) ? BCD[`TENS] + 4'd3 : BCD[`TENS],
                            (BCD[`ONES] >= 5) ? BCD[`ONES] + 4'd3 : BCD[`ONES]
                        };
                        state <= SHIFT; //Shift in next value
                        rdy <= 0; //Not ready
                    end
                end
            endcase             
        end
        
    end

    
endmodule