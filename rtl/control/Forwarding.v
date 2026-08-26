`timescale 1ns / 1ps

module ForwardingUnit (
    input  wire       EX_MemRegwrite,
    input  wire [4:0] EX_MemWriteReg,
    input  wire       Mem2_Regwrite,
    input  wire [4:0] Mem2_WriteReg,
    input  wire       Mem_WbRegwrite,
    input  wire [4:0] Mem_WbWriteReg,
    input  wire [4:0] ID_Ex_Rs,
    input  wire [4:0] ID_Ex_Rt,
    input  wire [4:0] IF_ID_Rs,
    input  wire [4:0] IF_ID_Rt,
    output reg  [1:0] upperMux_sel,
    output reg  [1:0] lowerMux_sel,
    output reg  [1:0] comparatorMux1Selector,
    output reg  [1:0] comparatorMux2Selector
);
    // ALU mux encoding: 00 = register file, 01 = WB, 10 = MEM1 (EX/MEM), 11 = MEM2
    // Comparator mux:   00 = register file, 01 = MEM1 ALU, 10 = WB data
    always @(*) begin
        upperMux_sel            = 2'b00;
        lowerMux_sel            = 2'b00;
        comparatorMux1Selector  = 2'b00;
        comparatorMux2Selector  = 2'b00;

        if (Mem_WbRegwrite && (Mem_WbWriteReg != 5'b0)) begin
            if (Mem_WbWriteReg == ID_Ex_Rs) upperMux_sel = 2'b01;
            if (Mem_WbWriteReg == ID_Ex_Rt) lowerMux_sel = 2'b01;
            if (Mem_WbWriteReg == IF_ID_Rs) comparatorMux1Selector = 2'b10;
            if (Mem_WbWriteReg == IF_ID_Rt) comparatorMux2Selector = 2'b10;
        end

        if (Mem2_Regwrite && (Mem2_WriteReg != 5'b0)) begin
            if (Mem2_WriteReg == ID_Ex_Rs) upperMux_sel = 2'b11;
            if (Mem2_WriteReg == ID_Ex_Rt) lowerMux_sel = 2'b11;
        end

        if (EX_MemRegwrite && (EX_MemWriteReg != 5'b0)) begin
            if (EX_MemWriteReg == ID_Ex_Rs) begin
                upperMux_sel           = 2'b10;
                comparatorMux1Selector = 2'b01;
            end
            if (EX_MemWriteReg == ID_Ex_Rt) begin
                lowerMux_sel           = 2'b10;
                comparatorMux2Selector = 2'b01;
            end
        end
    end
endmodule
