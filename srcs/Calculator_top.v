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
    
    
    
    reg [2:0] cs;
    reg [2:0] ns;
    
    parameter IDLE = 0;
    parameter OP = 1;
    parameter CONV = 2;
    parameter RES = 3;
    
    
    wire [7:0] calc_result;
    reg [2:0] op;
    
    Calculator CALC(.a(a),.b(b),.op(op), .out(calc_result));
    
   
    wire [15:0] BCD_result;
    wire BCD_rdy;
    val_bcd VAL(.clk(clk),.reset(rst), .count({{4{1'b0}}, calc_result}), .rdy(BCD_rdy), .BCD(BCD_result));
    
    
    wire [31:0] BCD_seg;
    reg [31:0] BCD_seg_buffer;
    bcd_seg A(.BCD(BCD_result[15:12]),.s(BCD_seg[31:24]));
    bcd_seg B(.BCD(BCD_result[11:8]),.s(BCD_seg[23:16]));
    bcd_seg C(.BCD(BCD_result[7:4]),.s(BCD_seg[15:8]));
    bcd_seg D(.BCD(BCD_result[3:0]),.s(BCD_seg[7:0]));
    
    
    wire [31:0] op_seg;
    op_seg OPS(.OP(op), .s(op_seg)); 
    
    parameter ZEROS = 32'b0000_0011_0000_0011_0000_0011_0000_0011;
    
    reg [31:0] display_value;
    Multi_Driver DRIVER(.clk(clk), .segValues(display_value), .an(an), .seg(seg));
    
    wire up_d;
    wire down_d;
    wire enter_d;
    wire back_d;
    wire rst_d;
    Debounce UDB(.btn(up),.clk(clk),.led(up_d));
    Debounce DDB(.btn(down),.clk(clk),.led(down_d));
    Debounce EDB(.btn(enter),.clk(clk),.led(enter_d));
    Debounce BDB(.btn(back),.clk(clk),.led(back_d));
    Debounce RDB(.btn(rst),.clk(clk),.led(rst_d));
    
    
    reg UP;  
    reg UP_p; 
    always @(posedge clk) begin
        if(rst_d == 1) begin
            UP <= 0;
            UP_p <= 0;
        end
        if((UP_p != up_d) && (up_d)) begin
            UP <= 1; 
        end 
        else UP <= 0; 
        UP_p <= up_d;
    end
    reg DOWN; 
    reg DOWN_p;
    always @(posedge clk) begin
        if(rst_d == 1) begin
            DOWN <= 0;
            DOWN_p <= 0;
        end
        if((DOWN_p != down_d) && (down_d)) begin
            DOWN <= 1; 
        end 
        else DOWN <= 0; 
        DOWN_p <= down_d;
    end
    reg BACK; 
    reg BACK_p; 
    always @(posedge clk) begin
        if(rst_d == 1) begin
            BACK <= 0;
            BACK_p <= 0;
        end
        if((BACK_p != back_d) && (back_d)) begin
            BACK <= 1; 
        end 
        else BACK <= 0; 
        BACK_p <= back_d;
    end
    
    
    always@(posedge clk) begin
        if(rst_d) begin
            ns <= IDLE;
            display_value <= ZEROS;
        end
        else begin
            case (cs)
                IDLE: begin
                    display_value <= ZEROS;
                    op <= 0;
                    if(UP | DOWN) begin
                        ns <= OP;
                        op <= 0;
                    end
                    else if(enter_d)
                        ns <= CONV;
                end
                OP: begin
                    display_value <= op_seg;
                    
                    if(up_d)
                        op = op + 1;
                    else if (down_d)
                        op = op - 1;
                    
                    if(enter_d)
                        ns <= CONV;
                    else if(BACK)
                        ns <= RES;
                end
                CONV: begin
                    display_value <= op_seg;
                    if(BCD_rdy)
                        BCD_seg_buffer <= BCD_seg;
                        ns <= RES;
                end
                RES: begin
                    display_value <= BCD_seg_buffer;
                    if(UP | DOWN) begin
                        ns <= OP;
                        op <= 0;
                    end
                    else if(enter_d)
                        ns <= CONV;
                    //else if(BACK)
                        //ns <= IDLE;
                end
                default: begin
                    ns <= IDLE;
                    display_value <= ZEROS;
                    op <= 0;
                end
        
        
        
            endcase
        end
    end
    
    always @(negedge clk) begin
            cs <= ns;
    end
