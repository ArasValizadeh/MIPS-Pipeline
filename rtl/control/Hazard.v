`timescale 1ns / 1ps

module HazardDetectionUnit (
    input  wire        ID_Ex_MemRead,
    input  wire        ID_Ex_RegWrite,
    input  wire [4:0]  ID_Ex_Rt,
    input  wire [4:0]  ID_Ex_WriteReg,
    input  wire        EX_Mem_MemRead,
    input  wire        EX_Mem_RegWrite,
    input  wire [4:0]  EX_Mem_WriteReg,
    input  wire        Mem2_MemRead,
    input  wire        Mem2_RegWrite,
    input  wire [4:0]  Mem2_WriteReg,
    input  wire [31:0] IF_ID_Instr,
    output wire        holdPC,
    output wire        holdIF_ID,
    output wire        muxSelector
);
    wire [5:0] opcode  = IF_ID_Instr[31:26];
    wire [4:0] ifid_rs = IF_ID_Instr[25:21];
    wire [4:0] ifid_rt = IF_ID_Instr[20:16];
    wire       is_beq  = (opcode == 6'b000100);

    // Sources are over-approximated: an instruction is assumed to read both rs
    // and rt. That can only cost an extra stall, never correctness.
    function sourceMatch;
        input [4:0] dest;
        begin
            sourceMatch = (dest != 5'b0) && ((dest == ifid_rs) || (dest == ifid_rt));
        end
    endfunction

    // Load-use: the loaded word is not available until the load leaves the last
    // memory stage, so the consumer must wait one cycle before forwarding works.
    wire loadUse = ID_Ex_MemRead && sourceMatch(ID_Ex_Rt);

    // Branches resolve in ID, but there is no forwarding path from EX to ID, and
    // a load in a memory stage only exposes an address there, not its data.
    wire branchOnExResult  = ID_Ex_RegWrite  && sourceMatch(ID_Ex_WriteReg);
    wire branchOnMemLoad   = EX_Mem_RegWrite && EX_Mem_MemRead && sourceMatch(EX_Mem_WriteReg);
    wire branchOnMem2Load  = Mem2_RegWrite   && Mem2_MemRead   && sourceMatch(Mem2_WriteReg);
    wire branchHazard      = is_beq && (branchOnExResult || branchOnMemLoad || branchOnMem2Load);

    wire stall = loadUse || branchHazard;

    assign holdPC      = stall;
    assign holdIF_ID   = stall;
    assign muxSelector = stall;
endmodule
