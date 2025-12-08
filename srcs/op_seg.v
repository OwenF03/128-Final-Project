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
            0: s = 8'b0000_0011; 
            1: s = 8'b1001_1111;
            2: s = 8'b0010_0101;
            3: s = 8'b0000_1101;
            4: s = 8'b1001_1001;
            5: s = 8'b0100_1001;
            6: s = 8'b0100_0001;
            7: s = 8'b0001_1111;
            default s = 8'b1111_1111;
        endcase
end

endmodule