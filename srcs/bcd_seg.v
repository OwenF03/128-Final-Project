`timescale 1ns / 1ps
`default_nettype none

//Module which takes in a four bit value (eventually BCD), and outputs the appropriate segment 
// values
// Output is s, which corresponds to constraint file cathode values (driven in top module)
module bcd_seg(
    input wire [3:0] BCD, 
    output reg [7:0] s
);

    always @(*) begin
        case(BCD)
            0: s = 8'b0000_0011; 
            1: s = 8'b1001_1111;
            2: s = 8'b0010_0101;
            3: s = 8'b0000_1101;
            4: s = 8'b1001_1001;
            5: s = 8'b0100_1001;
            6: s = 8'b0100_0001;
            7: s = 8'b0001_1111;
            8: s = 8'b0000_0001;
            9: s = 8'b0000_1001;
            10: s = 8'b1111_1101; 
            default s = 8'b0000_0000;
        endcase
end

endmodule