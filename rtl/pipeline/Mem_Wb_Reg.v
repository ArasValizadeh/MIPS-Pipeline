`timescale 1ns / 1ps

module Mem_WbReg (
    input  wire        clock,
    input  wire        reset,
    input  wire        registerWrite,
    input  wire        memoryToRegister,
    input  wire [31:0] ALUresult,
    input  wire [31:0] readData,
    input  wire [4:0]  writeRegister,
    output reg         registerWriteOut,
    output reg         memoryToRegisterOut,
    output reg  [31:0] readDataOut,
    output reg  [31:0] ALUresultOut,
    output reg  [4:0]  writeRegisterOut
);
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            registerWriteOut    <= 1'b0;
            memoryToRegisterOut <= 1'b0;
            readDataOut         <= 32'b0;
            ALUresultOut        <= 32'b0;
            writeRegisterOut    <= 5'b0;
        end else begin
            registerWriteOut    <= registerWrite;
            memoryToRegisterOut <= memoryToRegister;
            readDataOut         <= readData;
            ALUresultOut        <= ALUresult;
            writeRegisterOut    <= writeRegister;
        end
    end
endmodule
