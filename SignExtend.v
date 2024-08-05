module SignExtend (
    input [15:0] input1,
    output reg [31:0] result
);
always @(input1) begin
    if (input1[15] == 1)  begin     
        result = {16'hffff, input1};
    end
    else if (input1[15] == 0) begin
         result = {16'h0000, input1};
    end
    else begin
        result = 32'hxxxx_xxxx;
    end
end
endmodule
