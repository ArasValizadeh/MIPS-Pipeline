module Mem_WbReg(
  input clock,
  input registerWrite, 
  input memoryToRegister,
  input [31:0] ALUresult,
  input [31:0] readData,
  input [4:0] writeRegister,
  output reg registerWriteOut,
  output reg memoryToRegisterOut,
  output reg[31:0] readDataOut,
  output reg [31:0] ALUresultOut,
  output reg [4:0] writeRegisterOut
);
always@(posedge clock)begin
      registerWriteOut<=registerWrite;
      memoryToRegisterOut<=memoryToRegister;
      readDataOut<=readData;
      ALUresultOut<=ALUresult;
      writeRegisterOut<=writeRegister;
end  
endmodule