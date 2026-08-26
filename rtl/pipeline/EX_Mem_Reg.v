`timescale 1ns / 1ps

module EX_MemReg (
    input  wire        clock,
    input  wire        reset,
    input  wire        registerWrite,
    input  wire        memoryToRegister,
    input  wire        memoryWrite,
    input  wire        memoryRead,
    input  wire [31:0] ALUresult,
    input  wire [31:0] writeData,
    input  wire [4:0]  writeRegister,
    output reg         registerWriteOut,
    output reg         memoryToRegisterOut,
    output reg         memoryWriteOut,
    output reg         memoryReadOut,
    output reg  [31:0] ALUresultOut,
    output reg  [31:0] writeDataOut,
    output reg  [4:0]  writeRegisterOut
);
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            writeDataOut         <= 32'b0;
            memoryToRegisterOut  <= 1'b0;
            writeRegisterOut     <= 5'b0;
            registerWriteOut     <= 1'b0;
            memoryWriteOut       <= 1'b0;
            memoryReadOut        <= 1'b0;
            ALUresultOut         <= 32'b0;
        end else begin
            writeDataOut         <= writeData;
            memoryToRegisterOut  <= memoryToRegister;
            writeRegisterOut     <= writeRegister;
            registerWriteOut     <= registerWrite;
            memoryWriteOut       <= memoryWrite;
            memoryReadOut        <= memoryRead;
            ALUresultOut         <= ALUresult;
        end
    end
endmodule
