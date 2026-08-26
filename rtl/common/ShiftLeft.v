`timescale 1ns / 1ps

module ShiftLeft2 (
    output wire [31:0] result,
    input  wire [31:0] input1
);
    assign result = input1 << 2;
endmodule
