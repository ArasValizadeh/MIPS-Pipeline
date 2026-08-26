`timescale 1ns / 1ps

module Mux2x1_5Bits (
    output reg  [4:0] result,
    input  wire [4:0] input1,
    input  wire [4:0] input2,
    input  wire       select
);
    always @(*) begin
        case (select)
            1'b0:    result = input1;
            1'b1:    result = input2;
            default: result = 5'b0;
        endcase
    end
endmodule
