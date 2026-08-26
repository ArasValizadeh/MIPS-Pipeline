`timescale 1ns / 1ps

module Comparator (
    input  wire [31:0] input1,
    input  wire [31:0] input2,
    output wire        result
);
    assign result = (input1 == input2);
endmodule
