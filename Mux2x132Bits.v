module Mux2x1_32Bits(
    output reg [31:0] result,
    input [31:0] input1,
    input [31:0] input2,
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
        default: result = 32'bx;
    endcase
end

endmodule
