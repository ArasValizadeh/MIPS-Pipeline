`timescale 1ns / 1ps

module ALU32Bit (
    input  wire signed [31:0] data1,
    input  wire signed [31:0] data2,
    input  wire        [3:0]  ALUControl,
    input  wire        [4:0]  shiftAmount,
    input  wire               reset,
    output reg                overflow,
    output reg                zero,
    output reg signed  [31:0] result
);
    always @(*) begin
        overflow = 1'b0;
        result   = 32'sd0;

        if (reset) begin
            zero     = 1'b0;
            result   = 32'sd0;
            overflow = 1'b0;
        end else begin
            case (ALUControl)
                4'b0000: begin // add
                    result   = data1 + data2;
                    overflow = (data1[31] == data2[31]) && (result[31] != data1[31]);
                end
                4'b0001: begin // sub
                    result = data1 - data2;
                end
                4'b1000: begin // slt / slti
                    result = (data1 < data2) ? 32'sd1 : 32'sd0;
                end
                default: begin
                    result = 32'sd0;
                end
            endcase
            zero = (result == 32'sd0);
        end
    end
endmodule
