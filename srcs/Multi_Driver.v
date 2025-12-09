`timescale 1ns / 1ps
`default_nettype none

module Multi_Driver(
    input wire clk, 
    input wire [31:0] segValues,
    output reg [3:0] an,
    output reg [7:0] seg
    );
    
    parameter DELAY = 4095; 
    reg [11:0] count = 0; // 12 bit counter 
    always @(posedge clk) begin
        if(count < (DELAY / 4)) begin
            an <= 4'b1110;
            seg <= segValues[7:0];
        end
        else if (count < (DELAY / 2)) begin
            an <= 4'b1101;
            seg <= segValues[15:8];
        end
        else if (count < ((3 * DELAY) / 4)) begin
            an <= 4'b1011;
            seg <= segValues[23:16];
        end
        else begin
            an <= 4'b0111;
            seg <= segValues[31:24];
        end
        count <= count + 1; 
    end
    
endmodule