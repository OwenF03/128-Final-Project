`default_nettype none
`timescale 1ns / 1ps

//4-bit Carry Look-ahead Adder module
module cla_adder(input wire [3:0] A, input wire [3:0] B, input wire CI, output wire CO, output wire [3:0] SUM);
    wire [3:0] propegated, generated;
    wire [3:0] carries;
    assign carries[0] = CI;
    
    //Carry Lookahead Logic
    assign propegated = A ^ B; 
    assign generated = A & B;
    
    assign carries[1] = generated[0] | (propegated[0] & carries[0]);
    assign carries[2] = generated[1] | (propegated[1] & carries[1]);
    assign carries[3] = generated[2] | (propegated[2] & carries[2]);
    assign CO = generated[3] | (propegated[3] & carries[3]);
    
    //Four full adders, using Carry array from CLA logic
    genvar i;
    generate 
        for (i = 0; i < 4; i = i + 1) begin
            FA a(.A(A[i]), .B(B[i]), .CI(carries[i]), .SUM(SUM[i]));
        end
    endgenerate

endmodule 

//Full Adder Module
module FA(input wire A, input wire B, input wire CI, output wire CO, output wire SUM);
    assign CO = (A & B) | (CI & (A ^ B)); 
    assign SUM = A ^ B ^ CI; 
endmodule