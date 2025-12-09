`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2025 08:06:35 PM
// Design Name: 
// Module Name: Calc_top_tb
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


module Calc_top_tb;
    reg [3:0] a;
    reg [3:0] b;
    reg [2:0] op;
    reg clk, rst, enter, back, up, down;
    wire [3:0] an;
    wire [7:0] seg;
    
    Calculator_top DUT(.a(a),.b(b),.op(op),.clk(clk), .rst(rst), .enter(enter), .back(back),.up(up),.down(down), .an(an), .seg(seg));
    
    initial begin
        a = 0;
        b = 0;
        op = 0;
        clk = 0;
        rst = 1;
    end
    
    
    always begin
        #1 clk = ~clk;
    end
    
    initial begin
        #2 rst = 0;
        #50 a = 3'b011; b = 3'b110; op = 3'b000; //out = 010
        #50 a = 3'b100; b = 3'b001; op = 3'b001; //out = 101
        #50 a = 3'b100; b = 3'b001; op = 3'b010; //out = 011
        #50 a = 3'b100; b = 3'b101; op = 3'b011; //out = 011
        #50 a = 3'b010; b = 3'b011; op = 3'b100; //out = 101
        #50 a = 3'b111; b = 3'b011; op = 3'b101; //out = 100
        #50 a = 3'b010; b = 3'b011; op = 3'b110; //out = 110
        #50 a = 3'b110; b = 3'b010; op = 3'b111; //out = 011
        #50 $finish;
    end
    
endmodule
