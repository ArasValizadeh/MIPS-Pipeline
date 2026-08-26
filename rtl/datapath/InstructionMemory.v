`timescale 1ns / 1ps

module InstructionMemory #(
    parameter PROGRAM = "programs/fibonacci.hex",
    parameter WORDS   = 13
) (
    input  wire [31:0] pc,
    output wire [31:0] readData
);
    // Word-addressed ROM: the PC counts bytes, so the low two bits are dropped.
    // WORDS must match the number of instructions in PROGRAM.
    reg [31:0] instructionMemory [0:WORDS-1];

    wire [29:0] index = pc[31:2];

    initial $readmemh(PROGRAM, instructionMemory);

    // Fetching past the end of the program yields an all-zero word, which the
    // control unit decodes as a NOP.
    assign readData = (index < WORDS) ? instructionMemory[index] : 32'b0;
endmodule
