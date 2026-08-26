`timescale 1ns / 1ps

module ControlUnit (
    input  wire [5:0] opCode,
    output reg        registerDestination,
    output reg        branch,
    output reg        memoryRead,
    output reg        memoryToRegister,
    output reg  [3:0] ALUop,
    output reg        memoryWrite,
    output reg        AluSrc,
    output reg        registerWrite,
    input  wire       reset
);
    always @(*) begin
        registerDestination = 1'b0;
        branch              = 1'b0;
        memoryRead          = 1'b0;
        memoryToRegister    = 1'b0;
        ALUop               = 4'b0000;
        memoryWrite         = 1'b0;
        AluSrc              = 1'b0;
        registerWrite       = 1'b0;

        if (!reset) begin
            case (opCode)
                6'b000000: begin // R-type
                    registerDestination = 1'b1;
                    registerWrite       = 1'b1;
                    ALUop               = 4'b0010;
                end
                6'b001010: begin // slti
                    AluSrc        = 1'b1;
                    registerWrite = 1'b1;
                    ALUop         = 4'b0101;
                end
                6'b100011: begin // lw
                    memoryRead       = 1'b1;
                    memoryToRegister = 1'b1;
                    AluSrc           = 1'b1;
                    registerWrite    = 1'b1;
                    ALUop            = 4'b0000;
                end
                6'b101011: begin // sw
                    memoryWrite = 1'b1;
                    AluSrc      = 1'b1;
                    ALUop       = 4'b0000;
                end
                6'b000100: begin // beq
                    branch = 1'b1;
                    ALUop  = 4'b0001;
                end
                default: begin
                end
            endcase
        end
    end
endmodule
