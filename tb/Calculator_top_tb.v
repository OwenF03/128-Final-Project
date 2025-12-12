`timescale 1ns / 1ps

module Calc_top_tb;
    reg [3:0] a;
    reg [3:0] b;
    reg clk, rst, enter, back, up, down;
    wire [3:0] an;
    wire [7:0] seg;
    
    Calculator_top DUT(.a(a),.b(b),.clk(clk), .rst(rst), .enter(enter), .back(back),.up(up),.down(down), .an(an), .seg(seg));
    
    initial begin
        a = 10;
        b = 15;
        clk = 0;
        rst = 0;
        up = 0;
        down = 0;
        back = 0;
        enter = 0;
        
    end
    
    
    always begin
        #1 clk = ~clk;
    end
    
    initial begin
        #4 rst = 1; 
        #180000 rst = 0;
        #2 up = 1; 
        #180000 up = 0; 
        #180000 up = 1;
        #180000 up = 0; 
        #180000 up = 1; 
        #180000 up = 0; 
        #180000 up = 1; 
        #180000 up = 0; 
        #180000 up = 1; 
        #180000 up = 0; 
        #180000 up = 1; 
        #180000 enter = 1;
        #180000 enter = 0; 
        #200000 ;
        #50 $finish;
    end
    
endmodule