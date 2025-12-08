`timescale 1ns / 1ps
`default_nettype none

module Multi_Driver(
    input wire clk, 
    input wire [15:0] sw,
    output reg [3:0] an,
    output reg [7:0] seg
    );
    
    wire [7:0] segValues [3:0]; 
    //Convert all values to seven segment outputs
    genvar i;
    generate 
        for(i = 0; i < 4; i = i + 1) begin
            BCD_SEG x(sw[3 + 4 * i:4 * i], segValues[i]); 
        end
    endgenerate
    
    
    parameter DELAY = 4095; 
    reg [11:0] count = 0; // 12 bit counter 
    always @(posedge clk) begin
        if(count < (DELAY / 4)) begin
            an <= 4'b1110;
            seg <= segValues[0];
        end
        else if (count < (DELAY / 2)) begin
            an <= 4'b1101;
            seg <= segValues[1];
        end
        else if (count < ((3 * DELAY) / 4)) begin
            an <= 4'b1011;
            seg <= segValues[2];
        end
        else begin
            an <= 4'b0111;
            seg <= segValues[3];
        end
        count <= count + 1; 
    end
    
endmodule