`timescale 1ns / 1ps
`default_nettype none

//Module which takes in a four bit value (eventually BCD), and outputs the appropriate segment 
// values
// Output is s, which corresponds to constraint file cathode values (driven in top module)
module op_seg(
    input wire [2:0] OP, 
    output reg [31:0] s
);

    always @(*) begin
        case(OP)
            0: s = 32'b1111_1111_0001_0001_1101_0101_1000_0101; //AND (And)
            1: s = 32'b1111_1111_1111_1111_0000_0011_1111_0101; //OR (Or)
            2: s = 32'b1111_1111_1101_0101_1100_0101_1110_0001; //NOT (not)
            3: s = 32'b1111_1111_1001_0001_0000_0011_1111_0101; //XOR (XOr)
            4: s = 32'b1111_1111_0001_0001_1000_0101_1000_0101; //ADD (Add)
            5: s = 32'b1111_1111_0100_1001_1100_0111_1100_0001; //SUB (Sub)
            6: s = 32'b0010_0011_0001_1011_1110_0011_0001_1111; //MULT (MLt)
            7: s = 32'b1111_1111_1000_0101_1001_1111_1010_1011; //DIV (dIV)
            default s = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        endcase
end

endmodule