`include "Adder.v"
`include "ALU.v"
`include "ALUControl.v"
`include "Comparator.v"
`include "ControlUnit.v"
`include "DataMemory.v"
`include "EX_Mem_Reg.v"
`include "Forwarding.v"
`include "Hazard.v"
`include "ID_EX_Reg.v"
`include "IF_ID_Reg.v"
`include "InstructionMemory.v"
`include "Mem_Wb_Reg.v"
`include "Mux2x15Bits.v"
`include "Mux2x110Bits.v"
`include "Mux2x132Bits.v"
`include "Mux3x132Bits.v"
`include "PC.v"
`include "RegisterFile.v"
`include "ShiftLeft.v"
`include "SignExtend.v"
module MipsPipelineTestBench();
wire [31:0] nextPC, readPC, PCPlus4IF, PCPlus4ID, PCPlus4EX , branchAddress , instructionID , instructionIF , registerData1ID, registerData2ID, registerData1EX, registerData2EX , signExtendOutID, signExtendOutEX , ALUData1, ALUData2 , ALUData2Mux_1Out , ALUResultEX, ALUResultMEM, ALUResultWB , memoryWriteDataMEM , memoryReadDataMEM, memoryReadDataWB , comparatorMux1Out, comparatorMux2Out , regWriteDataMEM,shiftOut;
wire [9:0] controlSignalsID;
wire [4:0] rsEX ,rtEX ,rdEX , regDstMuxOut , writeRegMEM, writeRegWB;
wire [3:0] ALUOpID, ALUOpEX , ALUControl;
wire [1:0] upperMux_sel, lowerMux_sel , comparatorMux1Selector,comparatorMux2Selector;
reg clock, reset;
//IF_Stage
PC PCRegister(clock , nextPC ,readPC ,reset , holdPC);
Adder PCAdder(readPC, 32'h00000001 , PCPlus4IF);
InstructionMemory instructionMemory(clock, readPC, instructionIF);
Mux2x1_32Bits nextPCMux(nextPC, PCPlus4IF, branchAddress, PCMuxSel);
IF_ID_reg IF_ID(clock,PCPlus4IF, instructionIF, instructionID, holdIF_ID, PCPlus4ID, PCMuxSel);
and branchAndComparator(PCMuxSel, equalFlag, branchID);
//ID_Stage
ControlUnit controlUnit(instructionID[31:26],RegDstID,branchID,MemReadID,MemtoRegID,ALUOpID,MemWriteID,ALUSrcID,RegWriteID, reset);
RegisterFile regiterFile(clock ,instructionID[25:21], instructionID[20:16], writeRegWB, regWriteDataMEM, RegWriteWB, registerData1ID, registerData2ID, reset);
Comparator comparator(comparatorMux1Out, comparatorMux2Out, equalFlag);
Mux3x1_32Bits comparatorMux1(comparatorMux1Out, registerData1ID, ALUResultMEM, regWriteDataMEM, comparatorMux1Selector);
Mux3x1_32Bits comparatorMux2(comparatorMux2Out, registerData2ID, ALUResultMEM, regWriteDataMEM, comparatorMux2Selector);
SignExtend signExtend(instructionID[15:0], signExtendOutID);
Adder branchAdder(shiftOut, PCPlus4ID , branchAddress);
ShiftLeft2 shiftLeft2(shiftOut, signExtendOutID);
HazardDetectionUnit hazardUnit(MemReadEX, MemReadMEM, rtEX, instructionID, holdPC, holdIF_ID, hazardMuxSelector);
Mux2x1_10Bits ID_EXRegMux(controlSignalsID, {RegWriteID, MemtoRegID, MemWriteID, MemReadID, ALUSrcID, ALUOpID, RegDstID},10'b0000000000, hazardMuxSelector);
ID_EX_reg ID_EX(clock , RegWriteID, MemtoRegID, MemWriteID, MemReadID, ALUSrcID, ALUOpID, RegDstID, PCPlus4ID,registerData1ID ,registerData2ID,signExtendOutID,instructionID[25:11],PCPlus4EX ,registerData1EX ,registerData2EX ,signExtendOutEX ,rsEX ,rtEX ,rdEX,RegWriteEX,MemtoRegEX,MemWriteEX, MemReadEX,ALUSrcEX, ALUOpEX, RegDstEX);
//EX_Stage
Mux3x1_32Bits ALUData1Mux(ALUData1, registerData1EX, regWriteDataMEM, ALUResultMEM, upperMux_sel);
Mux3x1_32Bits ALUData2Mux_1(ALUData2Mux_1Out, registerData2EX, regWriteDataMEM, ALUResultMEM, lowerMux_sel);
Mux2x1_32Bits ALUData2Mux_2(ALUData2, ALUData2Mux_1Out, signExtendOutEX, ALUSrcEX);
ALUControl AluControl(ALUOpEX, signExtendOutEX[5:0] ,ALUControl);
ALU32Bit ALU(ALUData1, ALUData2, ALUControl, signExtendOutEX[10:6],reset ,overFlow, zero, ALUResultEX);
Mux2x1_5Bits regDstMux(regDstMuxOut, rtEX, rdEX, RegDstEX);
EX_MemReg EX_MEM(clock, RegWriteEX, MemtoRegEX, MemWriteEX, MemReadEX, ALUResultEX, ALUData2Mux_1Out,regDstMuxOut, RegWriteMEM, MemtoRegMEM, MemWriteMEM, MemReadMEM, ALUResultMEM, memoryWriteDataMEM, writeRegMEM);
ForwardingUnit forwardingUnit(RegWriteMEM, writeRegMEM, RegWriteWB, writeRegWB, rsEX, rtEX,upperMux_sel,lowerMux_sel, comparatorMux1Selector,comparatorMux2Selector);
//MEM_Stage
DataMemory dataMemory(clock ,MemWriteMEM, MemReadMEM, ALUResultMEM, memoryWriteDataMEM,memoryReadDataMEM);
Mem_WbReg MEM_WB(clock ,RegWriteMEM, MemtoRegMEM, ALUResultMEM, memoryReadDataMEM, writeRegMEM, RegWriteWB, MemtoRegWB,memoryReadDataWB,ALUResultWB, writeRegWB);
//WB_Stage
Mux2x1_32Bits writeBackMux(regWriteDataMEM, ALUResultWB, memoryReadDataWB, MemtoRegWB);
always @(clock)begin
#100 clock <= ~clock;
end
initial begin
clock <= 0;
reset <= 1;
#50
reset <= 0;
end
endmodule
