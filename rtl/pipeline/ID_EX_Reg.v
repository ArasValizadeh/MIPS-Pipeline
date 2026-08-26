`timescale 1ns / 1ps

module ID_EX_reg (
    input  wire        clock,
    input  wire        reset,
    input  wire        registerWrite,
    input  wire        memoryToRegister,
    input  wire        memoryWrite,
    input  wire        memoryRead,
    input  wire        ALUSrc,
    input  wire [3:0]  ALUOp,
    input  wire        registerDestination,
    input  wire [31:0] PCplus4,
    input  wire [31:0] data1Input,
    input  wire [31:0] data2Input,
    input  wire [31:0] signExtendResultInput,
    input  wire [14:0] registerAddressInput,
    output reg  [31:0] PCplus4out,
    output reg  [31:0] data1Output,
    output reg  [31:0] data2Output,
    output reg  [31:0] signExtendResultOutput,
    output reg  [4:0]  rsOut,
    output reg  [4:0]  rtOut,
    output reg  [4:0]  rdOut,
    output reg         registerWriteOutput,
    output reg         memoryToRegisterOutput,
    output reg         memoryWriteOutput,
    output reg         memoryReadOutput,
    output reg         ALUSrcOut,
    output reg  [3:0]  ALUOpOut,
    output reg         registerDestinationOut
);
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            PCplus4out              <= 32'b0;
            data1Output             <= 32'b0;
            data2Output             <= 32'b0;
            signExtendResultOutput  <= 32'b0;
            rsOut                   <= 5'b0;
            rtOut                   <= 5'b0;
            rdOut                   <= 5'b0;
            registerWriteOutput     <= 1'b0;
            memoryToRegisterOutput  <= 1'b0;
            memoryWriteOutput       <= 1'b0;
            memoryReadOutput        <= 1'b0;
            ALUSrcOut               <= 1'b0;
            ALUOpOut                <= 4'b0;
            registerDestinationOut  <= 1'b0;
        end else begin
            PCplus4out              <= PCplus4;
            data1Output             <= data1Input;
            data2Output             <= data2Input;
            signExtendResultOutput  <= signExtendResultInput;
            rsOut                   <= registerAddressInput[14:10];
            rtOut                   <= registerAddressInput[9:5];
            rdOut                   <= registerAddressInput[4:0];
            registerWriteOutput     <= registerWrite;
            memoryToRegisterOutput  <= memoryToRegister;
            memoryWriteOutput       <= memoryWrite;
            memoryReadOutput        <= memoryRead;
            ALUSrcOut               <= ALUSrc;
            ALUOpOut                <= ALUOp;
            registerDestinationOut  <= registerDestination;
        end
    end
endmodule
