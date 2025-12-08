`timescale 1ns / 1ps
`default_nettype none

module Calculator_top(

    input wire [3:0] a, 
    input wire [3:0] b,
    input wire [2:0] op, 
    input wire clk, 
    input wire enter, 
    input wire clear,
    input wire up, 
    input wire down,
    output wire [3:0] an, 
    output wire [7:0] seg
);

parameter 

reg [2:0] operation = 3'b0; 
wire up_d; wire down_d; 

// Handle op code scrolling 
always @ (posedge up_d or posedge down_d) begin
    if(up_d) begin
        operation = operation + 1; 
    end
    else if(down_d) begin
        operation = operation - 1; 
    end
end




//Debounce 


// Instantiate Calculator 

// Debouncer 

endmodule
