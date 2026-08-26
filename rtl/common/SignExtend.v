`timescale 1ns / 1ps

module SignExtend (
    input  wire [15:0] input1,
    output wire [31:0] result
);
    assign result = {{16{input1[15]}}, input1};
endmodule
