module Comparator(
    input [31:0]input1 ,
    input [31:0]input2 ,
    output result
);
assign result = (input1 == input2) ? 1'b1 : 1'b0;
endmodule
