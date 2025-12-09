`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2025 12:14:43 AM
// Design Name: 
// Module Name: edge_gen_tb
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


module edge_gen_tb();

    reg signal; 
    reg clk;
    reg rst; 
    wire out; 
    
    edge_generator dut(.signal(signal), .clk(clk), .rst(rst), .out(out)); 
    
    initial begin
        signal = 0;
        clk = 0;
        rst = 1;
    end
    
    always #1 clk = ~clk; 
    
    initial begin
        #4 rst = 0; 
        #2 signal = 1;
        #10 signal = 0;
        #4 signal = 1; 
        #10 $finish; 
    end
endmodule
