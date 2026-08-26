`timescale 1ns / 1ps

module MipsPipeline #(
    parameter PROGRAM       = "programs/two_cycle_memory.hex",
    parameter PROGRAM_WORDS = 5
) (
    input wire clock,
    input wire reset
);
    wire [31:0] nextPC, readPC, PCPlus4IF, PCPlus4ID, PCPlus4EX;
    wire [31:0] branchAddress, instructionID, instructionIF;
    wire [31:0] registerData1ID, registerData2ID, registerData1EX, registerData2EX;
    wire [31:0] signExtendOutID, signExtendOutEX;
    wire [31:0] ALUData1, ALUData2, ALUData2Mux_1Out;
    wire [31:0] ALUResultEX, ALUResultMEM, ALUResultWB;
    wire [31:0] memoryWriteDataMEM, memoryReadDataWB;
    wire [31:0] comparatorMux1Out, comparatorMux2Out, regWriteDataMEM, shiftOut;
    wire [9:0]  controlSignalsID;
    wire [4:0]  rsEX, rtEX, rdEX, regDstMuxOut, writeRegMEM, writeRegWB;
    wire [3:0]  ALUOpID, ALUOpEX, ALUControl;
    wire [1:0]  upperMux_sel, lowerMux_sel, comparatorMux1Selector, comparatorMux2Selector;

    wire holdPC, holdIF_ID, hazardMuxSelector, PCMuxSel, equalFlag;
    wire overFlow, zero;
    wire RegDstID, branchID, MemReadID, MemtoRegID, MemWriteID, ALUSrcID, RegWriteID;
    wire RegWriteEX, MemtoRegEX, MemWriteEX, MemReadEX, ALUSrcEX, RegDstEX;
    wire RegWriteMEM, MemtoRegMEM, MemWriteMEM, MemReadMEM;
    wire RegWriteWB, MemtoRegWB;

    wire        MemWrite2, MemRead2, RegWriteMEM2, MemtoRegMEM2;
    wire [4:0]  writeRegMEM2;
    wire [15:0] memoryWriteData2, memoryReadDataHigh1, memoryReadDataHigh2, memoryReadDataLow2;
    wire [31:0] address2;
    wire [31:0] memReadFull;
    wire [31:0] mem2ForwardData;

    assign memReadFull     = {memoryReadDataHigh2, memoryReadDataLow2};
    assign mem2ForwardData = MemtoRegMEM2 ? memReadFull : address2;

    assign PCMuxSel = branchID & equalFlag & ~holdIF_ID;

    // ------------------------------------------------------------------ IF
    PC PCRegister (clock, nextPC, readPC, reset, holdPC);
    Adder PCAdder (readPC, 32'd4, PCPlus4IF);
    InstructionMemory #(.PROGRAM(PROGRAM), .WORDS(PROGRAM_WORDS)) instructionMemory (readPC, instructionIF);
    Mux2x1_32Bits nextPCMux (nextPC, PCPlus4IF, branchAddress, PCMuxSel);
    IF_ID_reg IF_ID (clock, reset, PCPlus4IF, instructionIF, instructionID, holdIF_ID, PCPlus4ID, PCMuxSel);

    // ------------------------------------------------------------------ ID
    ControlUnit controlUnit (
        instructionID[31:26], RegDstID, branchID, MemReadID, MemtoRegID,
        ALUOpID, MemWriteID, ALUSrcID, RegWriteID, reset
    );
    RegisterFile regFile (
        clock, instructionID[25:21], instructionID[20:16], writeRegWB,
        regWriteDataMEM, RegWriteWB, registerData1ID, registerData2ID, reset
    );
    Comparator comparator (comparatorMux1Out, comparatorMux2Out, equalFlag);
    Mux3x1_32Bits comparatorMux1 (comparatorMux1Out, registerData1ID, ALUResultMEM, regWriteDataMEM, comparatorMux1Selector);
    Mux3x1_32Bits comparatorMux2 (comparatorMux2Out, registerData2ID, ALUResultMEM, regWriteDataMEM, comparatorMux2Selector);
    SignExtend signExtend (instructionID[15:0], signExtendOutID);
    ShiftLeft2 shiftLeft2 (shiftOut, signExtendOutID);
    Adder branchAdder (shiftOut, PCPlus4ID, branchAddress);

    HazardDetectionUnit hazardUnit (
        .ID_Ex_MemRead   (MemReadEX),
        .ID_Ex_RegWrite  (RegWriteEX),
        .ID_Ex_Rt        (rtEX),
        .ID_Ex_WriteReg  (regDstMuxOut),
        .EX_Mem_MemRead  (MemReadMEM),
        .EX_Mem_RegWrite (RegWriteMEM),
        .EX_Mem_WriteReg (writeRegMEM),
        .Mem2_MemRead    (MemRead2),
        .Mem2_RegWrite   (RegWriteMEM2),
        .Mem2_WriteReg   (writeRegMEM2),
        .IF_ID_Instr     (instructionID),
        .holdPC          (holdPC),
        .holdIF_ID       (holdIF_ID),
        .muxSelector     (hazardMuxSelector)
    );
    Mux2x1_10Bits ID_EXRegMux (
        controlSignalsID,
        {RegWriteID, MemtoRegID, MemWriteID, MemReadID, ALUSrcID, ALUOpID, RegDstID},
        10'b0,
        hazardMuxSelector
    );
    ID_EX_reg ID_EX (
        clock, reset,
        controlSignalsID[9], controlSignalsID[8], controlSignalsID[7], controlSignalsID[6],
        controlSignalsID[5], controlSignalsID[4:1], controlSignalsID[0],
        PCPlus4ID, registerData1ID, registerData2ID, signExtendOutID, instructionID[25:11],
        PCPlus4EX, registerData1EX, registerData2EX, signExtendOutEX, rsEX, rtEX, rdEX,
        RegWriteEX, MemtoRegEX, MemWriteEX, MemReadEX, ALUSrcEX, ALUOpEX, RegDstEX
    );

    // ------------------------------------------------------------------ EX
    Mux4x1_32Bits ALUData1Mux (ALUData1, registerData1EX, regWriteDataMEM, ALUResultMEM, mem2ForwardData, upperMux_sel);
    Mux4x1_32Bits ALUData2Mux_1 (ALUData2Mux_1Out, registerData2EX, regWriteDataMEM, ALUResultMEM, mem2ForwardData, lowerMux_sel);
    Mux2x1_32Bits ALUData2Mux_2 (ALUData2, ALUData2Mux_1Out, signExtendOutEX, ALUSrcEX);
    ALUControl AluControl (ALUOpEX, signExtendOutEX[5:0], ALUControl);
    ALU32Bit ALU (ALUData1, ALUData2, ALUControl, signExtendOutEX[10:6], reset, overFlow, zero, ALUResultEX);
    Mux2x1_5Bits regDstMux (regDstMuxOut, rtEX, rdEX, RegDstEX);
    EX_MemReg EX_MEM (
        clock, reset, RegWriteEX, MemtoRegEX, MemWriteEX, MemReadEX,
        ALUResultEX, ALUData2Mux_1Out, regDstMuxOut,
        RegWriteMEM, MemtoRegMEM, MemWriteMEM, MemReadMEM,
        ALUResultMEM, memoryWriteDataMEM, writeRegMEM
    );
    ForwardingUnit forwardingUnit (
        .EX_MemRegwrite        (RegWriteMEM),
        .EX_MemWriteReg        (writeRegMEM),
        .Mem2_Regwrite         (RegWriteMEM2),
        .Mem2_WriteReg         (writeRegMEM2),
        .Mem_WbRegwrite        (RegWriteWB),
        .Mem_WbWriteReg        (writeRegWB),
        .ID_Ex_Rs              (rsEX),
        .ID_Ex_Rt              (rtEX),
        .IF_ID_Rs              (instructionID[25:21]),
        .IF_ID_Rt              (instructionID[20:16]),
        .upperMux_sel          (upperMux_sel),
        .lowerMux_sel          (lowerMux_sel),
        .comparatorMux1Selector(comparatorMux1Selector),
        .comparatorMux2Selector(comparatorMux2Selector)
    );

    // ------------------------------------------------------- MEM1 / MEM2
    DataMemory dataMemory (
        .memoryWrite1(MemWriteMEM),
        .memoryWrite2(MemWrite2),
        .memoryRead1 (MemReadMEM),
        .memoryRead2 (MemRead2),
        .address1    (ALUResultMEM),
        .address2    (address2),
        .writeData1  (memoryWriteDataMEM[31:16]),
        .writeData2  (memoryWriteData2),
        .clock       (clock),
        .readData1   (memoryReadDataHigh1),
        .readData2   (memoryReadDataLow2)
    );
    Mem1_Mem2_Reg Mem1_Mem2 (
        .clk                (clock),
        .reset              (reset),
        .MemWriteMEM        (MemWriteMEM),
        .MemReadMEM         (MemReadMEM),
        .RegWriteMEM        (RegWriteMEM),
        .MemtoRegMEM        (MemtoRegMEM),
        .writeRegMEM        (writeRegMEM),
        .memoryWriteDataMEM (memoryWriteDataMEM[15:0]),
        .memoryReadData1    (memoryReadDataHigh1),
        .ALUResultMEM       (ALUResultMEM),
        .MemWrite2          (MemWrite2),
        .MemRead2           (MemRead2),
        .RegWriteMEM2       (RegWriteMEM2),
        .MemtoRegMEM2       (MemtoRegMEM2),
        .writeRegMEM2       (writeRegMEM2),
        .memoryWriteData2   (memoryWriteData2),
        .memoryReadDataHigh (memoryReadDataHigh2),
        .address2           (address2)
    );
    Mem_WbReg MEM_WB (
        clock, reset, RegWriteMEM2, MemtoRegMEM2, address2, memReadFull, writeRegMEM2,
        RegWriteWB, MemtoRegWB, memoryReadDataWB, ALUResultWB, writeRegWB
    );

    // ------------------------------------------------------------------ WB
    Mux2x1_32Bits writeBackMux (regWriteDataMEM, ALUResultWB, memoryReadDataWB, MemtoRegWB);
endmodule
