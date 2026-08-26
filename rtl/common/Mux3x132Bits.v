`timescale 1ns / 1ps

module Mux3x1_32Bits (
    output reg  [31:0] result,
    input  wire [31:0] input1,
    input  wire [31:0] input2,
    input  wire [31:0] input3,
    input  wire [1:0]  select
);
    always @(*) begin
        case (select)
            2'b00:   result = input1;
            2'b01:   result = input2;
            2'b10:   result = input3;
            default: result = 32'b0;
        endcase
    end
endmodule
