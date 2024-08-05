module Mem1_Mem2_Reg (MemWriteMEM, MemWrite2, MemReadMEM, MemRead2, ALUResultMEM, address2, 
memoryWriteDataMEM, memoryWriteData2, clk, memoryReadData1, memoryReadDataMEM, 
RegWriteMEM, RegWriteMEM2, MemtoRegMEM, MemtoRegMEM2,
writeRegMEM, writeRegMEM2, RegWriteWB, RegWriteWB2, writeRegWB, writeRegWB2);
  input clk;
  input MemWriteMEM, MemReadMEM, RegWriteMEM, MemtoRegMEM, RegWriteWB;
  input [4:0] writeRegMEM, writeRegWB;
  input [15:0] memoryWriteDataMEM, memoryReadData1;
  input [31:0] ALUResultMEM;

  output reg MemWrite2, MemRead2, RegWriteMEM2, MemtoRegMEM2, RegWriteWB2;
  output reg [4:0] writeRegMEM2, writeRegWB2;
  output reg [15:0] memoryWriteData2, memoryReadDataMEM;
  output reg [31:0] address2;

  
  always@(posedge clk)
    begin
      
        MemWrite2 <= MemWriteMEM;
        MemRead2 <= MemReadMEM; 
        RegWriteMEM2 <= RegWriteMEM; 
        MemtoRegMEM2 <= MemtoRegMEM;
        RegWriteWB2 <= RegWriteWB;
        writeRegMEM2 <= writeRegMEM;
        writeRegWB2 <= writeRegWB;
        memoryWriteData2 <= memoryWriteDataMEM;
        memoryReadDataMEM <= memoryReadData1;
        address2 <= ALUResultMEM;
      
    end
  
  
endmodule