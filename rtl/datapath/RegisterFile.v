`timescale 1ns / 1ps

module RegisterFile (
    input  wire        clock,
    input  wire [4:0]  readRegister1,
    input  wire [4:0]  readRegister2,
    input  wire [4:0]  RegisterAddress,
    input  wire [31:0] WriteData,
    input  wire        writeSignal,
    output wire [31:0] ReadData1,
    output wire [31:0] ReadData2,
    input  wire        reset
);
    reg [31:0] registers [0:31];
    integer i;

    assign ReadData1 = registers[readRegister1];
    assign ReadData2 = registers[readRegister2];

    // Written on the falling edge so a value written by WB is visible to the
    // decode stage in the same cycle.
    always @(posedge reset or negedge clock) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else if (writeSignal && (RegisterAddress != 5'b0)) begin
            registers[RegisterAddress] <= WriteData;
        end
    end
endmodule
