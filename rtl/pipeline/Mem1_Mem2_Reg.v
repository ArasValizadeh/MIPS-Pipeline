`timescale 1ns / 1ps

module Mem1_Mem2_Reg (
    input  wire        clk,
    input  wire        reset,
    input  wire        MemWriteMEM,
    input  wire        MemReadMEM,
    input  wire        RegWriteMEM,
    input  wire        MemtoRegMEM,
    input  wire [4:0]  writeRegMEM,
    input  wire [15:0] memoryWriteDataMEM,
    input  wire [15:0] memoryReadData1,
    input  wire [31:0] ALUResultMEM,
    output reg         MemWrite2,
    output reg         MemRead2,
    output reg         RegWriteMEM2,
    output reg         MemtoRegMEM2,
    output reg  [4:0]  writeRegMEM2,
    output reg  [15:0] memoryWriteData2,
    output reg  [15:0] memoryReadDataHigh,
    output reg  [31:0] address2
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MemWrite2          <= 1'b0;
            MemRead2           <= 1'b0;
            RegWriteMEM2       <= 1'b0;
            MemtoRegMEM2       <= 1'b0;
            writeRegMEM2       <= 5'b0;
            memoryWriteData2   <= 16'b0;
            memoryReadDataHigh <= 16'b0;
            address2           <= 32'b0;
        end else begin
            MemWrite2          <= MemWriteMEM;
            MemRead2           <= MemReadMEM;
            RegWriteMEM2       <= RegWriteMEM;
            MemtoRegMEM2       <= MemtoRegMEM;
            writeRegMEM2       <= writeRegMEM;
            memoryWriteData2   <= memoryWriteDataMEM;
            memoryReadDataHigh <= memoryReadData1;
            address2           <= ALUResultMEM;
        end
    end
endmodule
