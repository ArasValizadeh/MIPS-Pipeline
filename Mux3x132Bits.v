module Mux3x1_32Bits(
    output reg [31:0] result,
    input [31:0] input1, 
	input [31:0] input2, 
	input [31:0] input3,
    input [1:0] select
);
always @(input1, input2, input3, select) begin
    case(select)
        2'b00: begin 
			result = input1;
		end
        2'b01: begin 
			result = input2;
		end
        2'b10: begin
			 result = input3;
		end
        default: result = 32'bx;
    endcase
end

endmodule
