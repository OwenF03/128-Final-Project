`timescale 1ns / 1ps
`default_nettype none

module Calculator(

    input wire [3:0] a, 
    input wire [3:0] b,
    input wire [2:0] op,
    output reg [7:0] out
);

//operation will always be A OP B. Ex. A + B, A - B, A * B, A / B

    parameter AND = 3'b000;
    parameter OR = 3'b001;
    parameter NOT = 3'b010;
    parameter XOR = 3'b011;
    parameter ADD = 3'b100;
    parameter SUB = 3'b101;
    parameter MULT = 3'b110;
    parameter DIV = 3'b111; 
    
    wire adder_co;
    wire [3:0] SUM;
    wire [7:0] PRODUCT;
    wire [3:0] B_adder;
    wire CI;
    
    assign B_adder = (op == ADD) ? b : 
                     (op == SUB) ? ~b :
                     0; 
    assign CI = (op == SUB) ? 1 : 0; 
    
    cla_adder ADDER(.A(a),.B(B_adder), .CI(CI), .CO(adder_co), .SUM(SUM));
    combo_mult MULTI(.a(a), .b(b), .res(PRODUCT));

    always @(*) begin
        case(op)
            AND: begin
                out <= {{4{1'b0}}, a&b};
            end
            OR: begin
                out <= {{4{1'b0}}, a|b};
            end
            NOT: begin
                out <= {{4{1'b1}}, ~a};
            end
            XOR: begin
                out <= {{4{1'b0}}, a ^ b};
            end
            ADD: begin
                out <= {{3{1'b0}}, adder_co, SUM};
            end
            SUB: begin
                if (a < b) begin
                    out <= {{4{1'b1}}, SUM};
                end
                else out <= {{4{1'b0}}, SUM};
            end
            MULT: begin
                out <= PRODUCT;
            end
            DIV: begin
                out <= a/b;
            end
    
        endcase
   end

endmodule 