module ALU32Bit(
    input wire signed [31:0] data1, 
    input wire signed [31:0] data2, 
    input wire [3:0] ALUControl, 
    input wire [4:0] shiftAmount,
    input wire reset,
    output reg overflow, 
    output reg zero, 
    output reg signed [31:0] result
);
wire [31:0] neg_data2;
assign neg_data2 = -data2;
always @(posedge reset)begin 
    zero <= 1'b0;
end
always @(ALUControl, data1, data2) begin
    case (ALUControl)
        4'b0000: begin // add
            $display("data 1 : %d , data2: %d " , data1,data2);
            result <= data1 + data2;
            if (data1[31] == data2[31] && result[31] == ~data1[31]) begin
                overflow <= 1'b1;
            end
            else begin
                overflow <= 1'b0;
            end
        end
        4'b0001: begin // sub also used for branch
            result <= data1 + neg_data2;
            #50
            if (result == 0 )begin 
                $display("beq taken");
            end
            else begin
                $display("beq notTaken %d %d" , data1 ,data2);
            end
        end
        4'b1000: begin // less
            if (data1 < data2)begin
                $display("is less than");
                result <= 1;
            end
            else begin
                result <= 0;
            end
        end
    endcase
    if (data1 == data2) begin
        zero <= 1'b1;
    end
    else
        zero <= 1'b0;
end
endmodule
