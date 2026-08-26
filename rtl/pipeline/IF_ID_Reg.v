`timescale 1ns / 1ps

module IF_ID_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] PCplus4,
    input  wire [31:0] instrIn,
    output reg  [31:0] instrOut,
    input  wire        hold,
    output reg  [31:0] PCplus4Out,
    input  wire        IF_flush
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instrOut   <= 32'b0;
            PCplus4Out <= 32'b0;
        end else if (IF_flush) begin
            instrOut   <= 32'b0;
            PCplus4Out <= PCplus4;
        end else if (!hold) begin
            instrOut   <= instrIn;
            PCplus4Out <= PCplus4;
        end
    end
endmodule
