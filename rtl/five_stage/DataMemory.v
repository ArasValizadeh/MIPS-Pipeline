`timescale 1ns / 1ps

module DataMemory #(
    parameter WORDS = 1024
) (
    input  wire        clock,
    input  wire        memoryWrite,
    input  wire        memoryRead,
    input  wire [31:0] address,
    input  wire [31:0] writeData,
    output wire [31:0] readData
);
    // The address produced by the ALU is a word index (the course ISA does not
    // scale load/store offsets).
    reg [31:0] memory [0:WORDS-1];
    integer i;

    initial begin
        for (i = 0; i < WORDS; i = i + 1)
            memory[i] = 32'b0;
    end

    always @(negedge clock) begin
        if (memoryWrite)
            memory[address[9:0]] <= writeData;
    end

    assign readData = memoryRead ? memory[address[9:0]] : 32'b0;
endmodule
