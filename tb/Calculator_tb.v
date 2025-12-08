

module Calculator_tb;

    reg [3:0] a;
    reg [3:0] b;
    reg [2:0] op;
    wire [3:0] out;

    Calculator CALC(.a(a),.b(b),.op(op),.out(out));

    initial begin
        a = 0; b = 0; op = 0;
        #2 a = 3'b011; b = 3'b110; op = 3'b000; //out = 010
        #2 a = 3'b100; b = 3'b001; op = 3'b001; //out = 101
        #2 a = 3'b100; b = 3'b001; op = 3'b010; //out = 011
        #2 a = 3'b100; b = 3'b101; op = 3'b011; //out = 011
        #2 a = 3'b010; b = 3'b011; op = 3'b100; //out = 101
        #2 a = 3'b111; b = 3'b011; op = 3'b101; //out = 100
        #2 a = 3'b010; b = 3'b011; op = 3'b110; //out = 110
        #2 a = 3'b110; b = 3'b010; op = 3'b111; //out = 011
        #4 $finish;

    end



endmodule