module Adder (
    input wire signed [31:0]input1, 
    input wire signed [31:0]input2,
    output wire [31:0] result
);
assign result = input1 + input2 ;
endmodule
