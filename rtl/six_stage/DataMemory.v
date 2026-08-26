`timescale 1ns / 1ps

module DataMemory (
    input  wire        memoryWrite1,
    input  wire        memoryWrite2,
    input  wire        memoryRead1,
    input  wire        memoryRead2,
    input  wire [31:0] address1,
    input  wire [31:0] address2,
    input  wire [15:0] writeData1,
    input  wire [15:0] writeData2,
    input  wire        clock,
    output wire [15:0] readData1,
    output wire [15:0] readData2
);
    // A word access takes two cycles: MEM1 touches the high half, MEM2 the low
    // half. Both halves are independently addressed so a store in MEM2 and a
    // load in MEM1 can share the array in the same cycle.
    reg [31:0] memory [0:31];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            memory[i] = 32'b0;
    end

    always @(negedge clock) begin
        if (memoryWrite1)
            memory[address1[4:0]][31:16] <= writeData1;
        if (memoryWrite2)
            memory[address2[4:0]][15:0]  <= writeData2;
    end

    assign readData1 = memoryRead1 ? memory[address1[4:0]][31:16] : 16'b0;
    assign readData2 = memoryRead2 ? memory[address2[4:0]][15:0]  : 16'b0;
endmodule
