`timescale 1ns / 1ps
`default_nettype none

module combo_mult(input wire [3:0] a, input wire [3:0] b, output wire [7:0] res);

    
    
    wire [7:0] m [3:0];
     
    genvar i; 
    generate 
        for(i = 0; i < 4; i = i + 1) begin
            assign m[i] = (a[i] != 0) ? ({{4'b0}, b} << i) : 8'b0;
        end
    endgenerate
    
    assign res = m[0] + m[1] + m[2] + m[3];
    
endmodule