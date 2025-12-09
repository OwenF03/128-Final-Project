`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2025 12:11:08 AM
// Design Name: 
// Module Name: edge
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


module edge_generator(input wire clk, input wire rst, input wire signal, output reg out);  
    reg sig_p; 
    always @(posedge clk) begin
        if(rst == 1) begin
            out <= 0;
            sig_p <= 0;
        end else 
        begin
            if((sig_p != signal) && (signal)) begin
                out <= 1; 
            end 
            else out <= 0; 
            sig_p <= signal;
        end
    end
endmodule
