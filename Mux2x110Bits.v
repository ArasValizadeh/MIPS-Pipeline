module Mux2x1_10Bits(
    output reg [9:0] result,
    input [9:0] input1,
    input [9:0] input2,
    input select
);
always @(input1, input2, select) begin
    case(select)
        1'b0: begin 
			result = input1; 
		end
        1'b1: begin 
			result = input2;
		end
        default: result = 10'bx;
    endcase
end
endmodule
