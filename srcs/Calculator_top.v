`timescale 1ns / 1ps
`default_nettype none

module Calculator_top(

    input wire [3:0] a, 
    input wire [3:0] b,
    input wire clk, 
    input wire rst, 
    input wire enter, 
    input wire back,
    input wire up, 
    input wire down,
    output wire [3:0] an, 
    output wire [7:0] seg
);

    reg [2:0] op = 3'b0; 
    // Debounced buttons
    wire up_d; wire down_d; wire enter_d; wire back_d; wire rst_d;  
    wire [7:0] calculator_result; // Output from calculator module
    reg [31:0] segments; // Value displayed to the seven segment display
    reg convert_value_enable; //Enable signal 

    //States for the control unit
    parameter IDLE = 0; //all 0s after reset
    parameter VALUE_SET = 1;
    parameter CONV = 2; //wait for value to bcd
    parameter RES = 3; //display result
    parameter OP = 4; //operation menu


    reg [2:0] cs; //current state
    reg [2:0] ns; //next state
    //Control unit 
    always @(*) begin
        if(rst == 1) begin
            op <= 0; 
        end
        case(cs)
            IDLE: begin
                segments <= 0; 
                if(enter_d) begin
                    ns <= VALUE_SET;
                end
                else if (up_d | down_d) begin
                    ns <= OP;
                end
            end
            VALUE_SET: begin
                if(op < 4) begin // logic operation, display binary
                    value_to_convert <= (1000 * calculator_result[3]) + (100 * calculator_result[2]) + (10 * calculator_result[1]) + (1* calculator_result[0]);
                end else if(op == 5) begin //Subtraction, check if positive 
                    if(calculator_result[7]) begin //Sign bit is negative
                        value_to_convert <= {4{1'b0}, (~calculator_result) + 1}; // Make positive 
                    end
                    else value_to_convert <= {{4{1'b0}}, calculator_result}; 
                end else begin
                    value_to_convert <= {{4{1'b0}}, calculator_result}; 
                end
                ns <= CONV;
            end
            CONV: begin
                segments <= segValues_op; 
                convert_value_enable <= 1; 
                if(bcd_val_rdy) begin
                    ns <= RES;
                end
                else ns <= CONV; 
            end
            RES: begin
                segments <= segValues_res; 
                if (back_d) begin
                    ns <= IDLE;
                end
                else if (enter_d) begin
                    ns <= VALUE_SET;
                end
            end
            OP: begin
                segments <= segValues_op; 
                if (enter_d) begin
                    ns <= VALUE_SET;
                end
                else if(back_d) begin
                    ns <= RES;
                end
                else if(up_d) begin
                    op <= op + 1;
                end
                else if(down_d) begin
                    op <= op - 1;
                end
            end

        endcase 

    end

    always @(posedge clk) begin
        if(rst_d) begin
            cs <= IDLE; 
        end
        else begin
            cs <= ns; 
        end
    end

    // Handle op code scrolling 
    // always @ (posedge up_d or posedge down_d) begin
    //     if(up_d) begin
    //         op <= op + 1; 
    //     end
    //     else if(down_d) begin
    //         op <= op - 1; 
    //     end
    // end

    //Debounce buttons 
    Debounce dd(.btn(down), .clk(clk), .led(down_d));
    Debounce ud(.btn(up), .clk(clk), .led(up_d));
    Debounce ed(.btn(enter), .clk(clk), .led(enter_d));
    Debounce bd(.btn(back), .clk(clk), .led(back_d));
    Debounce rd(.btn(rst), .clk(clk), .led(rst_d)); 

    // Instantiate Calculator 
    Calculator calc(.a(a), .b(b), .op(op), .out(calculator_result));

    //Convert stable calculator result into seven segment display values 
    wire [31:0] segValues_res; 
    wire [15:0] calc_result_bcd; 
    reg [11:0] value_to_convert; 
    wire bcd_val_rdy; 

    val_bcd vbcd(
        .clk(clk),  
        .reset(rst_d), 
        .en(convert_value_enable), // Enable 
        .count(value_to_convert), 
        .BCD(calc_result_bcd),
        .rdy(bcd_val_rdy)
    );


    //Convert all values to seven segment outputs
    genvar i;
    generate 
        for(i = 0; i < 4; i = i + 1) begin
            bcd_seg x(.sw(calc_result_bcd[3 + 4 * i:4 * i]), segValues_res[8 * i + 1 : 8 * i]); 
        end
    endgenerate

    wire [31:0] segValues_op; 
    op_seg y(.OP(op), .s(segValues_op));

    //Drive multi segment displays
    Multi_Driver md(.segValues(segments), .clk(clk), .an(an), .seg(seg));

endmodule
