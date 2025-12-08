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

    cla_adder ADDER(.A(a),.B(B_adder), .CI(CI), .CO(adder_co), .SUM(SUM));
    combo_mult MULTI(.A(a), .B(b), .res(PRODUCT));

    always @(*) begin
        case(op)
            AND: begin
                out <= {4{1'b0}, A&B};
            end
            OR: begin
                out <= {4{1'b0}, A|B};
            end
            NOT: begin
                out <= {4{1'b1}, ~A};
            end
            XOR: begin
                out <= {4{1'b0}, A ^ B};
            end
            ADD: begin
                B_adder <= B;
                CI <= 0;
                out <= {3{1'b0}, adder_co, SUM};
            end
            SUB: begin
                B_adder <= ~B;
                CI <= 1;
                out <= {3{1'b0}, adder_co, SUM};
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