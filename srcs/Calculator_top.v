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
    output wire [7:0] seg,
    output reg bin_ind
);

    reg [2:0] op = 3'b0; 
    wire [7:0] calculator_result; // Output from calculator module
    reg [31:0] display_value; // Value displayed to the seven segment display
    reg convert_value_enable; //Enable signal 

    /*------------------BUTTON INPUT------------------*/
    //Debounce buttons 
    wire up_d; wire down_d; wire enter_d; wire back_d; wire rst_d;  
    Debounce dd(.btn(down), .clk(clk), .led(down_d));
    Debounce ud(.btn(up), .clk(clk), .led(up_d));
    Debounce ed(.btn(enter), .clk(clk), .led(enter_d));
    Debounce bd(.btn(back), .clk(clk), .led(back_d));
    Debounce rd(.btn(rst), .clk(clk), .led(rst_d)); 

    /*------------------CALCULATION AND CONVERSION MODULES------------------*/
    // Instantiate Calculator 
    Calculator calc(.a(a), .b(b), .op(op), .out(calculator_result));

    //Convert stable calculator result into seven segment display values 
    wire [15:0] BCD_result; 
    reg [11:0] value_to_convert; 
    wire bcd_val_rdy; 

    val_bcd VAL(.clk(clk), .reset(rst_d), .en(convert_value_enable), .count(value_to_convert), .rdy(bcd_val_rdy), .BCD(BCD_result));

    //Generate the display_value from calc-->BCD
    wire [31:0] BCD_seg;
    reg [31:0] BCD_seg_buffer;
    bcd_seg A(.BCD(BCD_result[15:12]),.s(BCD_seg[31:24]));
    bcd_seg B(.BCD(BCD_result[11:8]),.s(BCD_seg[23:16]));
    bcd_seg C(.BCD(BCD_result[7:4]),.s(BCD_seg[15:8]));
    bcd_seg D(.BCD(BCD_result[3:0]),.s(BCD_seg[7:0]));

    wire [31:0] op_seg;
    op_seg OPS(.OP(op), .s(op_seg)); 
    parameter DISP_ZEROS = 32'b0000_0011_0000_0011_0000_0011_0000_0011;

    //Drive multi segment displays
    Multi_Driver md(.segValues(display_value), .clk(clk), .an(an), .seg(seg));

    /*------------------FSM LOGIC------------------*/

    //States for the control unit
    parameter IDLE = 0; //all 0s after reset
    parameter VALUE_SET = 1;
    parameter CONV = 2; //wait for value to bcd
    parameter RES = 3; //display result
    parameter OP = 4; //operation menu

    reg [1:0] result_neg; 

    reg [2:0] cs; //current state
    reg [2:0] ns; //next state
    //Control unit 
    always @(posedge clk) begin
        if(op < 4) begin // logic operation, display binary
            value_to_convert <= (1000 * calculator_result[3]) + (100 * calculator_result[2]) + (10 * calculator_result[1]) + (calculator_result[0]);
            
        end 
        else if(op == 5) begin //Subtraction, check if positive 
             if(calculator_result[7]) begin //Sign bit is negative
                 result_neg[0] <= 1; 

                 value_to_convert <= {{8{1'b0}}, ((~calculator_result) + 1) & 4'b1111}; // Make positive 
                 if((((~calculator_result) + 1) & 4'b1111) >= 10) result_neg[1] <= 1;
                 else result_neg[1] <= 0; 
             end
             else value_to_convert <= {{4{1'b0}}, calculator_result}; 
        end 
        else begin
            value_to_convert <= {{4{1'b0}}, calculator_result}; 
        end
        if(rst_d == 1) begin
            op <= 0; 
            convert_value_enable <= 0; 
            ns <= IDLE;
            result_neg <= 0;
            display_value <= DISP_ZEROS;
        end
        else begin
            case (cs)
                IDLE: begin
                    display_value <= DISP_ZEROS; 
                    op <= 0;
                    if(ENTER) begin
                        ns <= CONV;
                    end
                    else if (UP | DOWN) begin
                        ns <= OP;
                        op <= 0; 
                    end
                end


                // VALUE_SET: begin
                //     if(op < 4) begin // logic operation, display binary
                //         value_to_convert <= (1000 * calculator_result[3]) + (100 * calculator_result[2]) + (10 * calculator_result[1]) + (1* calculator_result[0]);
                //     end 
                //     else if(op == 5) begin //Subtraction, check if positive 
                //         if(calculator_result[7]) begin //Sign bit is negative
                //             value_to_convert <= {{4{1'b0}}, (~calculator_result) + 1}; // Make positive 
                //         end
                //         else value_to_convert <= {{4{1'b0}}, calculator_result}; 
                //     end 
                //     else begin
                //         value_to_convert <= {{4{1'b0}}, calculator_result}; 
                //     end
                //     ns <= CONV;
                // end


                CONV: begin
                    if(op >= 5) begin
                        bin_ind <= 0; 
                    end else begin
                        bin_ind <= 1; 
                    end
                    display_value <= op_seg; 
                    convert_value_enable <= 1; 
                    if(bcd_val_rdy) begin
                        ns <= RES;
                        convert_value_enable <= 0;
                        if(result_neg[0]) begin //Negative value, insert - sign on third display
                            if(result_neg[1]) begin
                                BCD_seg_buffer <= {16'b1111_1111_1111_1101, BCD_seg[15:0]}; //Extract last two converted segment values, insert negative sign
                            end else begin
                                BCD_seg_buffer <= {24'b1111_1111_1111_1111_1111_1101, BCD_seg[7:0]}; //Extract last two converted segment values, insert negative sign
                            end
                            result_neg <= 2'b0; 
                        end else begin
                            BCD_seg_buffer <= BCD_seg;
                        end
                    end
                    else ns <= CONV; 
                end
                RES: begin
                    result_neg <= 2'b0;
                    display_value <= BCD_seg_buffer; 
                    if (BACK) begin
                        ns <= IDLE;
                    end
                    else if (ENTER) begin
                        ns <= CONV;
                    end
                    else if (UP | DOWN) begin
                        ns <= OP;
                        op <= 0;
                    end
                    else ns <= RES;
                end
                OP: begin
                    result_neg <= 2'b0;
                    display_value <= op_seg; 
                    if (ENTER) begin
                        ns <= CONV;
                    end
                    else if(BACK) begin
                        ns <= RES;
                    end else begin
                        ns <= OP; 
                    end

                    if(UP) begin
                        op <= op + 1;
                    end
                    else if(DOWN) begin
                        op <= op - 1;
                    end
                end

            endcase 
        end

    end

    wire DOWN; wire UP; wire BACK; wire ENTER;
    edge_generator de(.clk(clk), .rst(rst_d), .signal(down_d), .out(DOWN));
    edge_generator ue(.clk(clk), .rst(rst_d), .signal(back_d), .out(BACK));
    edge_generator be(.clk(clk), .rst(rst_d), .signal(up_d), .out(UP));
    edge_generator ee(.clk(clk), .rst(rst_d), .signal(enter_d), .out(ENTER));

    

    always @(negedge clk) begin
        if(rst_d) begin
            cs <= IDLE; 
        end
        else begin
            cs <= ns; 
        end
    end


endmodule
