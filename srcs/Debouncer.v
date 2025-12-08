`timescale 1ns / 1ps
`default_nettype none

module Debounce(
    input wire btn, 
    input wire clk, 
    output reg led
    );
    
    reg [2:0] counter; //3 bit counter
    wire TC; //store if signal from button stable
    
    always @(posedge clk) begin
        if(~btn) begin
            counter <= 0; //reset
        end
        else begin
            counter <= counter + 1; 
        end
    end
    
    assign TC = (counter == 7); //Counter is at max value
    
    //Assign system output
    always @(posedge clk) begin
        if(~btn) begin
            led <= 0; //Button no longer pressed
        end
        else if (TC) begin
            led <= 1; // Button debounced, set output high
        end
        else
            led <= led; //Otherwise hold value
    end
    
endmodule